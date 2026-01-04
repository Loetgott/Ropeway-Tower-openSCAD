height = 500;
angle = 20;
floor_count = 2;
draw_construction_helpers = false;

dir = [0, height * sin(angle), height * cos(angle)];
top_point = dir; //punkt oben in der Mitte
cross_to_edge = cross([50,0,0], dir);
vec_to_corner = [50,0,0] + ((cross_to_edge / norm(cross_to_edge)) * 38);

if(draw_construction_helpers){ //show construction helping vectors
    color("red"){
        cylinder_from_point([0,0,0], dir,height, 2.5);  //height cylinder
        for (p = [a, b, c, d]) {
            cylinder_between(top_point, p, 2.5);        //cross for a,b,c,d 
        }        
        
    }
}


a = top_point + vec_to_corner;
b = top_point + [-vec_to_corner.x, vec_to_corner.y, vec_to_corner.z];
c = top_point + [-vec_to_corner.x, -vec_to_corner.y, -vec_to_corner.z];
d = top_point + [vec_to_corner.x, -vec_to_corner.y, -vec_to_corner.z];

ground_vec_y = cross_to_edge / norm(cross_to_edge) * height * tan(11.6);
ground_vec_x = [1,0,0] * height * tan(6.3);

a_to_ground = -dir + ground_vec_y + ground_vec_x;
b_to_ground = -dir + ground_vec_y - ground_vec_x;
c_to_ground = -dir - ground_vec_y - ground_vec_x;
d_to_ground = -dir - ground_vec_y + ground_vec_x;

a_on_ground = intersect_with_xy(a, a_to_ground);
b_on_ground = intersect_with_xy(b, b_to_ground);
c_on_ground = intersect_with_xy(c, c_to_ground);
d_on_ground = intersect_with_xy(d, d_to_ground);


color("blue"){
    for (p = [a, b, c, d]) {
        cylinder_from_point(p, dir, 80, 2.5);
    }
    
    cylinder_between(a, b, 2.5);
    cylinder_between(a, d, 2.5);
    cylinder_between(b, c, 2.5);
    cylinder_between(d, c, 2.5);
    
    cylinder_between(a + dir / norm(dir) * 80, b + dir / norm(dir) * 80, 2.5);
    cylinder_between(a + dir / norm(dir) * 80, d + dir / norm(dir) * 80, 2.5);
    cylinder_between(b + dir / norm(dir) * 80, c + dir / norm(dir) * 80, 2.5);
    cylinder_between(d + dir / norm(dir) * 80, c + dir / norm(dir) * 80, 2.5);
    
    cylinder_between(a, a_on_ground, 2.5);
    cylinder_between(b, b_on_ground, 2.5);
    cylinder_between(c, c_on_ground, 2.5);
    cylinder_between(d, d_on_ground, 2.5);
}

color("green"){
    cylinder_from_point(a_on_ground, [0, 0, 1], 5, 30);

    pipe_from_point(a, a_to_ground, 35, 2.51, 5);
    pipe_from_point(b, b_to_ground, 35, 2.51, 5);
    pipe_from_point(c, c_to_ground, 35, 2.51, 5);
    pipe_from_point(d, d_to_ground, 35, 2.51, 5);
}

function intersect_with_xy(p, v) = 
    p + v * (-p.z / v.z); // Skaliere v, damit z=0

module cylinder_from_point(p, dir, h, r, $fn=64) {
    d = dir / norm(dir);          // Richtungsvektor normieren

    axis  = cross([0,0,1], d);     // Rotationsachse
    angle = acos(d.z);             // Rotationswinkel

    translate(p)
        rotate(a = angle, v = axis)
            cylinder(h = h, r = r);
}


module cylinder_between(p1, p2, r, $fn=64) {
    v = p2 - p1;
    h = norm(v);

    axis = cross([0,0,1], v);
    angle = acos( v.z / h );

    translate(p1)
        rotate(a = angle, v = axis)
            cylinder(h = h, r = r);
}

module pipe_from_point(p, dir, h, ir, or, $fn=64){
    difference(){
        cylinder_from_point(p, dir, h, or);
        cylinder_from_point(p, dir, h, ir);
    }
}

module pipe_between(p1, p2, ir, or, $fn=64){
    difference(){
        cylinder_between(p1, p2, or);
        cylinder_between(p1, p2, ir);
    }
}