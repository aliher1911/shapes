// Show/hide
SHOW_BOTTOM = 0;
SHOW_COVER = 0;

// Box dimensions
BOTTOM_HEIGHT = 13;
BOTTOM_WIDTH = 30;
COVER_HEIGHT = 4;

// Connecting clip dimensions
CLIP_WIDTH = 3;
CLIP_THICK = 1.5;
CLIP_OFFSET = 3;

// Usb plug dimensions
USB_WIDTH  = 16;
USB_HEIGHT = 7.5;
USB_DEPTH  = 17.5;
USB_CABLE_R = 3;
USB_CABLE_L = 18;
USB_JOIN_W = 0;
USB_JOIN_H = 0;
USB_JOIN_L = 0;

// Display port dimensions
DP_WIDTH  = 11;
DP_HEIGHT = 7.4;
DP_DEPTH  = 20;
DP_CABLE_R = 2.5;
DP_CABLE_L = 15;
DP_JOIN_W = 7.8;
DP_JOIN_H = 7.4;
DP_JOIN_L = 6;

// Power connector dimensions
PW_WIDTH = 18;
PW_HEIGHT = 7.5;
PW_DEPTH = 9.5;
PW_CABLE_R = 3.5;
PW_CABLE_L = 25;
PW_JOIN_W = 13;
PW_JOIN_H = 5.5;

// Spacing
BASELINE_OFFSET = USB_HEIGHT/2;
LEFT_WALL = 5;
USB_TO_DP_OFFSET = 19;
USB_TO_PWR_OFFSET = 48;
RIGHT_WALL = 5;

// Screws
SCREW_HOLE = 2.4;
NUT_HOLE = 5;
BOLD_HOLE = 4;

// Rubber strip
STRIP_WIDTH = 4;
STRIP_HEIGHT = 0.5;
STRIP_OFFSET = 3;
STRIP = [STRIP_WIDTH, STRIP_HEIGHT, STRIP_OFFSET];

// Derived dimensions
USB_POSITION = LEFT_WALL;
DP_POSITION = USB_POSITION + USB_TO_DP_OFFSET;
PWR_POSITION = USB_POSITION + USB_TO_PWR_OFFSET;
BOX_LENGTH = PWR_POSITION + PW_WIDTH + RIGHT_WALL;

module connector_space(first, second, third, offset, strip) {
    translate([first[0]/2, first[2]/2, -offset])
    union() {
        // conn
        cube([first[0], first[2], first[1]], center = true);
        translate([0, 0, offset/2])
            cube([first[0], first[2], offset], center = true);
        // cable
        translate([0, (first[2]+third[1])/2, 0])
            rotate([90,0,0])
                cylinder(third[1], third[0], third[0], center = true, $fn = 100);
        translate([0, (first[2]+third[1])/2, offset/2])
            cube([third[0]*2, third[1], offset], center = true);
        // join
        translate([0, (first[2]+second[2])/2, 0])
            cube([second[0], second[2], second[1]], center = true);
        translate([0, (first[2]+second[2])/2, offset/2])
            cube([second[0], second[2], offset], center = true);
        // rubber gap
        translate([0, (strip[0]-first[2])/2+strip[2], first[1]/2])
            cube([first[0], strip[0], strip[1]*2], center = true);
        translate([0, (strip[0]-first[2])/2+strip[2], -first[1]/2])
            cube([first[0], strip[0], strip[1]*2], center = true);
    }
}

module power_space(first, second, third, offset, strip) {
    translate([first[0]/2, first[2]/2, -offset])
    union() {
        // connctor
        cube([first[0], first[2], first[1]], center = true);
        translate([0, 0, offset/2])
            cube([first[0], first[2], offset], center = true);
        // wire
        translate([(third[1]-first[0])/2, first[2]/2 + third[0], 0])
            rotate([0,90,0])
                cylinder(third[1], third[0], third[0], center = true, $fn = 100);
        translate([(third[1]-first[0])/2, first[2]/2 + third[0], offset/2])
            cube([third[1], third[0]*2, offset], center = true);
        // join
        translate([0, first[2]/2, 0])
            cube([second[0], third[0] + first[2]/2, second[1]], center = true);
        // rubber gap
        translate([0, (strip[0]-first[2])/2+strip[2], first[1]/2])
            cube([first[0], strip[0], strip[1]*2], center = true);
        translate([0, (strip[0]-first[2])/2+strip[2], -first[1]/2])
            cube([first[0], strip[0], strip[1]*2], center = true);
        // led slot
        translate([0, first[2]/2 + third[0], offset+10/2])
            cube([second[0], 2, 10], center = true);
    }
}

