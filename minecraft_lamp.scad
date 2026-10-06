/*
 * lasercut able lamp with a pixel pattern on the top and sides.
 * The bottom is slighlty loser than the top and sides to allow for a light source to be placed inside.
 * author:  https://github.com/SharrrkNado
*/

// rendering = true => render the lamp in 2D for lasercutting
rendering = false;

// size of the lamp
size = 100;

// material thickness
th = 3;

// joint size
js = 4*th;

// cut correction
cor = 0.25;

// pattern for the top and sides of the lamp
pattern = [
    "0000000000000000",
    "0000000000000000",
    "0000100000001100",
    "0000000110000000",
    "0000000000000000",
    "0000011000110000",
    "0001111100110000",
    "0000000000000000",
    "0110000011000000",
    "0000000111100000",
    "0000100000000000",
    "0000000000011000",
    "0000000011111100",
    "0001100001100000",
    "0000000000000000",
    "0000000000000000"
];




/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


m = [th,js,cor];

width  = size;
length = size;
height = size;

if(rendering){render();}
else{preview();}

module preview(){
    3D()bottom(width,length,removeAble=true);
    tz(height-th)3D()bottom(width,length,top=true,pattern=true);
    color(green)ty(th)rx()3D()front(width,height,pattern=true);
    color(green)ty(length)rx()3D()front(width,height,pattern=true);
    color(red)tx(th)ry(-90)3D()side(length,height,pattern=true);
    color(red)tx(width)ry(-90)3D()side(length,height,pattern=true);  
}

module render(){
    bottom(width,length,removeAble=true);
    t(-width-1)bottom(width,length,top=true,pattern=true,removeAble=false);
    color(green)ty(-height-1)front(width,height,pattern=true);
    color(green)tx(width+1)front(width,height,pattern=true);
    color(red)t(-1,-height-1)rz()side(length,height,pattern=true);
    color(red)t(width+1+length,-height-1)rz()side(length,height,pattern=true);
}

module bottom(w,l,top=false,pattern=false,removeAble=false){
    difference(){        
        c(w,l);
        if(pattern&&top)t(th,th)scale([(w-2*th)/16,(w-2*th)/16])patternLoop();
        cor2 = removeAble?m[2]:0;
        mTemp = [m[0],m[1],cor2];
        jd(w,mTemp,tab=true,2D=true);
        t(0,l-th,0)jd(w,mTemp,tab=false,2D=true);
        tx(th)rz(90)jd(l,mTemp,tab=false,2D=true);
        tx(w)rz(90)jd(l,mTemp,tab=false,2D=true);        
    }
}
module front(w,h,pattern=false){
    difference(){
       union(){
            ty(th)c(w,h-2*th);
       }
       if(pattern)t(th,th)scale([(w-2*th)/16,(w-2*th)/16])patternLoop();
       tx(th)rz(90)jd(h,m,tab=false,2D=true);
       tx(w)rz(90)jd(h,m,tab=false,2D=true);
    }
    jd(w,m,tab=true,2D=true);
    ty(h-th)jd(w,m,tab=true,2D=true);
}

module side(l,h,pattern=false){
    union(){
        difference(){
            t(th,th)c(h-2*th,l-2*th);
            if(pattern)t(0,l)rz(-90)t(th,th)scale([(l-2*th)/16,(l-2*th)/16])patternLoop();
        }
    }
    jd(h,m,tab=true,2D=true);
    ty(l-th)jd(h,m,tab=true,2D=true);
    tx(th)rz()jd(l,m,tab=true,2D=true);
    tx(h)rz()jd(l,m,tab=true,2D=true);
}

module 3D(){
   linear_extrude(height=th)children();
}

module patternLoop(){    
    for(y=[0:1:len(pattern)-1]){
        for(x=[0:1:15]){
            if(pattern[y][x]=="1")t(x,15-y)square([1,1]);
        }       
    }
}


module jd(distance,material,rotvec=[0,0,0],tab=true,margin=2,2D=true){
    Q=0.0005;
    QQ=2*Q;
    
    th=material[0];
    js=material[1];
    cor=material[2];    
   
    dist = distance - 2*margin*th;   
    anz = floor(dist/(js));
    ANZ = anz+(anz+1)%2;   
   
    JS = dist/ANZ;
    
    centerOffset = (margin*th);
    
    rotate(rotvec){
     for(n=[0:1:anz]){
         if(n%2 == 0)translate([JS*n + centerOffset,0,0])tooth();
     }
    }    
     
     module tooth(){
         if(2D){
             if(tab){
                translate([-cor/2,-Q])square([JS+cor,th+QQ]);
             }else{
                  translate([cor/2,-Q])square([JS-cor,th+QQ]);
             }
         }else{
              if(tab){
                translate([-cor/2,-Q,-Q])cube([JS+cor,th+QQ,th+QQ]);
             }else{
                 translate([cor/2,-Q,-Q])cube([JS-cor,th+QQ,th+QQ]);
             }
         }
     }
}

module t(t,l,h){
    if(is_list(t)){
       translate(t)children();
    }else{
        if(t!=undef && l==undef && h==undef)translate([t,0,0])children();
        if(t!=undef && l!=undef && h==undef)translate([t,l])children();
        if(t!=undef && l!=undef && h!=undef)translate([t,l,h])children();
    }
}

module tx(_t){
    translate([_t,0,0])children();
}
module ty(_t){
    translate([0,_t,0])children();
}
module tz(_t){
    translate([0,0,_t])children();
}
module r(r,y,z){
    if(is_list(r)){
        rotate(r)children();
    }else{
        rotate([r,y,z])children();
    }
    
}
module rx(_r=90){
    rotate([_r,0,0])children();
}
module ry(_r=90){
    rotate([0,_r,0])children();
}
module rz(_r=90){
   rotate([0,0,_r])children();
}

module c(w,l,h,center){
    if(h==undef){square([w,l],center=center);}
    else{cube([w,l,h],center=center);}
    
}

red = [1,0,0];
blue = [0,0,1];
green = [0,1,0];

rx = [90,0,0];
ry= [0,90,0];
rz= [0,0,90];