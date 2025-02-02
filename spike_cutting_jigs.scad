include <../OpenSCAD_Lib/MakeInclude.scad>

spikeLen = 124.5;
spikeDia = 3/16 * 25.4;

endX = 5;
endZ = 15;

x = spikeLen + 2*endX;
y = 8 + spikeDia + 8;
z = 3;

spineZ = z + 3;

module itemModule()
{
	difference()
    {
        union()
        {
            cube([x, y, z]);
            cube([endX, y, endZ]);
            translate([x-endX,0,0]) cube([endX, y, endZ]);
        }
        endCutY = spikeDia + 0.2;
        tcu([-10, (y-endCutY)/2, spineZ], [20, endCutY, 20]);
    }

    spineY = spikeDia - 0.5;
    tcu([0, (y-spineY)/2, 0], [x, spineY, spineZ]);
}

module clip(d=0)
{
	// tc([-200, -400-d+y/2, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
    displayGhost() translate([endX, y/2, z+spikeDia/2+3]) rotate([0,90,0]) cylinder(d=spikeDia, h=spikeLen);
}
else
{
	itemModule();
}
