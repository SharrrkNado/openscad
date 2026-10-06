names = [
    "john",
    "jane",
];

//3D();
cut();

cyberCut = false;
cyberAdd = false;

width = 60;
length = 25;
shape = 5;

//3D extrusion
plate_th = 2;
font_th = 1;

// https://www.1001fonts.com/elemental-end-font.html
font = "Elemental End";


module 3D(){
     for(n=[0:len(names)-1]){
        translate([(width+1)*n,0,0]){
            linear_extrude(height=plate_th)plate();
            color("orange")translate([0,0,plate_th])linear_extrude(height=font_th)name(names[n]);
        }
    }
}
module cut(){
   for(n=[0:len(names)-1]){
    translate([(width+1)*n,0,0]){
        difference(){
            plate();
            name(names[n]);
        }
    }
} 
}
module plate(){
    difference(){
        bevel(width, length, shape);    
        if(cyberCut){
            //translate([0,-length/2-shape/2])bevel(width/2-2*shape, 2*shape, shape); 
         translate([0,length/2+shape/2])bevel(width/2, 2*shape, shape); 
         //translate([-width/2-shape/2,0])bevel(2*shape, length/2, shape);
         //translate([width/2+shape/2,0])bevel(2*shape, length/2, shape);
        }   
       
    }
    if(cyberAdd){
        translate([0,-length/2+shape/2])bevel(width/2, 2*shape, shape); 
         //translate([0,length/2-shape/2])bevel(width/2, 2*shape, shape); 
    }
}

module bevel(w, l, s){
    hull(){
        square([w-s,l],center=true);
        square([w,l-s],center=true);        
    }
}

module name(_n){
    resize([width-shape*3,0,0],auto=true){
        text(_n,font=font,halign="center",valign="center",$fn=100);
    }
}