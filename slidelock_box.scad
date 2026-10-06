/*
Parametric box generator with slide lock. 
Quick Manual:

- If the inner dimensions are critical, easily add '2*th' to the values. 
- Beware of the latch mechanism: it ned two material thickness more.
- For laser cut or other two dimensional machining processes, set 'render=true' and '3D=false' for DXF-Export. 
- For 3D printing set 'render=true' and '3D=true' for STL-Export.
- With the correct cut correction value ('cor') you dont need any glue, but maybe a rubber hammer.
- Have fun! 
- *pew pew*

*/


// make exportable
render = false;

// SLT export
3D = false;

// Material thickness (mm)
th = 2.95;  

// Join size
js = 5*th; 

// Cut correction (mm)
cor = 0.27; 

// Outer width
width = 80;

// Outer length
length = 80;

// Outer height
height = 50;

// Latch width
slot = 25; // latch width

// Axle width for the latch mechanism
axS = 1.5*th; 

// extra height of side at the front
extraH_front = 0;

// extra height of side at the back
extraH = 0;

// additional frame expansion for the side walls
frame = 0;




/***************** Not your buisness ;) **********************/
/*************************************************************/
/* [Hidden] */
axD = norm([th,axS]);
K = th;
$fn=50;
open = 80;
cent= (width-slot)/2;
Q=0.001;
QQ=2*Q;
//t(width/2,length/2,th)color([1,1,1])cylinder(d=160,h=25);

if(render){
    if(!3D){render();}
    else{3D()render();}
    
}else{
    preview();
}




/*************************************************************/
module render(){
    ground();
    t(0,-height-1)front();
    t(0,length+1)back();
    t(-1-frame)mirror([1,0,0])side();
    t(width+1+frame)side();

    t(0,length+height+th)cover();
    t(width+slot,length+slot)latch();
    t(width+3*slot+3*th,length+slot){
        latchPlate();
        t(-slot/2-3*th-1,th)latchSide();
         t(slot/2+2*th+1,th)latchSide();
    }
    
}

module preview(){
    3D()ground();
    color([1,0,0])t(0,th-1)r(90)3D()front();
    color([1,0,0])t(0,length)r(90)3D()back();
    color([0,1,0])t(th-1,0)r(0,-90)3D()side();
     color([0,1,0])t(width,0)r(0,-90)3D()side();
    t(0,length-K-1.5*th,height-th/2)r(-open)t(0,-length+K+1.5*th,-th/2){
        3D()cover();
        t(width/2,0,-th)color([0,0,1])3D()latch();
         t(width/2,th,-2*th)color([0,1,0])3D()latchPlate();
        t((width-slot)/2-th,2*th,0)color([1,0,0])r(0,90)3D()latchSide();
        t((width-slot)/2+slot,2*th,0)color([1,0,0])r(0,90)3D()latchSide();
    }

}
/*************************************************************/
module ground(){
    t(th,th)square([width-2*th,length-2*th]);
    teeth(width);
    t(0,length-th)teeth(width);
    t(th)r(0,0,90)teeth(length);
    t(width)r(0,0,90)teeth(length);
   
}
module front(){
   
    difference(){
        union(){
            t(th)square([width-2*th,height-th]);
            t(cent-1.5*th,height-th)hull(){                
                square([slot+3*th,0.1]);
                t(th/2)square([slot+2*th,th]);
            }
        }
        t(cent,height-2*th)square([slot,th]);
        teeth(width,false);
    }      
         t(th)r(0,0,90)teeth(height+th);
     t(width)r(0,0,90)teeth(height+th);
}
module back(){    
   difference(){
        t(th)square([width-2*th,height]);
        teeth(width,false);
    }      
         t(th)r(0,0,90)teeth(height);
     t(width)r(0,0,90)teeth(height);
}

module side(){
    difference(){
        hull(){
            t(-frame,-frame,0)square([height+frame,length+2*frame]);    
             t(height,th)square([th+extraH_front,length-2*th]);  
            t(height,length-2*th-(axS-th)/2-K-cor/2)square([th+extraH,axD]);  
        
        }
        t(height-0.5*th,length-1.5*th-K)circle(d=axD);
        t(th)r(0,0,90)teeth(length,false);
         teeth(height+th,false);
    t(0,length-th)teeth(height,false);
    }
   
}
module cover(){
   lipW = (width-(slot-6*th))/4;
    difference(){
        union(){
            
            t(th)square([width-2*th,length-th-0.1*th]);
            *t(lipW/2+th)resize([lipW,1.5*th])circle(d=width);
           * t(width-(lipW/2+th))resize([lipW,1.5*th])circle(d=width);
        }
        t(cent-1.5*th,-th)square([slot+3*th,2*th]);
           
       
        t(width/2,slot/2+2*th){
            hull(){
            circle(d=slot-2*th);
             t(0,th)circle(d=slot-2*th);
        }
          t(-slot/2,-(slot-2*th)/2 +(slot-th)/4)r(0,0,90)pin((slot-th) / 2, false);
          t(slot/2+th,-(slot-2*th)/2+(slot-th)/4)r(0,0,90)pin((slot-th)/2, false);
        }
      
    }
    t(0,length-2*th-(axS-th)/2-K-cor/2)square([th,axS+cor]);
    t(width-th,length-2*th-(axS-th)/2-K-cor/2)square([th,axS+cor]);
}
/*************************************************************/
module latch(){
   
    difference(){
        t(-slot/2)hull(){
            t(0,th)square([slot,3*th+slot-th]);
            t(th/2)square([slot-th,3*th+slot]);
        }
        t(0,slot/2+2*th)circle(d=slot-2.5*th);
    }
    t(-slot/2-th,2*th+slot)square([slot+2*th,th]);
    t(-slot/2-th,th)square([slot+2*th,th]);
}
module latchPlate(){
    L = slot+th;
    D = (slot-th) / 2;
    t(-slot/2-th)difference(){
        t(0,th)square([slot+2*th,L]);
         t(th,(L-D)/2+th)r(0,0,90)pin(D,false);
         t(slot+2*th,(L-D)/2+th)r(0,0,90)pin(D, false);
    }
}

module latchSide(){
    L = slot-th;
    D = (slot-th) / 2;
    t(0,th)square([th+0.15,L]);
    t(0,(L-D)/2+th)r(0,0,90)pin(D);
    t(2*th+0.15,(L-D)/2+th)r(0,0,90)pin(D);   
}
/*************************************************************/
/*************************************************************/
module teeth(distance,teeth=true){
    margin = 5*th;
    dist = distance - margin;   
    N = floor(dist/(js));
    n = N+(N+1)%2;   
    JS = dist/n;
    cOffset = margin/2; 
    
    for(n=[0:1:n]){
         if(n%2 == 0)translate([JS*n + cOffset,0,0])pin(JS,teeth);
     }
}
module pin(JS,teeth=true){        
     if(teeth){
        translate([-cor/2,-Q])square([JS+cor,th+QQ]);
     }else{
          translate([cor/2,-Q])square([JS-cor,th+QQ]);
     }   
}
/*************************************************************/
module t(x=0,y=0,z=0){
    translate([x,y,z])children();   
}
module r(x=0,y=0,z=0){
    rotate([x,y,z])children();
}
module 3D(){
    linear_extrude(height=th)children();
}
