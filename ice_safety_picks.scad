include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>
include <../OpenSCAD_Lib/torus.scad>

perimeterWidth = 0.42;

makePickBody_3_16 = false;
makePickModifier_3_16 = false;
makePickBody_1_4 = false;
makePickModifier_1_4 = false;

picksX1 = 50;
picksX2 = picksX1/2;
picksY2 = picksX2;
picksY1 = 150;
picksY1a = picksY1 - picksY2;
picksZ = picksX2;

echo("picksY1a =", picksY1a);

picksCornerDia = 14;
picksCornerCZ = 5;
picksCornerRadius = 5;

spikeLength = 4.9 * 25.4;

echo("spikeLength = ", spikeLength);

lanyardHoleDia = 5.5;

spikeCtrOffsetX = 0.2;
spikeCtrX1 = picksX1*0.75 + spikeCtrOffsetX;
spikeCtrX2 = picksX1*0.25;

x1 = picksX1  - picksCornerDia;
x2 = picksX2  - picksCornerDia;
y1 = picksY1a - picksCornerDia;
y2 = picksY2  - picksCornerDia;

p1 = [ 0,  0,  0];
p2 = [x1,  0,  0];
p3 = [x1, y2,  0];
p4 = [x2,  0,  0];
p5 = [ 0, y2,  0];
p6 = [ 0, y1,  0];
p7 = [x2, y1,  0];

modifierDia = picksZ - picksCornerCZ*2 - 2;
modifierY = 21;
modifierOffsetY = 2;
modifierEndY = modifierY + modifierOffsetY;

echo(str("modifierY = ", modifierY));

spikeHoleSacrificialThickness = 2*perimeterWidth;

module pickModifer_3_16()
{
	pickModiferCore(spikeHoleDiameter = 3/16 * 25.4 + 0.3);
}

module pickModifer_1_4()
{
	pickModiferCore(spikeHoleDiameter = 1/4 * 25.4 + 0.3);
}

module pickModiferCore(spikeHoleDiameter)
{
	translate([spikeCtrX2, modifierOffsetY, picksZ/2]) rotate([-90,0,0]) cylinder(d1=modifierDia, d2=spikeHoleDiameter + 2, h=modifierY);
}

module pick_3_16()
{
	pickBodyCore(spikeHoleDiameter = 3/16 * 25.4 + 0.3);
}

module pick_1_4()
{
	pickBodyCore(spikeHoleDiameter = 1/4 * 25.4 + 0.3);
}

module pickBodyCore(spikeHoleDiameter)
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
					corner(p1); corner(p2);
					corner(p5); corner(p3);
				}

				hull()
				{
					corner(p1); corner(p4);
					corner(p6); corner(p7);
				}
			}

			insideCornerChamfer();
			translate([0,0,picksZ]) mirror([0,0,1]) insideCornerChamfer();
		}

		// Spike holes:
		spikeHole(spikeCtrX1+spikeCtrOffsetX, -10, spikeHoleDiameter);
		spikeHoleChamfer(spikeCtrX1+spikeCtrOffsetX, picksY2, spikeHoleDiameter, cz=1.6);
		spikeHole(spikeCtrX2, modifierEndY, spikeHoleDiameter);

		// Thumb depression:
		thumbDepressionDia = 50;
		translate([spikeCtrX2, -thumbDepressionDia/2+1, picksZ/2]) hull()
		{
			tsp([-30, 0, 0], d=thumbDepressionDia);
			tsp([  8, 0, 0], d=thumbDepressionDia);
		}
		
		// Magnet recesses:
		magnetDia = 10.1;
		magnetThickness = 2.1;
		translate([picksX2-magnetThickness, picksY1/2, picksZ/2]) rotate([0,90,0])
		{
			cylinder(d=magnetDia, h=10);
			doubleY() translate([0, 35, 0]) cylinder(d=magnetDia, h=10);
		}

		// Lanyard hole:
		translate([picksX1/2, picksY2/2 + 0.5, 0])
		{
			tcy([0,0,-50], d=lanyardHoleDia, h=100);
			// Chamfers:
			translate([0,0,picksZ/2]) doubleZ() translate([0,0,picksZ/2-lanyardHoleDia/2-4]) cylinder(d1=0, d2=20, h=10);
		}
	}
	
	// Spike hole sacrificial layers:
	spikeHoleSacrificialLayer(spikeCtrX1, 0, spikeHoleDiameter);
	spikeHoleSacrificialLayer(spikeCtrX1, picksY2-spikeHoleSacrificialThickness, spikeHoleDiameter);
	spikeHoleSacrificialLayer(spikeCtrX2, picksY1a-spikeHoleSacrificialThickness, spikeHoleDiameter);
}

