// angled back
extra_length = 5;

// geometry
overall_length = 22 + 17 + extra_length; //+17;  // was 22
barrel_width = 17.5;
wall = 2;
slot_width = 20;
board_width = 13.5; // was 14
board_length = 20; // was 18
board_thickness = 1.5;
elements_height = 2;
cyl_radius = 33.8/2;
outer_radius = 40/2;
socket_width = 4; // space for pins
hole_x_shift = 4;
hole_z_shift = overall_length - 4.5;
hole_radius = 2.2/2;
barrel_snug_height = 13;
nut_size = 4.8/2;
bolt_size = 4.5/2;
gap_width = 18;

// derived
slot_shift = (slot_width - board_width)/2;
holder_thickness = outer_radius - cyl_radius;

// decoration
cust_length = 23;
cuts_width = 4;

module holder() {
    difference() {
        union() {
            // holder parts
            difference() {
                cylinder(overall_length, outer_radius, outer_radius, $fn=400);
                translate([0,0,-1]) cylinder(overall_length + 2, cyl_radius, cyl_radius, $fn=400);
                translate([-barrel_width/2,0,-1]) cube([barrel_width, 100, overall_length + 2]);
            }
            translate([barrel_width/2, 15, 0])
                cube([holder_thickness, barrel_snug_height, overall_length]);
            translate([-barrel_width/2 - holder_thickness, 15, 0])
                cube([holder_thickness, barrel_snug_height, overall_length]);
            // slot box
            translate([-slot_width/2, -outer_radius-(wall+5+wall)+2, 0])
                difference() {
                    cube([slot_width, wall+5+wall+1, overall_length]);
                    // chop at front
                    translate([-1,0,overall_length-1.5]) rotate([45, 0, 0])
                        cube([slot_width + 2, 100, 100]);
                }
        }
        // slot gap and socket
        translate([-slot_width/2, -outer_radius-(wall+3+wall)+2, 0])
            union() {
                // elements
                translate([slot_shift + 0.5, wall, -1]) cube([board_width-1, elements_height + board_thickness, overall_length + 2]);
                // pcb
                translate([slot_shift, wall, -1]) cube([board_width, board_thickness, overall_length + 2]);
                // connector
                translate([slot_shift - 0.5, 0, -1]) cube([board_width + 1, wall + 4.5, overall_length - board_length + 1]);
                // guide for pcb
                difference() {
                    translate([slot_shift - 0.5, board_thickness + wall-0.75, overall_length - board_length - board_thickness - 0.7]) 
                        rotate([45, 0, 0])
                            cube([board_width + 1, board_thickness * 2, board_thickness * 2]);
                        translate([0.75, - board_thickness + wall, overall_length - board_length])
                            translate([2,0,0])
                                rotate([0, -69, 0])
                                    cube([board_thickness * 2, board_thickness * 4, board_thickness * 2]);
                        translate([0.75, - board_thickness + wall, overall_length - board_length])
                            translate([board_width + board_thickness * 2,0,0])
                                rotate([0, -21, 0])
                                    cube([board_thickness * 2, board_thickness * 4, board_thickness * 2]);
                }
            }
    }
}

// now also included in holder
module slot() {
    difference() {
        cube([slot_width, wall+3+wall+1, 22]);
        translate([slot_shift, wall, -1]) cube([board_width, 3, 24]);
        translate([slot_shift, -1, -1]) cube([board_width, wall + 7, overall_length - board_length + 1]);
    }
}

module cut(length, hieght, width) {
    linear_extrude(width) {
        polygon(
            [[0,0],[length,0],[length + hieght, hieght],[hieght, hieght]],
            [[0,1,2,3]],
            2);
    }
}

difference() {
    union() {
        holder();
    }
    // screw hole
    translate([hole_x_shift, 0, hole_z_shift]) rotate([90, 0, 0])
        cylinder(100, hole_radius, hole_radius, $fn=100);
    translate([hole_x_shift, 0, hole_z_shift]) rotate([90, 90, 0])
        cylinder(18.3, nut_size, nut_size, $fn=6);
    translate([hole_x_shift, -25, hole_z_shift]) rotate([90, 0, 0])
        cylinder(10, bolt_size, bolt_size, $fn=60);
    // side slots
    for(i=[0:2])
        translate([cyl_radius * 2,i * 7 - 9, overall_length - cust_length - 10 - i])
            rotate([0,-90,0])
                cut(cust_length + i, cuts_width, cyl_radius * 4);
    // angled back
    rotate([-5, 0, 0])
        translate([-500, -500, -extra_length/2])
            cube([1000, 1000, extra_length]);
    cube([1000, 1000, 2.2], center = true);
}
