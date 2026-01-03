height = 500;
angle = 20;
draw_construction_helpers = true;

dir = [0, height * sin(angle), height * cos(angle)];
top_point = dir; //punkt oben in der Mitte
cross_to_edge = cross([50,0,0], dir);
vec_to_corner = [50,0,0] + ((cross_to_edge / norm(cross_to_edge)) * 38);

if(draw_construction_helpers){
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

for (p = [a, b, c, d]) {
    color("blue")
        cylinder_from_point(p, dir, 80, 2.5);
}

color("blue"){
    cylinder_between(a, b, 2.5);
    cylinder_between(a, d, 2.5);
    cylinder_between(b, c, 2.5);
    cylinder_between(d, c, 2.5);
    cylinder_between(a + dir / norm(dir) * 80, b + dir / norm(dir) * 80, 2.5);
    cylinder_between(a + dir / norm(dir) * 80, d + dir / norm(dir) * 80, 2.5);
    cylinder_between(b + dir / norm(dir) * 80, c + dir / norm(dir) * 80, 2.5);
    cylinder_between(d + dir / norm(dir) * 80, c + dir / norm(dir) * 80, 2.5);
}


module cylinder_from_point(p, dir, h, r, $fn=64) {
    d = dir / norm(dir);          // Richtungsvektor normieren

    axis  = cross([0,0,1], d);     // Rotationsachse
    angle = acos(d.z);             // Rotationswinkel (Grad!)

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