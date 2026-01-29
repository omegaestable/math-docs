%Parte a$
%Se resuelve la ecuacion
gamma=1/10;
omega=sqrt(5/4);
f= @(t,y) [y(2),-gamma*y(2) - omega^2 * sin(y(1))]';
y0=[pi/4,0];
[t,y] = ode45(f,[0,50],y0);
%Se grafica theta en funcion de t
figure 
plot(t,y(:,1),'r','Linewidth',2)
grid on
xlabel('$t$','Interpreter','Latex')
ylabel('$\theta(t)$','Interpreter', 'Latex')
title('Gr\''afica 1','Interpreter','Latex')
legend({'$\frac{d^2\theta}{dt^2} + \gamma\frac{d\theta}{dt}+\omega^2\sin{(\theta)} = 0$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')
%Se grafica theta' en funcion de theta
figure 
plot(y(:,1),y(:,2),'g','Linewidth',2)
grid on
xlabel('$\theta(t)$','Interpreter','Latex')
ylabel('$\theta''(t)$','Interpreter', 'Latex')
title('Gr\''afica 2','Interpreter','Latex')
legend({'$\frac{d^2\theta}{dt^2} + \gamma\frac{d\theta}{dt}+\omega^2\sin{(\theta)} = 0$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Parte b)%
%Se resuelve la ecuacion
y0=[pi,-0.5];
[t,y] = ode45(f,[0,50],y0);
%Se grafica theta en funcion de t
figure 
plot(t,y(:,1),'r','Linewidth',2)
grid on
xlabel('$t$','Interpreter','Latex')
ylabel('$\theta(t)$','Interpreter', 'Latex')
title('Gr\''afica 3','Interpreter','Latex')
legend({'$\frac{d^2\theta}{dt^2} + \gamma\frac{d\theta}{dt}+\omega^2\sin{(\theta)} = 0$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')
%Se grafica theta' en funcion de theta
figure 
plot(y(:,1),y(:,2),'g','Linewidth',2)
grid on
xlabel('$\theta(t)$','Interpreter','Latex')
ylabel('$\theta''(t)$','Interpreter', 'Latex')
title('Gr\''afica 4','Interpreter','Latex')
legend({'$\frac{d^2\theta}{dt^2} + \gamma\frac{d\theta}{dt}+\omega^2\sin{(\theta)} = 0$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Parte c%
%Se resuelve la ecuacion
y0=[pi,0];
[t,y] = ode45(f,[0,50],y0);
%Se grafica theta en funcion de t
figure 
plot(t,y(:,1),'r','Linewidth',2)
grid on
xlabel('$t$','Interpreter','Latex')
ylabel('$\theta(t)$','Interpreter', 'Latex')
title('Gr\''afica 5','Interpreter','Latex')
legend({'$\frac{d^2\theta}{dt^2} + \gamma\frac{d\theta}{dt}+\omega^2\sin{(\theta)} = 0$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')
%Se grafica theta' en funcion de theta
figure 
plot(y(:,1),y(:,2),'g','Linewidth',2)
grid on
xlabel('$\theta(t)$','Interpreter','Latex')
ylabel('$\theta''(t)$','Interpreter', 'Latex')
title('Gr\''afica 6','Interpreter','Latex')
legend({'$\frac{d^2\theta}{dt^2} + \gamma\frac{d\theta}{dt}+\omega^2\sin{(\theta)} = 0$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Parte d)%
%Correr manualmente los scripts Animacion_a y Animacion_c%
%Se adjuntan por aparte por razones de eficiencia, ya que este ejercicio genera muchas
%gr�ficas
  
