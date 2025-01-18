include <../OpenSCADdesigns/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

perimeterWidth = 0.42;

makePickBody_5_32 = false;
makePickModifier_5_32 = false;
makePickBody_3_16 = false;
makePickModifier_3_16 = false;
makePickBody_1_4 = false;
makePickModifier_1_4 = false;

picksX1 = 50;
picksX2 = picksX1/2;
picksY2 = picksX2;
picksY1 = 154;
picksY1a = picksY1 - picksY2;
picksZ = picksX2;

echo("picksY1a =", picksY1a);

picksCornerDia = 14;
picksCZ = 5;

spikeLength = 5.2 * 25.4;

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

modifierDia = picksZ - picksCZ*2 - 2;
modifierY = modifierDia;
modifierOffsetY = 2;
modifierEndY = modifierY + modifierOffsetY;

module pickModifer_5_32()
{
	pickModiferCore(spikeHoleDiameter = 5/32 * 25.4 + 0.3);
}

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

module pick_5_32()
{
	pickBodyCore(spikeHoleDiameter = 5/32 * 25.4 + 0.3);
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

		// Inside corner treatment:
		translate([picksX2+picksCornerDia/2, picksY2+picksCornerDia/2, 0])
		{
			tcy([0,0,0], d=picksCornerDia, h=picksZ);
			translate([0, 0, picksZ - picksCZ - picksCornerDia/2]) cylinder(d2=30, d1=0, h=15);
			translate([0, 0,    -15 + picksCZ + picksCornerDia/2]) cylinder(d1=30, d2=0, h=15);
		}

		// Spike holes:
		spikeHole(spikeCtrX1+spikeCtrOffsetX, -10, spikeHoleDiameter);
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
	
	// // Spike hole sacrificial layers:
	// spikeHoleSacrificialLayer(spikeCtrX1, 0, spikeHoleDiameter);
	// spikeHoleSacrificialLayer(spikeCtrX1, picksY2-perimeterWidth, spikeHoleDiameter);
	// spikeHoleSacrificialLayer(spikeCtrX2, picksY1a-perimeterWidth, spikeHoleDiameter);
}

module spikeHole(xLocation, yLocation, spikeHoleDiameter)
{
	translate([xLocation, yLocation, picksZ/2]) rotate([-90,0,0]) cylinder(d=spikeHoleDiameter, h=400);
}

module spikeHoleSacrificialLayer(xLocation, yLocation, spikeHoleDiameter)
{
	translate([xLocation, yLocation, picksZ/2]) rotate([-90,0,0]) cylinder(d=spikeHoleDiameter+2, h=perimeterWidth);
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
	// display() pickModifer();
	// displayGhost() pickBody();
	// displayGhost() spikeGhost();


	display() pick_1_4();
	// %pickModifer_1_4();
	// displayGhost() spikeGhost(1/4);

	// displayGhost() translate([picksX1+spikeCtrOffsetX, picksY1a+picksY2, 0]) rotate([0,0,180]) 
	// {
	// 	pick_1_4();
	// 	spikeGhost(1/4);
	// }
}
else
{
	if(makePickBody_5_32) pick_5_32();
	if(makePickModifier_5_32) pickModifer_5_32();

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