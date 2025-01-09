include <../OpenSCADdesigns/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

picksX1 = 50;
picksX2 = picksX1/2;
picksY1 = 150;
picksY2 = picksX2;
picksZ = picksX2;

picksCornerDia = 8;
picksCZ = 3;

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

module c(p)
{
	translate(p) simpleChamferedCylinderDoubleEnded1(d=picksCornerDia, h=picksZ, cz=picksCZ);
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
