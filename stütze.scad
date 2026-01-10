height = 600;
angle = 15;
angle_on_top = 51;
floor_count = 3;
draw_construction_helpers = false;
draw_rods = true;

big_rod_diameter = 5;
small_rod_diameter = 3;

function dot(a, b) = a[0]*b[0] + a[1]*b[1] + a[2]*b[2];

//gibt den Schnittpunkt eines Vektors mit der xy-Ebene zurück
function intersect_with_xy(p, v) = 
    p + v * (-p.z / v.z); // Skaliere v, damit z=0

//gibt eine Liste von regelmäßig verteilten Punkten auf einem Vektor zurück
function subdivide(p_top, p_bottom, n) =
    [for (i = [1 : n - 1])
        p_top + (p_bottom - p_top) * (i / n)];
    
// Gibt den Mittelpunkt zwischen zwei Punkten zurück
function midpoint(p1, p2) = 
    [(p1[0] + p2[0])/2, (p1[1] + p2[1])/2, (p1[2] + p2[2])/2];

function rotate_vec(v, axis, angle) =
    v*cos(angle)
  + cross(axis, v)*sin(angle)
  + axis * dot(axis, v) * (1 - cos(angle));
  
function normalize(v) = v / norm(v);

function angle_between(a,b) =
    acos( dot(a,b) / (norm(a)*norm(b)) );

dir = [0, height * sin(angle), height * cos(angle)];
top_point = dir; //punkt oben in der Mitte
cross_to_edge = cross([50,0,0], dir);
vec_to_corner = [50,0,0] + ((cross_to_edge / norm(cross_to_edge)) * 38);

a = top_point + vec_to_corner;
b = top_point + [-vec_to_corner.x, vec_to_corner.y, vec_to_corner.z];
c = top_point + [-vec_to_corner.x, -vec_to_corner.y, -vec_to_corner.z];
d = top_point + [vec_to_corner.x, -vec_to_corner.y, -vec_to_corner.z];

a_to_front = rotate_vec(dir, [1, 0, 0], angle_on_top);
b_to_front = rotate_vec(dir, [1, 0, 0], angle_on_top);
c_to_front = rotate_vec(dir, [1, 0, 0], -angle_on_top);
d_to_front = rotate_vec(dir, [1, 0, 0], -angle_on_top);

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

floor_height = norm((c_on_ground - c) / floor_count);

subdivide_c_list = subdivide(c, c_on_ground, floor_count);
subdivide_d_list = subdivide(d, d_on_ground, floor_count);

points_on_a_to_ground = [a, for (i = [1 : floor_count - 1])  a + (a_to_ground / norm(a_to_ground) * i * floor_height), a_on_ground];
points_on_b_to_ground = [b, for (i = [1 : floor_count - 1])  b + (b_to_ground / norm(b_to_ground) * i * floor_height), b_on_ground];
points_on_c_to_ground = [c, for (i = [0 : len(subdivide_c_list) - 1]) subdivide_c_list[i], c_on_ground];
points_on_d_to_ground = [d, for (i = [0 : len(subdivide_d_list) - 1]) subdivide_d_list[i], d_on_ground];


middle_points_on_a_to_ground = [for (i = [1 : floor_count - 1])  a + (a_to_ground / norm(a_to_ground) * i * floor_height) - 0.5 * a_to_ground / norm(a_to_ground) * floor_height, a_on_ground];
middle_points_on_b_to_ground = [for (i = [1 : floor_count - 1])  b + (b_to_ground / norm(b_to_ground) * i * floor_height) - 0.5 * b_to_ground / norm(b_to_ground) * floor_height, b_on_ground];
middle_points_on_c_to_ground = [for (i = [1 : floor_count - 1])  c + (c_to_ground / norm(c_to_ground) * i * floor_height) - 0.5 * c_to_ground / norm(c_to_ground) * floor_height, c_on_ground];
middle_points_on_d_to_ground = [for (i = [1 : floor_count - 1])  d + (d_to_ground / norm(d_to_ground) * i * floor_height) - 0.5 * d_to_ground / norm(d_to_ground) * floor_height, d_on_ground];

