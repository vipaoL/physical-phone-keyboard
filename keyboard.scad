rows = 4;
cols = 11;
//rows = 1;
//cols = 1;

doDrawKeyboard = true;
doDrawShell = false;
doDrawCover = true;

btnW = 6.4;
btnD = 6.3;
diodeL = 5;
diodeW = 3;
bottomH = 1.5;

spaceUnderKB = 0.5;

sepW = 1;
contactExtraSepW = 1;
contactW = 1.5;

btnHolderW = btnW + sepW + contactExtraSepW * 2;
btnHolderD = btnD + sepW;
btnHolderH = 3.5;

if (doDrawKeyboard)
    difference() {
    for (r = [0:rows - 1]) {
        translate([0, r * (btnHolderD), 0]) {
            for (c = [0:cols - 1]) {
                translate([c * (btnHolderW), 0, 0]) {
                    difference() {
                        cube([btnHolderW, btnHolderD, btnHolderH], false);
                        translate([(sepW / 2 + contactExtraSepW), sepW / 2, bottomH])cube([btnW, btnD, btnHolderH - bottomH], false);
                        translate([sepW / 2, 0, 0]) {
                            translate([0, sepW/2, 0])cube([contactW, contactW, btnHolderH]);
                            translate([0, btnHolderD - sepW/2 - contactW, 0])cube([contactW, contactW, btnHolderH]);
                        }
                        translate([btnHolderW - sepW/2 - contactW, 0, 0]) {
                            translate([0, sepW/2, 0])cube([contactW, contactW, btnHolderH]);
                            translate([0, btnHolderD - sepW/2 - contactW, 0])cube([contactW, contactW, btnHolderH]);
                        }
                        translate([btnHolderW / 2, btnHolderD / 2, btnHolderH / 2]) {
                            rotate([0, 0, -50]) {
                                translate([0, diodeW / 5, 0])cube([diodeL, diodeW, btnHolderH], true);
                                translate([0, diodeW / 5, -btnHolderH / 2 + diodeW / 6])cube([diodeL + 3.5, diodeW / 6, diodeW / 3], true);
                            }
                        }
                    }
                }
            }
        }
    }
    for (c = [0:cols - 1])
        translate([c * btnHolderW + 2.25, 0, 0]) cube([1, btnHolderD * rows, diodeW / 3], false);
    }
    
    

if (doDrawShell)
    difference() {
        cube([btnHolderW * cols, btnHolderD * rows, btnHolderH], false);
    }