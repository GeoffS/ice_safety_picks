include <../OpenSCADdesigns/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

picksX1 = 50;
picksX2 = picksX1/2;
picksY2 = picksX2;
picksY1 = 154 - picksY2;
picksZ = picksX2;

echo("picksY1 =", picksY1);

picksCornerDia = 8;
picksCZ = 3;

spikeDia = 5/32 * 25.4 + 0.3;

lanyardHoleDia = 5.5;

spikeCtrX1 = picksX1*0.75;
spikeCtrX2 = picksX1*0.25;

x1 = picksX1  -picksCornerDia;
x2 = picksX2 - picksCornerDia;
y1 = picksY1 - picksCornerDia;
y2 = picksY2 - picksCornerDia;

p1 = [ 0,  0,  0];
p2 = [x1,  0,  0];
p3 = [x1, y2,  0];
p4 = [x2,  0,  0];
p5 = [ 0, y2,  0];
p6 = [ 0, y1,  0];
p7 = [x2, y1,  0];

module itemModule()
{
	difference()
	{
		// Exterior:
		translate([picksCornerDia/2, picksCornerDia/2, 0])
		{
			union()
			{
				hull()
				{
					c(p1); c(p2);
					c(p5); c(p3);
				}

				hull()
				{
					c(p1); c(p4);
					c(p6); c(p7);
				}
			}

			// Inside corner filler:
			translate([picksX2, picksY2, 0])
			{
				cfXY = picksCZ + picksCornerDia/2;
				tcu([-cfXY, -cfXY, 0], [cfXY, cfXY, picksZ]);
			}
		}

		// Inside oorner treatment:
		translate([picksX2+picksCornerDia/2, picksY2+picksCornerDia/2, 0])
		{
			tcy([0,0,0], d=picksCornerDia, h=picksZ);
			translate([0, 0, picksZ-picksCZ-picksCornerDia/2]) cylinder(d2=20, d1=0, h=10);
			translate([0, 0,    -10+picksCZ+picksCornerDia/2]) cylinder(d1=20, d2=0, h=10);
		}

		// Spike holes:
		h(spikeCtrX1);
		h(spikeCtrX2);

		// Lanyard hole:
		translate([picksX1/2, picksY2/2, 0])
		{
			tcy([0,0,-50], d=lanyardHoleDia, h=100);
			// Chamfers:
			translate([0,0,picksZ/2]) doubleZ() translate([0,0,picksZ/2-lanyardHoleDia/2-4]) cylinder(d1=0, d2=20, h=10);
		}
	}
}

module h(xLocation)
{
	translate([xLocation, -10, picksZ/2]) rotate([-90,0,0]) cylinder(d=spikeDia, h=400);
}

module c(p)
{
	translate(p) simpleChamferedCylinderDoubleEnded1(d=picksCornerDia, h=picksZ, cz=picksCZ);
}

module clip(d=0)
{
	// tc([-200, -200, picksZ/2-d], 400);
	// tc([picksX1/2-d, -200, -200], 400);
}

if(developmentRender)
{
	display() itemModule();
	displayGhost() spikeGhost(spikeCtrX1, picksY1+picksY2, direction=1);
	displayGhost() spikeGhost(spikeCtrX2, 0, direction=0);
	displayGhost() translate([picksX1, picksY1+picksY2, 0]) rotate([0,0,180]) itemModule();
}
else
{
	itemModule();
}

module spikeGhost(xLocation, yLocation, direction)
{
	d = 5/32*25.4;
	h = 6*25.4;
	tip = 4;

	translate([0,yLocation-h*direction,0]) mirror([0,direction,0]) translate([0,-direction*h,0]) translate([xLocation, 0, picksZ/2]) rotate([-90,0,0]) 
	{
		tcy([0,0,0], d=d, h=h-tip);
		translate([0,0,h-tip]) cylinder(d2=0, d1=d, h=tip);
	}
}