middle_points_a_b = [for (i = [0 : floor_count - 1]) midpoint(points_on_a_to_ground[i], points_on_b_to_ground[i])];
middle_points_b_c = [for (i = [0 : floor_count - 1]) midpoint(points_on_b_to_ground[i], points_on_c_to_ground[i])];
middle_points_c_d = [for (i = [0 : floor_count - 1]) midpoint(points_on_c_to_ground[i], points_on_d_to_ground[i])];
middle_points_d_a = [for (i = [0 : floor_count - 1]) midpoint(points_on_d_to_ground[i], points_on_a_to_ground[i])];

if(draw_construction_helpers){ //show construction helping vectors
    color("red"){
        cylinder_from_point([0,0,0], dir,height, 2.5);  //height cylinder
        for (p = [a, b, c, d]) {
            cylinder_between(top_point, p, 2.5);        //cross for a,b,c,d 
        }       
        
        // Alle Punkt-Arrays, zusammengefasst mit gewünschtem Radius
        point_groups = [
            [points_on_a_to_ground, 8],
            [points_on_b_to_ground, 8],
            [points_on_c_to_ground, 8],
            [points_on_d_to_ground, 8],
            [middle_points_on_a_to_ground, 6],
            [middle_points_on_b_to_ground, 6],
            [middle_points_on_c_to_ground, 6],
            [middle_points_on_d_to_ground, 6],
            [middle_points_a_b, 6],
            [middle_points_b_c, 6],
            [middle_points_c_d, 6],
            [middle_points_d_a, 6]
        ];

        // Schleife über die Gruppen
        for (grp = point_groups) {
            points = grp[0];
            r = grp[1];
            for (p = points)
                translate(p) sphere(r = r);
        }
    }
}

if(draw_rods){
color("blue"){
    threaded_rods();
}}