module clip(length, design_width, design_thick) {
    width = design_width * 0.9;
    thick = design_thick * 0.9;
    translate([thick/2, 0, -length/2])
        union() {
            cube([thick, width, length], center = true);
            diagonal = sqrt(2)/2*thick;
            translate([thick/2, 0, (thick-length)/2])
                difference() {
                    rotate([0, 45, 0])
                        cube([diagonal, width, diagonal], center = true);
                    translate([0, -width/2, 0])
                        cube([diagonal, width, diagonal]);
                }
        }
}

module clip_slot(length, width, thick) {
    space = thick/2 * 1.1;
    translate([thick/2, 0, -length/2])
        union() {
            cube([thick, width, length], center = true);
            translate([thick/2, 0, -length/2 + space/2])
                cube([thick, width, space], center = true);
        }
}

module nut_side(dia, nut_dia, length) {
    nut_thick = nut_dia*0.42;
    translate([0, 0, -nut_thick])
        union() {
            cylinder(nut_thick, nut_dia / 2, nut_dia / 2, $fn = 6);
            translate([0, 0, -length])
                cylinder(length, dia / 2, dia / 2, $fn = 100);
        }
}

module bolt_side(dia, nut_dia, length) {
    nut_thick = nut_dia*0.3;
    translate([0, 0, -nut_thick])
        union() {
            cylinder(nut_thick, nut_dia / 2, nut_dia / 2, $fn = 100);
            translate([0, 0, -length])
                cylinder(length, dia / 2, dia / 2, $fn = 100);
        }
}

module inner_space() {
    union() {
        translate([USB_POSITION, 0, 0])
            connector_space(
                [USB_WIDTH, USB_HEIGHT, USB_DEPTH],
                [USB_JOIN_W, USB_JOIN_H, USB_JOIN_L],
                [USB_CABLE_R, USB_CABLE_L],
                BASELINE_OFFSET,
                STRIP
            );
        translate([DP_POSITION, 0, 0])
            connector_space(
                [DP_WIDTH, DP_HEIGHT, DP_DEPTH],
                [DP_JOIN_W, DP_JOIN_H, DP_JOIN_L],
                [DP_CABLE_R, DP_CABLE_L],
                BASELINE_OFFSET,
                STRIP
            );
        translate([PWR_POSITION, 0, 0])
            power_space(
                [PW_WIDTH, PW_HEIGHT, PW_DEPTH],
                [PW_JOIN_W, PW_JOIN_H],
                [PW_CABLE_R, PW_CABLE_L],
                BASELINE_OFFSET,
                STRIP
            );
    }
}

module tower() {
    cube();
}

module wall() {

}

if (SHOW_BOTTOM) {
    color([0.1, 0.4, 0.1])
    difference() {
        translate([0,0,-BOTTOM_HEIGHT])
            cube([BOX_LENGTH, BOTTOM_WIDTH, BOTTOM_HEIGHT]);
        inner_space();
        translate([3, 3, -BOTTOM_HEIGHT]) rotate([180, 0, 0])
            nut_side(SCREW_HOLE, NUT_HOLE, BOTTOM_HEIGHT);    
        translate([BOX_LENGTH-3, 3, -BOTTOM_HEIGHT]) rotate([180, 0, 0])
            nut_side(SCREW_HOLE, NUT_HOLE, BOTTOM_HEIGHT);    
        translate([BOX_LENGTH/2, BOTTOM_WIDTH-3, -BOTTOM_HEIGHT]) rotate([180, 0, 0])
            nut_side(SCREW_HOLE, NUT_HOLE, BOTTOM_HEIGHT);    
        translate([BOX_LENGTH/2, 3, -BOTTOM_HEIGHT]) rotate([180, 0, 0])
            nut_side(SCREW_HOLE, NUT_HOLE, BOTTOM_HEIGHT);
        // plastic clips to connect parts, don't work, they break off
        // translate([0, BOTTOM_WIDTH/2, 0])
        //  clip_slot(BOTTOM_HEIGHT, CLIP_WIDTH, CLIP_THICK);
        // translate([BOX_LENGTH, CLIP_OFFSET, 0]) rotate([0, 0, 180])
        //  clip_slot(BOTTOM_HEIGHT, CLIP_WIDTH, CLIP_THICK);
        // translate([BOX_LENGTH, BOTTOM_WIDTH-CLIP_OFFSET, 0]) rotate([0, 0, 180])
        //  clip_slot(BOTTOM_HEIGHT, CLIP_WIDTH, CLIP_THICK);
    }
}

