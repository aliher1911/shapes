length = 11;
gap1   = 1;   // 1
gap2   = 1.4; // 1.2
gap3   = 3;   // 3
gap_all = gap1 + gap2 + gap3;
width1 = 2.8;   // 2.7   -> 2.8
width2 = 5.2;  // 4.75  -> 4.4; 5 -> still less
width3 = 3.5;  // 3.25  -> 3.03
holder_height = 7;

// layer of slot of fixed width and round end on one side
module layer(width, height, length, shift=0) {
    union() {
        translate([-width/2,0,shift])
            cube([width,length,height]);
        translate([0,0,shift])
            cylinder(height, width/2, width/2, $fn=100);
    }
}

// slot shape to insert remaining TrackIR pin
module grove() {
    union() {                                       //     real   expect   diff   ratio
        layer(width3, gap3, length, 0);             // w = 3.03   3.25     -0.22
        layer(width2, gap2, length, gap3);          // w = 4.4    4.75     -0.35
        layer(width1, gap1+0.1, length, gap3+gap2); // w = 2.8    2.7      +0.1
    }
}

// square piece where TrackIR stays
module holder() {
    offset = holder_height-gap_all;
    translate([0, 5, offset]) difference() {
        translate([-10, -5, -offset]) cube([20, 15, holder_height]);
        grove();
    }
}


base_wall = 3;
base_width_ir = 40;
base_width_cam = 30;
base_width = base_width_ir; // + base_width_cam;
base_gap = 44.5;
base_height = 5;
base_hook_height = 5; // was 7

// part of holder that sits on monitor
module basement2() {
    union() {
        cube([base_width, base_gap+1.4, base_height]);
        translate([0, -base_wall, -base_hook_height]) cube([base_width, base_wall, base_height + base_hook_height]);
        translate([0, base_gap]) rotate([20, 0, 0]) translate([0, 0, -base_hook_height-0.9]) cube([base_width, base_wall, base_height + base_hook_height]);
    }
}

wire_dia = 3;
wire_thick = 1.5;
wire_thick2 = 3;
wire_gap_width = 2.2;

module wire_hole() {
    difference() {
        union() {
            cylinder(h=wire_thick2, r=wire_dia/2+wire_thick, center=true, $fn=100);
            translate([0,-(wire_dia/2+wire_thick)/2,0]) cube([wire_dia+wire_thick*2, wire_dia/2+wire_thick, wire_thick2], center=true);
        }
        cylinder(h=wire_thick2+1, r=wire_dia/2, center=true, $fn=100);
        translate([0,wire_dia+wire_thick,0]) cube([wire_gap_width, (wire_dia+wire_thick) * 2, wire_thick2+1], center=true);
    }
}

module tail(thick, width, len, angle, base_thick) {
    vert_len = thick/cos(angle);
    center_shift = -(base_thick-vert_len)/2 * tan(90-angle);
    translate([0, center_shift, base_thick/2]) rotate([-angle, 0, 0]) difference() {
        // translate([width/2, 0, 0]) 
        union() {
            // round end
            color([1,0.2,0.2]) translate([0, len, 0]) rotate([0, 90, 0]) cylinder(h=width, r=thick/2, center=true, $fn = 100);
            // main plane
            color([1,0.3,0.3]) translate([0, len/2 - thick/4, 0]) cube([width, len + thick/2, thick], center=true);
            // joining bit
            color([1,0.4,0.4]) rotate([angle, 0, 0]) cube([width, base_thick, base_thick], center=true);
        }
        // base plane trim above
        color ([0, 1, 0]) translate([0, 0, thick]) cube([width+2, len * 2, thick], center=true);
        // join trim
        color ([0, 0, 1]) rotate([angle, 0, 0]) translate([0, 0, base_thick]) cube([width+2, base_thick, base_thick], center=true);
        color ([0, 0, 1]) rotate([angle + 90, 0, 0]) translate([0, 0, base_thick]) cube([width+2, base_thick, base_thick], center=true);

    }
}

base_depth = 20;
back_radius = 100;
back_thickness = 5;
base_gap_width = 25;

module basement() {
    difference() {
        union() {
            // flat part
            cube([base_width, base_depth, base_height]);
            translate([0,12.5,-2]) cube([base_width, 4, base_height + 2]);
            // front side
            translate([0, -base_wall, -base_hook_height]) cube([base_width, base_wall, base_height + base_hook_height]);
            // back curve (shift -21, +10) -> (-18, 3)
            // difference() {
            //     translate([base_width/2, -back_radius/2-9.5, -back_radius/2-9]) rotate([0,90,0]) difference() {
            //         cylinder(h=base_width, r=back_radius, center=true, $fn=500);
            //         cylinder(h=base_width+2, r=back_radius - back_thickness, center=true, $fn=500);
            //     }
            //     translate([-1, -back_radius*3, 2]) cube([base_width+2, back_radius*6, 100]);
            //     translate([-1, -back_radius*3, -back_radius*3-7]) cube([base_width+2, back_radius*6, back_radius*3]);
            //     translate([-1, -back_radius*2, -back_radius]) cube([base_width+2, back_radius*2, back_radius*2]);
            // }
            
            translate([base_width/2, 12.5 + 4, -2]) tail(base_height, base_width, 10, 30, base_height);
        }
        translate([(base_width-base_gap_width)/2, 0, -back_radius]) cube([base_gap_width, back_radius, back_radius]);
        translate([(base_width-base_gap_width)/2, base_depth, 0]) cube([base_gap_width, back_radius, back_radius]);
    }
}

module basement2() {
    union() {
        // flat part
        cube([base_width, base_gap+1.4, base_height]);
        // front side
        translate([0, -base_wall, -base_hook_height]) cube([base_width, base_wall, base_height + base_hook_height]);
        // back side
        translate([0, base_gap]) rotate([20, 0, 0]) translate([0, 0, -base_hook_height-0.9]) cube([base_width, base_wall, base_height + base_hook_height]);
    }
}

cam_holder_offset = 35;
cam_holder_height = 27;
cam_holder_width = 22;
cam_holder_thinkness = 5;

module main() {
    rotate([90, 0, 0]) union() {
        translate([0, base_wall, 0]) 
            basement();
        translate([base_width_ir/2, 0, base_height]) 
            holder();
        // translate([base_width_ir + (base_width_cam - cam_holder_width)/2, cam_holder_offset - cam_holder_thinkness - base_wall, base_height]) 
        //     cube([cam_holder_width, cam_holder_thinkness, cam_holder_height]);
        translate([base_width_ir/2, base_depth + base_wall + (wire_thick/2 + wire_dia)/2 + 0.5, base_height-wire_thick2/2]) wire_hole();
    }
}

main();

// tail-height, width, length, angle, base-plate-height
// tail(base_height, base_width, 10, 65, base_height+2);
