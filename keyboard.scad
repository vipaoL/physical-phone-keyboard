rows = 4;
cols = 11;
layout = [
"Q","W","E","R","T","Y","U","I","O","P","⌫",
"A","S","D","F","G","H","J","K","L","-","↵",
"Z","X","C","V","B","N","M",",",".","/","→",
"⬀","⇧","◆","␣","↹","alt","◆","`","'","←","ct"];


doDrawKeyboard = false;
doDrawShell = false;
doDrawCover = true;
doDrawSigns = false;

btnW = 6.4;
btnD = 6.3;
btnH = 6;
keycapW = 7;
keycapD = 5;
    
diodeL = 5;
diodeW = 3;
contactGrooveThickness = diodeW / 3;
bottomH = 1.5;

spaceUnderKB = 1;

sepW = 1;
contactExtraSepW = 1;
contactW = 1.5;

btnHolderW = btnW + sepW + contactExtraSepW * 2;
btnHolderD = btnD + sepW;
btnHolderH = 3.5;

kbW = btnHolderW * cols; 
kbD = btnHolderD * rows;
kbH = bottomH + btnH;

shellThickness = 1;
gap = 1.5;
shellW = shellThickness*2 + gap*2 + kbW;
shellD = shellThickness*2 + gap*2 + kbD;
shellH = shellThickness + spaceUnderKB + kbH;
echo(kbW);

yLatchCount = 2;
latchWidth = 5;
latchHoleDepth = shellThickness - 0.0; // 0.0 = through hole. if > 0, then will be covered
latchDepth = latchHoleDepth / 2;
latchH = 2;
latchZOffset = 2;

couplingW = btnHolderD - contactGrooveThickness;
couplingL = 7;
couplingH = min(3, shellH);
coupZOffset = min(2, shellH - couplingH);