color("green"){
    //Oberstes "einfaches" Stockwerk
    for(i = [a, b, c, d]){
        pipe_from_point(i, dir, 25, 2.51, 5);
    }
    
    pipe_from_point(a, a_to_front, 20, 2.51, 5);
    pipe_from_point(b, b_to_front, 20, 2.51, 5);
    pipe_from_point(c, c_to_front, 20, 2.51, 5);
    pipe_from_point(d, d_to_front, 20, 2.51, 5);
    
    //Main connectors
    for(i = [1 : floor_count - 1]) {
        main_connector_a(points_on_a_to_ground[i], a_to_ground, points_on_d_to_ground[i]);
        
        mirror([1, 0, 0])
            main_connector_a(points_on_a_to_ground[i], a_to_ground, points_on_d_to_ground[i]);
            
        mirror(cross(dir, [1, 0, 0]))
            main_connector_a(points_on_a_to_ground[i], a_to_ground, points_on_d_to_ground[i]);
            
        mirror([1, 0, 0])
            mirror(cross(dir, [1, 0, 0]))
                main_connector_a(points_on_a_to_ground[i], a_to_ground, points_on_d_to_ground[i]);
    }
    
    middle_points_to_ground = [
        middle_points_on_a_to_ground,
        middle_points_on_b_to_ground,
        middle_points_on_c_to_ground,
        middle_points_on_d_to_ground
    ];

    horizontal_middle_points = [
        middle_points_a_b,
        middle_points_b_c,
        middle_points_c_d,
        middle_points_d_a
    ];

    // horizontal middle connectors    
    /*for (i = [0 : len(horizontal_middle_points) - 1]) {

        next_i = (i + 1) % len(horizontal_middle_points);

        for (ii = [0 : len(horizontal_middle_points[i]) - 1]) {
            horizontal_middle_connector(
                horizontal_middle_points[i][ii],
                (i % 2 == 1)
                    ? cross(dir, [1, 0, 0])
                    : [1, 0, 0],
                middle_points_to_ground[i][ii],
                middle_points_to_ground[i][ii + 1],
                middle_points_to_ground[next_i][ii],
                middle_points_to_ground[next_i][ii + 1]
            );
        }
    }*/

    
    /*for (i = [0 : floor_count - 2]) {
        pipe_from_point(middle_points_on_a_to_ground[i], - a_to_ground, 20, 2.51, 5);
        pipe_from_point(middle_points_on_a_to_ground[i], a_to_ground, 20, 2.51, 5);
        pipe_from_point(middle_points_on_a_to_ground[i], middle_points_a_b[i] - middle_points_on_a_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_a_to_ground[i], middle_points_a_b[i + 1] - middle_points_on_a_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_a_to_ground[i], middle_points_d_a[i] - middle_points_on_a_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_a_to_ground[i], middle_points_d_a[i + 1] - middle_points_on_a_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_b_to_ground[i], - b_to_ground, 20, 2.51, 5);
        pipe_from_point(middle_points_on_b_to_ground[i], b_to_ground, 20, 2.51, 5);
        pipe_from_point(middle_points_on_b_to_ground[i], middle_points_a_b[i] - middle_points_on_b_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_b_to_ground[i], middle_points_a_b[i + 1] - middle_points_on_b_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_b_to_ground[i], middle_points_b_c[i] - middle_points_on_b_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_b_to_ground[i], middle_points_b_c[i + 1] - middle_points_on_b_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_c_to_ground[i], - c_to_ground, 20, 2.51, 5);
        pipe_from_point(middle_points_on_c_to_ground[i], c_to_ground, 20, 2.51, 5);
        pipe_from_point(middle_points_on_c_to_ground[i], middle_points_b_c[i] - middle_points_on_c_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_c_to_ground[i], middle_points_b_c[i + 1] - middle_points_on_c_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_c_to_ground[i], middle_points_c_d[i] - middle_points_on_c_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_c_to_ground[i], middle_points_c_d[i + 1] - middle_points_on_c_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_d_to_ground[i], - d_to_ground, 20, 2.51, 5);        
        pipe_from_point(middle_points_on_d_to_ground[i], d_to_ground, 20, 2.51, 5);
        pipe_from_point(middle_points_on_d_to_ground[i], middle_points_c_d[i] - middle_points_on_d_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_d_to_ground[i], middle_points_c_d[i + 1] - middle_points_on_d_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_d_to_ground[i], middle_points_d_a[i] - middle_points_on_d_to_ground[i], 20, 1.4, 3);
        pipe_from_point(middle_points_on_d_to_ground[i], middle_points_d_a[i + 1] - middle_points_on_d_to_ground[i], 20, 1.4, 3);
    }*/
    
    /*for (i = [0 : floor_count - 1]) {
        pipe_from_point(middle_points_a_b[i], points_on_a_to_ground[i] - middle_points_a_b[i], 20, 2.51, 5);
        pipe_from_point(middle_points_a_b[i], points_on_b_to_ground[i] - middle_points_a_b[i], 20, 2.51, 5);
        pipe_from_point(middle_points_a_b[i], middle_points_on_a_to_ground[i] - middle_points_a_b[i], 20, 1.4, 3);
        pipe_from_point(middle_points_a_b[i], middle_points_on_b_to_ground[i] - middle_points_a_b[i], 20, 1.4, 3);
        
        pipe_from_point(middle_points_b_c[i], points_on_b_to_ground[i] - middle_points_b_c[i], 20, 2.51, 5);
        pipe_from_point(middle_points_b_c[i], points_on_c_to_ground[i] - middle_points_b_c[i], 20, 2.51, 5);
        pipe_from_point(middle_points_b_c[i], middle_points_on_b_to_ground[i] - middle_points_b_c[i], 20, 1.4, 3);
        pipe_from_point(middle_points_b_c[i], middle_points_on_c_to_ground[i] - middle_points_b_c[i], 20, 1.4, 3);
        
        pipe_from_point(middle_points_c_d[i], points_on_c_to_ground[i] - middle_points_c_d[i], 20, 2.51, 5);
        pipe_from_point(middle_points_c_d[i], points_on_d_to_ground[i] - middle_points_c_d[i], 20, 2.51, 5);
        pipe_from_point(middle_points_c_d[i], middle_points_on_c_to_ground[i] - middle_points_c_d[i], 20, 1.4, 3);
        pipe_from_point(middle_points_c_d[i], middle_points_on_d_to_ground[i] - middle_points_c_d[i], 20, 1.4, 3);
        
        pipe_from_point(middle_points_d_a[i], points_on_d_to_ground[i] - middle_points_d_a[i], 20, 2.51, 5);
        pipe_from_point(middle_points_d_a[i], points_on_a_to_ground[i] - middle_points_d_a[i], 20, 2.51, 5);
        pipe_from_point(middle_points_d_a[i], middle_points_on_d_to_ground[i] - middle_points_d_a[i], 20, 1.4, 3);
        pipe_from_point(middle_points_d_a[i], middle_points_on_a_to_ground[i] - middle_points_d_a[i], 20, 1.4, 3);
    }*/
    
    /*for (i = [1 : floor_count - 1]){
        pipe_from_point(middle_points_a_b[i], middle_points_on_a_to_ground[i - 1] - middle_points_a_b[i], 20, 1.4, 3);
        pipe_from_point(middle_points_a_b[i], middle_points_on_b_to_ground[i - 1] - middle_points_a_b[i], 20, 1.4, 3);
        
        pipe_from_point(middle_points_b_c[i], middle_points_on_b_to_ground[i - 1] - middle_points_b_c[i], 20, 1.4, 3);
        pipe_from_point(middle_points_b_c[i], middle_points_on_c_to_ground[i - 1] - middle_points_b_c[i], 20, 1.4, 3);
        
        pipe_from_point(middle_points_c_d[i], middle_points_on_c_to_ground[i - 1] - middle_points_c_d[i], 20, 1.4, 3);
        pipe_from_point(middle_points_c_d[i], middle_points_on_d_to_ground[i - 1] - middle_points_c_d[i], 20, 1.4, 3);
        
        pipe_from_point(middle_points_d_a[i], middle_points_on_d_to_ground[i - 1] - middle_points_d_a[i], 20, 1.4, 3);
        pipe_from_point(middle_points_d_a[i], middle_points_on_a_to_ground[i - 1] - middle_points_d_a[i], 20, 1.4, 3);
    }*/
}

