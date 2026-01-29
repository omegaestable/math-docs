%Ejercicio 8
%parte d)
f = @(x,y) y-x+1;
c1=cuad1(f);
c2=cuad2(f);
g = @(x,y) x^2 - x*y+x -y;
c3=cuad1(g);
c4=cuad2(g);
%parte e)
h=@(x,y) sin(pi*x)*cos(pi*y);
q1=cuad1(h);
q2=cuad2(h);
%parte f)
x1=-1;
x2=1;
x3=0;
y1=1;
y2=3;
y3=5;
u= @(x,y) x1*(1-x-y) + x2*x+x3*y;
v= @(x,y) y1*(1-x-y) + y2*x+y3*y;
f= @(x,y) (u(x,y)* u(x,y)) * exp(-(u(x,y)+v(x,y)));
I1=6*cuad1(f);
I2=6*cuad2(f);