// WARNING: Much magic below!!!
transitionZ = 3.55;
torusCtrZ = 7.08;
module insideCornerChamfer()
{
	translate([picksX2, picksY2, 0])
	{		
		difference()
		{
			translate([0,0, torusCtrZ]) torus2a(radius = picksCornerRadius, translation = 12.00);
			translate([0,0, torusCtrZ]) 
			{
				tcu([-200,0,-200], 400);
				tcu([0,-200,-200], 400);
				tcu([-100,-200,0], 400);
			}
			tcu([-100,-200,-400+transitionZ], 400);
		}

		difference()
		{
			tcy([0,0,0], d=50, h=transitionZ);
			translate([0,0,-15 + picksCornerCZ + picksCornerDia/2]) cylinder(d1=30, d2=0, h=15.075);
			tcy([0,0,transitionZ], d=30, h=100);
			tcu([-200,0,-200], 400);
			tcu([0,-200,-200], 400);
			tcu([-100,-200,-400], 400);
		}

		xy = 10;
		difference()
		{
			tcu([-xy, -xy, torusCtrZ], [xy, xy, picksZ-2*torusCtrZ]);
			tcy([0,0,-100], d=14, h=200);
		}
	}
}

module spikeHole(xLocation, yLocation, spikeHoleDiameter)
{
	translate([xLocation, yLocation, picksZ/2]) rotate([-90,0,0]) cylinder(d=spikeHoleDiameter, h=400);
}

module spikeHoleChamfer(xLocation, yLocation, spikeHoleDiameter, cz)
{
	translate([xLocation, yLocation-spikeHoleDiameter/2-cz, picksZ/2]) rotate([-90,0,0]) cylinder(d1=0, d2=20, h=10);
}

module spikeHoleSacrificialLayer(xLocation, yLocation, spikeHoleDiameter)
{
	translate([xLocation, yLocation, picksZ/2]) rotate([-90,0,0]) cylinder(d=spikeHoleDiameter+4, h=spikeHoleSacrificialThickness);
}

module corner(p)
{
	translate(p) radiusedChamferedCylinderDoubleEnded(d=picksCornerDia, h=picksZ, r=picksCornerRadius, cz=picksCornerCZ);
}

module clip(d=0)
{
	tc([-200, -200, picksZ/2-d], 400);
	// tc([picksX1/2-d, -200, -200], 400);

	// rotate([0,0,45]) tcu([0,0,-200], 400);
}

if(developmentRender)
{
	// display() pickModifer();
	// displayGhost() pickBody();
	// displayGhost() spikeGhost();


	display() pick_3_16();
	%pick_3_16();
	displayGhost() spikeGhost(3/16);

	displayGhost() translate([picksX1+spikeCtrOffsetX, picksY1a+picksY2, 0]) rotate([0,0,180]) 
	{
		pick_3_16();
		spikeGhost(3/16);
	}
}
else
{
	if(makePickBody_3_16) pick_3_16();
	if(makePickModifier_3_16) pickModifer_3_16();

	if(makePickBody_1_4) pick_1_4();
	if(makePickModifier_1_4) pickModifer_1_4();
}

module spikeGhost(spikeDia_inch)
{
	d = spikeDia_inch*25.4;
	tip = 4;

	translate([spikeCtrX2, modifierEndY+0.2, picksZ/2]) rotate([-90,0,0]) 
	{
		tcy([0,0,0], d=d, h=spikeLength-tip);
		translate([0,0,spikeLength-tip]) cylinder(d2=0, d1=d, h=tip);
	}
}