module vertical_middle_connector(origin, vec_to_ground, a, b,c ,d){
    pipe_from_point(origin, vec_to_ground, 20, big_rod_diameter / 2 + 0.2, big_rod_diameter);
    pipe_from_point(origin, -vec_to_ground, 20, big_rod_diameter / 2 + 0.2, big_rod_diameter);
    
    if(a != undef){
        pipe_from_point(origin, a - origin, 20, small_rod_diameter / 2, small_rod_diameter);
    }
    
    if(b != undef){
        pipe_from_point(origin, origin - b, 20, small_rod_diameter / 2, small_rod_diameter);
    }
    
    if(c != undef){
        pipe_from_point(origin, c - origin, 20, small_rod_diameter / 2, small_rod_diameter);
    }
    
    if(d != undef){
        pipe_from_point(origin, origin - d, 20, small_rod_diameter / 2, small_rod_diameter);
    }
}

module horizontal_middle_connector(origin, horizont_vec, a, b, c, d) {
    pipe_from_point(origin, horizont_vec, 20, big_rod_diameter / 2 + 0.2, big_rod_diameter);
    pipe_from_point(origin, -horizont_vec, 20, big_rod_diameter / 2 + 0.2, big_rod_diameter);
    
    if(a != undef){
        pipe_from_point(origin, a - origin, 20, small_rod_diameter / 2, small_rod_diameter);
    }
    
    if(b != undef){
        pipe_from_point(origin, origin - b, 20, small_rod_diameter / 2, small_rod_diameter);
    }
    
    if(c != undef){
        pipe_from_point(origin, c - origin, 20, small_rod_diameter / 2, small_rod_diameter);
    }
    
    if(d != undef){
        pipe_from_point(origin, origin - d, 20, small_rod_diameter / 2, small_rod_diameter);
    }
}