if (doDrawKeyboard) translate([shellThickness + gap, shellThickness + gap, shellThickness + spaceUnderKB]) {
    difference() {
        for (r = [0:rows - 1]) {
            translate([0, r * (btnHolderD), 0]) {
                for (c = [0:cols - 1]) {
                    translate([c * (btnHolderW), 0, 0]) {
                        difference() {
                            cube([btnHolderW, btnHolderD, btnHolderH], false);
                            
                            // button holder hole
                            translate([(sepW / 2 + contactExtraSepW), sepW / 2, bottomH])cube([btnW, btnD, btnHolderH - bottomH], false);
                            // holes for two right contacts of the button
                            translate([sepW / 2, 0, 0]) {
                                translate([0, sepW/2, 0])cube([contactW, contactW, btnHolderH]);
                                translate([0, btnHolderD - sepW/2 - contactW, 0])cube([contactW, contactW, btnHolderH]);
                            }
                            // holes for two left contacts of the button
                            translate([btnHolderW - sepW/2 - contactW, 0, 0]) {
                                translate([0, sepW/2, 0])cube([contactW, contactW, btnHolderH]);
                                translate([0, btnHolderD - sepW/2 - contactW, 0])cube([contactW, contactW, btnHolderH]);
                            }
                            // holes for diodes
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
        // grooves for contacts of diodes for each column
        for (c = [0:cols - 1])
            translate([c * btnHolderW + 2.25, 0, 0]) cube([1, btnHolderD * rows, contactGrooveThickness], false);
    }
}
    

if (doDrawShell) {  
    difference() {
        cube([shellW, shellD, shellH], false);
        translate([(shellThickness), (shellThickness), shellThickness])
            cube([shellW - shellThickness*2, shellD - shellThickness*2, shellH - shellThickness], false);
        // slits for each of column wires
        for (c = [0:cols - 1])
            translate([c * btnHolderW + 2.25 + shellThickness + gap, shellD - shellThickness, shellThickness]) cube([contactGrooveThickness, shellThickness, shellW - shellThickness], false);
        // one slit for row wires
        rowwiresSlitW = 1.5;
        translate([shellW - shellThickness - rowwiresSlitW - gap, shellD - shellThickness, shellThickness]) cube([rowwiresSlitW + gap, shellThickness, shellH - shellThickness], false);
        // latch slots
        y = shellH - latchZOffset - latchH;
        k = shellD / yLatchCount;
        for (i = [1:yLatchCount]) {
            translate([shellThickness - latchHoleDepth, k * (i-0.5) - latchWidth / 2, y]) cube([latchHoleDepth, latchWidth, latchH], false);
            translate([shellW - shellThickness, k * (i-0.5) - latchWidth / 2, y]) cube([latchHoleDepth, latchWidth, latchH], false);
        }
    }
    
    // couplings
    midColumn = floor(cols/2);
    for (col = [midColumn - 1: midColumn + 1])
    translate([btnHolderW * col + 2.25 + contactGrooveThickness + (btnHolderW-contactGrooveThickness-couplingW) / 2 + shellThickness + gap, shellD, coupZOffset]) {
        difference() {
            cube([couplingW, couplingL, couplingH]);
            translate([couplingW / 2, couplingL / 2, 0]) cylinder(d=2.3, h=couplingH, $fn=20);
        }
    }
    
    kbSupportW = btnHolderW - btnW;
    kbSupportD = btnD - contactW*2;
    kbSupportH = spaceUnderKB;
    translate([shellThickness + gap, shellThickness + gap, shellThickness + kbSupportH / 2]) {
        for (c = [0:cols]) {
            x = c * btnHolderW;
            translate([x, 0, 0])
            for (r = [0:rows - 1]) {
                y = r * btnHolderD + btnHolderD/2;
                translate([0, y, 0])
                cube([kbSupportW, kbSupportD, kbSupportH], true);
            }
        }
    }
}

if (doDrawCover) translate([shellThickness, shellThickness, shellH]) {
    coverW = shellW - shellThickness*2;
    echo(coverW);
    coverD = shellD - shellThickness*2;
    gapp = 0.25;
    
    // top cover
    let() {
        r = min(keycapW, keycapD) / 2;
        cutoutW = kbW - r*2 - shellThickness*2 + (btnHolderW - keycapW);
        cutoutD = kbD - r*2 - shellThickness*2 + (btnHolderD - keycapD);
        translate([0, 0, gapp]) difference() {
            translate([-shellThickness, -shellThickness, 0])
            cube([shellW, shellD, shellThickness]);
            translate([-(cutoutW - kbW) / 2 + gap, -(cutoutD - kbD) / 2 + gap, 0])
            //resize([coverW - shellThickness*2, coverD - shellThickness*2, 1])
            minkowski($fn=50) {
                cube([cutoutW, cutoutD,1]);
                cylinder(r=r,h=1);
            }
        }
    }
    innerPartH = latchZOffset + latchH;
    translate([0, 0, -innerPartH]) difference() {
        cube([coverW, coverD, innerPartH + gapp]);
        translate([shellThickness, shellThickness, 0])
        cube([coverW - shellThickness*2, coverD - shellThickness*2, innerPartH + gapp]);
    }
    // latches
    y = -innerPartH + gapp;
    k = shellD / yLatchCount;
    translate([-shellThickness, -shellThickness, 0])
    for (i = [1:yLatchCount]) {
        translate([0, k * (i-0.5) - latchWidth / 2 + gapp, y]) {
            translate([shellThickness - latchHoleDepth/3, 0, 0]) cube([latchDepth, latchWidth, latchH], false);
            translate([shellW - shellThickness, 0, 0]) cube([latchDepth, latchWidth - gapp*2, latchH - gapp*2], false);
        }
    }
    
    // keycaps
    a = 5;
    r = 1;
    scaleW = keycapW / a;
    scaleD = keycapD / a;
    offsetX = r * scaleW - keycapW / 2 + btnHolderW / 2;
    offsetY = r * scaleD - keycapD / 2 + btnHolderD / 2;
    for (row = [0:rows - 1]) {
        translate([gap, row * (btnHolderD), gapp]) { //gap
            for (col = [0:cols - 1]) {
                translate([col * (btnHolderW), gap, 0]) { //gap
                    translate([offsetX, offsetY, 0])
                    resize([keycapW, keycapD, 1])
                    minkowski($fn=50) {
                        cube([a-2*r, a-2*r,1]);
                        cylinder(r=r,1);
                    }
                }
            }
        }
    }
    
    intersection() {
        for (row = [0:rows]) {
            translate([gap, row * (btnHolderD), gapp]) { //gap
                for (col = [0:cols]) {
                    translate([col * (btnHolderW), gap, 0]) { //gap
                        difference() {
                            d = 7;
                            cylinder(d=d, 0.2, true, $fn=20);
                            cylinder(d=d - 2, 0.2, true, $fn=20);
                        }
                    }
                }
            }
        }
        cube([coverW, coverD, shellThickness]);
    }
}

if (doDrawSigns) translate([kbW, kbD, 0]) {
    echo(layout);
    fontSize = keycapD / 1.1;
    for (i = [1:len(layout)]) {
        echo(i);
        translate([(-(i - 1) % cols - 1) * btnHolderW, -(floor((i-1)/cols + 1) + 0.5) * btnHolderD, 0]) {
            linear_extrude(height = 0.2) rotate([0, 180, 0]) text(layout[i - 1], fontSize, halign="center", font="DejaVu Sans:style=Bold");
        }
    }
    echo("testtttttttttttttttttttt");
}