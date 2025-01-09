include <../OpenSCADdesigns/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

picksX1 = 50;
picksX2 = picksX1/2;
picksY1 = 150;
picksY2 = picksX2;
picksZ = picksX2;

picksCornerDia = 8;
picksCZ = 3;

spikeDia = 5/32 * 25.4 + 0.3;

x1 = picksX1-picksCornerDia;
x2= picksX2 - picksCornerDia;
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

		// Spike holes:
		h(picksX1*0.75);
		h(picksX2*0.5);
	}
}

module h(x)
{
	translate([x, -10, picksZ/2]) rotate([-90,0,0]) cylinder(d=spikeDia, h=400);
}

module c(p)
{
	translate(p) simpleChamferedCylinderDoubleEnded1(d=picksCornerDia, h=picksZ, cz=picksCZ);
}

module clip(d=0)
{
	// tc([-200, -200, picksZ/2-d], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
