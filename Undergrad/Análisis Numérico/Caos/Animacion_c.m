
%Parte d%
%Animaci�n de c)%
gamma=1/10;
omega=sqrt(5/4);
f= @(t,y) [y(2),-gamma*y(2) - omega^2 * sin(y(1))]';
y0=[pi,0];
[t,y] = ode45(f,[0,120],y0); %Con este tiempo se ve mejor
figure
P=Pendulo(t,y(:,1),1);