module main_connector_a(origin, vec_to_ground, horizontal_connector) {
    difference() {
        pipe_from_point(origin - normalize(vec_to_ground) * 20, vec_to_ground, 40, big_rod_diameter / 2 + 0.2, big_rod_diameter);
        cylinder_from_point(origin - [20, 0, 0], [1, 0, 0], 60, big_rod_diameter / 2 + 0.2);
        cylinder_from_point(origin, horizontal_connector - origin, 30, big_rod_diameter / 2 - 0.4);
    }
    
    difference() {
        pipe_between(origin - [20, 0, 0], origin + [6, 0, 0], big_rod_diameter / 2 + 0.2, big_rod_diameter);
        cylinder_from_point(origin - normalize(vec_to_ground) * 30, vec_to_ground, 60, big_rod_diameter / 2 + 0.2);
        cylinder_from_point(origin - [20, 0, 0], [1, 0, 0], 60, big_rod_diameter / 2 + 0.2);
        cylinder_from_point(origin, horizontal_connector - origin, 30, big_rod_diameter / 2 - 0.4);
    }
    
    difference() {
        pipe_from_point(origin, horizontal_connector - origin, 20, big_rod_diameter / 2 - 0.4, big_rod_diameter);
        cylinder_from_point(origin - normalize(vec_to_ground) * 30, vec_to_ground, 60, big_rod_diameter / 2 + 0.2);
        cylinder_from_point(origin - [20, 0, 0], [1, 0, 0], 60, big_rod_diameter / 2 + 0.2);
    }
        
    angle_to_middle_y = angle_between(a_to_ground, horizontal_connector - origin);
    
    difference(){
        translate(origin)
        rotate([-angle - 11.6, 0, 0])
        rotate([0, 90 - 6.4, 0])
        linear_extrude(height = 3, center = true)
        polygon(points = [[25, 0], [cos(angle_to_middle_y) * 25, sin(angle_to_middle_y) * 22], [-22, 0]]);
        cylinder_from_point(origin - normalize(vec_to_ground) * 30, vec_to_ground, 60, big_rod_diameter / 2 + 0.2);
        cylinder_from_point(origin - [25, 0, 0], [1, 0, 0], 60, big_rod_diameter / 2 + 0.2);
        cylinder_from_point(origin, horizontal_connector - origin, 30, big_rod_diameter / 2 - 0.4);
        cylinder_from_point(origin - normalize(vec_to_ground) * 20, -vec_to_ground, 60, big_rod_diameter * 2);
        cylinder_from_point(origin + normalize(vec_to_ground) * 20, vec_to_ground, 60, big_rod_diameter * 2);
        cylinder_from_point(origin + normalize(horizontal_connector - origin) * 20, horizontal_connector - origin, 20, big_rod_diameter * 2);
    }
    
    angle_to_middle_x = angle_between(a_to_ground, [1, 0, 0]);
    
    difference() {
        translate(origin)
        rotate([-90 - 11.6 - angle, 0, 0])
        rotate([0, 0, -6.4])
        linear_extrude(height = 3, center = true)
        polygon(points = [[0, 25], [-sin(angle_to_middle_y) * 22, cos(angle_to_middle_y) * 20], [0, -22]]);
        cylinder_from_point(origin - normalize(vec_to_ground) * 30, vec_to_ground, 60, big_rod_diameter / 2 + 0.2);
        cylinder_from_point(origin - [20, 0, 0], [1, 0, 0], 60, big_rod_diameter / 2 + 0.2);
        cylinder_from_point(origin - normalize(vec_to_ground) * 20, -vec_to_ground, 60, big_rod_diameter * 2);
        cylinder_from_point(origin - horizontal_connector * 20, horizontal_connector, 60, big_rod_diameter * 2);
        cylinder_from_point(origin + normalize(vec_to_ground) * 20, vec_to_ground, 60, big_rod_diameter * 2);
        cylinder_from_point(origin - [20, 0, 0], -[1, 0, 0], 60, big_rod_diameter * 2);
    }
}

