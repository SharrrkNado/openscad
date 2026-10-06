

th = 3;
cor = 0.27;
js = 3*th;
width = 110+2*th;
height = 150;
length = 40;
frontH = 15+th;
backH = 70;

floorH = 5;

angel = 15;
alpha = sin(angel)*length;
beta = cos(angel)*length;  
sideH = frontH+frontH*cos(angel)-2*th;
Q=0.001;
QQ=2*Q;
//render();
preview();
module render(){
    ground();
    t(0,-frontH-th,0)front();
    t(0,backH)back();
    t(-sideH-th-1)side();
    t(sideH+width)side();
}

module preview(){

    t(0,0,alpha+floorH)r(-angel,0,0){
    color([1,1,1])t(th,length-th-10,th)cube([85,10,50]);
        col()3D()ground();
        col()t(0,th)r(90,0,0)3D()front();
        col()t(0,length)r(90,0,0)3D()back();
    }
    col()t(th)r(0,-90)3D()side();
    col()t(width)r(0,-90)3D()side();
}
module 3D(){
    linear_extrude(height=th)children();
}
module side(){
    L = beta+sin(angel)*sideH;
    LL =  beta+sin(angel)*backH;
    H = floorH+alpha+cos(angel)*frontH;
    difference(){
    hull(){
        square([H,L]);
         t(0,-8)square([0.1,LL+5]);
    }
    t(alpha+floorH)r(0,0,angel){
        t(th)r(0,0,90)teeth(length,false);
        t(0,length-th)teeth(sideH,false);
        t(0,0)r(0,0,0)teeth(frontH+th,false);
    }   
}
}

module front(){    
    difference(){
        t(th)square([width-2*th,frontH]);
        teeth(width,false);
    }   
    t(th)r(0,0,90)teeth(frontH+th);
    t(width)r(0,0,90)teeth(frontH+th);
}

module ground(){
    t(th,th)square([width-2*th,length-2*th]);
    teeth(width);
    t(th)r(0,0,90)teeth(length);
    t(width)r(0,0,90)teeth(length);
    t(0,length-th)teeth(width);
}

module back(){
    difference(){
        t(th)square([width-2*th,backH]);
        teeth(width,false);      
    } 
      t(th)r(0,0,90)teeth(sideH); 
     t(width)r(0,0,90)teeth(sideH); 
}

module teeth(distance,teeth=true){
    margin = 4*th;
    dist = distance - margin;   
    N = floor(dist/(js));
    n = N+(N+1)%2;   
    JS = dist/n;
    cOffset = margin/2; 
    
    for(n=[0:1:n]){
         if(n%2==0)translate([JS*n + cOffset,0,0])pin(JS,teeth);
     }
}
module pin(JS,teeth=true){        
     if(teeth){
        translate([-cor/2,-Q])square([JS+cor,th+QQ]);
     }else{
          translate([cor/2,-Q])square([JS-cor,th+QQ]);
     }   
}

module t(x=0,y=0,z=0){
    translate([x,y,z])children();   
}
module r(x=0,y=0,z=0){
    rotate([x,y,z])children();
}
module 3D(){
    linear_extrude(height=th)children();
}

module col(){
    r = rands(1,100,3);   
    color([r[0]/100,r[1]/100,r[2]/100])children();
}