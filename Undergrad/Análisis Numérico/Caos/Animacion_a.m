
%Parte d%
%Animaci�n de a)%
gamma=1/10;
omega=sqrt(5/4);
f= @(t,y) [y(2),-gamma*y(2) - omega^2 * sin(y(1))]';
y0=[pi/4,0];
[t,y] = ode45(f,[0,50],y0);
figure
P=Pendulo(t,y(:,1),1);