length = 11;
gap1   = 1;   // 1
gap2   = 1.4; // 1.2
gap3   = 3;   // 3
gap_all = gap1 + gap2 + gap3;
width1 = 2.8;   // 2.7   -> 2.8
width2 = 5.2;  // 4.75  -> 4.4; 5 -> still less
width3 = 3.5;  // 3.25  -> 3.03
holder_height = 7;

module layer(width, height, length, shift=0) {
    union() {
        translate([-width/2,0,shift])
            cube([width,length,height]);
        translate([0,0,shift])
            cylinder(height, width/2, width/2, $fn=100);
    }
}

module grove() {
    union() {                                       //     real   expect   diff   ratio
        layer(width3, gap3, length, 0);             // w = 3.03   3.25     -0.22
        layer(width2, gap2, length, gap3);          // w = 4.4    4.75     -0.35
        layer(width1, gap1+0.1, length, gap3+gap2); // w = 2.8    2.7      +0.1
    }
}


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
base_width = base_width_ir + base_width_cam;
base_gap = 44.5;
base_height = 5;
base_hook_height = 7;

module basement() {
    union() {
        cube([base_width, base_gap+1.4, base_height]);
        translate([0, -base_wall, -base_hook_height]) cube([base_width, base_wall, base_height + base_hook_height]);
        translate([0, base_gap]) rotate([20, 0, 0]) translate([0, 0, -base_hook_height-0.9]) cube([base_width, base_wall, base_height + base_hook_height]);
    }
}

cam_holder_offset = 35;
cam_holder_height = 27;
cam_holder_width = 22;
cam_holder_thinkness = 5;

rotate([90, 0, 0]) union() {
    translate([0, base_wall, 0]) 
        basement();
    translate([base_width_ir/2, 0, base_height]) 
        holder();
    translate([base_width_ir + (base_width_cam - cam_holder_width)/2, cam_holder_offset - cam_holder_thinkness - base_wall, base_height]) 
        cube([cam_holder_width, cam_holder_thinkness, cam_holder_height]);
}