module threaded_rods(){
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
    
    cylinder_from_point(a, a_to_front, 80, 2.5);
    cylinder_from_point(b, b_to_front, 80, 2.5);
    cylinder_from_point(c, c_to_front, 80, 2.5);
    cylinder_from_point(d, d_to_front, 80, 2.5);
    
    cylinder_between(a, a_on_ground, 2.5);
    cylinder_between(b, b_on_ground, 2.5);
    cylinder_between(c, c_on_ground, 2.5);
    cylinder_between(d, d_on_ground, 2.5);
    
    for (i = [0 : len(points_on_a_to_ground) - 2]) {
        cylinder_between(points_on_a_to_ground[i], points_on_b_to_ground[i], 2.5);
        cylinder_between(points_on_b_to_ground[i], points_on_c_to_ground[i], 2.5);
        cylinder_between(points_on_c_to_ground[i], points_on_d_to_ground[i], 2.5);
        cylinder_between(points_on_d_to_ground[i], points_on_a_to_ground[i], 2.5);
    }
    
    cylinder_between(middle_points_a_b[0], middle_points_on_a_to_ground[0], 1.5);
    cylinder_between(middle_points_a_b[0], middle_points_on_b_to_ground[0], 1.5);
    cylinder_between(middle_points_b_c[0], middle_points_on_b_to_ground[0], 1.5);
    cylinder_between(middle_points_b_c[0], middle_points_on_c_to_ground[0], 1.5);
    cylinder_between(middle_points_c_d[0], middle_points_on_c_to_ground[0], 1.5);
    cylinder_between(middle_points_c_d[0], middle_points_on_d_to_ground[0], 1.5);
    cylinder_between(middle_points_d_a[0], middle_points_on_d_to_ground[0], 1.5);
    cylinder_between(middle_points_d_a[0], middle_points_on_a_to_ground[0], 1.5);
    
    for (i = [1 : floor_count - 1]){
        cylinder_between(middle_points_a_b[i], middle_points_on_a_to_ground[i - 1], 1.5);
        cylinder_between(middle_points_a_b[i], middle_points_on_b_to_ground[i - 1], 1.5);
        cylinder_between(middle_points_a_b[i], middle_points_on_a_to_ground[i], 1.5);
        cylinder_between(middle_points_a_b[i], middle_points_on_b_to_ground[i], 1.5);
        
        cylinder_between(middle_points_b_c[i], middle_points_on_b_to_ground[i - 1], 1.5);
        cylinder_between(middle_points_b_c[i], middle_points_on_c_to_ground[i - 1], 1.5);
        cylinder_between(middle_points_b_c[i], middle_points_on_b_to_ground[i], 1.5);
        cylinder_between(middle_points_b_c[i], middle_points_on_c_to_ground[i], 1.5);
        
        cylinder_between(middle_points_c_d[i], middle_points_on_c_to_ground[i - 1], 1.5);
        cylinder_between(middle_points_c_d[i], middle_points_on_d_to_ground[i - 1], 1.5);
        cylinder_between(middle_points_c_d[i], middle_points_on_c_to_ground[i], 1.5);
        cylinder_between(middle_points_c_d[i], middle_points_on_d_to_ground[i], 1.5);
        
        cylinder_between(middle_points_d_a[i], middle_points_on_d_to_ground[i - 1], 1.5);
        cylinder_between(middle_points_d_a[i], middle_points_on_a_to_ground[i - 1], 1.5);
        cylinder_between(middle_points_d_a[i], middle_points_on_d_to_ground[i], 1.5);
        cylinder_between(middle_points_d_a[i], middle_points_on_a_to_ground[i], 1.5);
    }
}

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

module pipe_from_point(p, dir, h, ir, or, $fn=64) {
    difference(){
        cylinder_from_point(p, dir, h, or);
        cylinder_from_point(p, dir, h, ir);
    }
}

module pipe_between(p1, p2, ir, or, $fn=64) {
    difference(){
        cylinder_between(p1, p2, or);
        cylinder_between(p1, p2, ir);
    }
}