// COVER
if (SHOW_COVER) {
    color([0.2, 0.5, 0.2])
    difference() {
        cube([BOX_LENGTH, BOTTOM_WIDTH, COVER_HEIGHT]);
        translate([3, 3, COVER_HEIGHT+0.01])
            bolt_side(SCREW_HOLE, BOLD_HOLE, BOTTOM_HEIGHT);    
        translate([BOX_LENGTH-3, 3, COVER_HEIGHT+0.01])
            bolt_side(SCREW_HOLE, BOLD_HOLE, BOTTOM_HEIGHT);    
        translate([BOX_LENGTH/2, BOTTOM_WIDTH-3, COVER_HEIGHT+0.01])
            bolt_side(SCREW_HOLE, BOLD_HOLE, BOTTOM_HEIGHT);    
        translate([BOX_LENGTH/2, 3, COVER_HEIGHT+0.01])
            bolt_side(SCREW_HOLE, BOLD_HOLE, BOTTOM_HEIGHT);    
        inner_space();
        // plastic clips to connect parts, don't work, they break off
        // Union:
        // translate([0, BOTTOM_WIDTH/2, 0])
        //  clip(BOTTOM_HEIGHT, CLIP_WIDTH, CLIP_THICK);
        // translate([BOX_LENGTH, CLIP_OFFSET, 0]) rotate([0, 0, 180])
        //  clip(BOTTOM_HEIGHT, CLIP_WIDTH, CLIP_THICK);
        // translate([BOX_LENGTH, BOTTOM_WIDTH-CLIP_OFFSET, 0]) rotate([0, 0, 180])
        //  clip(BOTTOM_HEIGHT, CLIP_WIDTH, CLIP_THICK);
    }
}

positions = [
    [0, 0,  1,  1, 180],
    [0, 1,  1, -1,  90],
    [1, 1, -1, -1,   0],
    [1, 0, -1,  1, -90]
];

module smooth_cube(size, radius, center = false, radius = 0, roundx = [], roundy = [], roundz = []) {
    difference() {
    cube(size, center);
        if (radius > 0) {
            // x
            for(index = roundx) {
                pos = positions[index];
                difference() {
                    translate([0, size[1] * pos[0] + radius * pos[2], size[2] * pos[1] + radius * pos[3]])
                        rotate([pos[4], 0, 0])
                            cube([size[0], radius, radius]);
                    translate([0, size[1] * pos[0] + radius * pos[2], size[2] * pos[1] + radius * pos[3]])
                        rotate([0, 90, 0])
                            cylinder(size[0], radius, radius, $fn=100);
                }
            }
            // y
            for(index = roundy) {
                pos = positions[index];
                difference() {
                    translate([-size[0] * pos[0] - radius * pos[2], 0, size[2] * pos[1] + radius * pos[3]])
                        rotate([0, pos[4]-90, 0])
                            cube([radius, size[1], radius]);
                    translate([-size[0] * pos[0] - radius * pos[2], 0, size[2] * pos[1] + radius * pos[3]])
                        rotate([-90, 0, 0])
                            cylinder(size[1], radius, radius, $fn=100);
                }
            }
            // z
            for(index = roundz) {
                pos = positions[index];
                difference() {
                    translate([size[0] * pos[0] + radius * pos[2], size[1] * pos[1] + radius * pos[3], 0])
                        rotate([0, 0, pos[4]])
                            cube([radius, radius, size[2]]);
                    translate([size[0] * pos[0] + radius * pos[2], size[1] * pos[1] + radius * pos[3], 0])
                        rotate([0, 0, 90])
                            cylinder(size[2], radius, radius, $fn=100);
                }
            }            
        }
    }
}

smooth_cube([10, 15, 20], radius=2, 
    /*roundx=[0, 1, 2, 3],*/ roundy=[0, 1, 2, 3]/*, roundz=[0, 1, 2, 3]*/);
