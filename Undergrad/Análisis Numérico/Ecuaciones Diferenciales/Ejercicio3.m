%Ejercicio 3b%
Tmax=40;
t0=0;
h0=1e-5;
T=17.0652166;
u=0.012277471;
u_c = 1-u;
x0=0.994;
y0=0;
z0=0;
w0=-2.001585106;
hmax=1e-2;
tol=1e-6; %El valor de la soluci�n es muy sensible al valor
% la tolerancia!
%Se escribe todo u$
u=@(x,y,z,w) [z;w;
    x+2*w-u_c*(x+u)/(((x+u)^2 + y^2)^(3/2))-u*(x-u_c)/(((x-u_c)^2 + y^2)^(3/2));
    y-2*z-u_c*y/(((x+u)^2 + y^2)^(3/2)) - u*y/(((x-u_c)^2 + y^2)^(3/2))];
%Se introduce en una funci�n vectorial 
f = @(t,Y) u(Y(1),Y(2),Y(3),Y(4));
u0=[x0,y0,z0,w0];
[t1,u,H] = RKadaptivo(f,u0,t0,Tmax,h0,hmax,tol);
X=u(1,:);
Y=u(2,:);

figure 
plot(X,Y,'c','Linewidth',2)
grid on
xlabel('$x(t)$','Interpreter','Latex')
ylabel('$y(t)$','Interpreter', 'Latex')
title('Gr\''afica 5','Interpreter','Latex')
legend({'$(x(t),y(t))$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Cuidadosamente se determin� que los valores m�s cercanos del vector t  a T
%y a 2T se encuentran en las posiciones 1755 y 3498%
disp('M�todo adaptivo')
X(1)
X(1755)
X(3498)
disp('--')
Y(1)
Y(1755)
Y(3498)

%Parte c)%
[t,u]=ode113(f,[0,40],u0);

X=u(:,1);
Y=u(:,2);
disp('--')
figure 
plot(X,Y,'m','Linewidth',2)
grid on
xlabel('$x(t)$','Interpreter','Latex')
ylabel('$y(t)$','Interpreter', 'Latex')
title('Gr\''afica 6','Interpreter','Latex')
legend({'$(x(t),y(t))$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')
%Esta vez se determin� que los valores m�s cercanos del vector t  a T
%y a 2T se encuentran en las posiciones 197 y 377%
disp('ode113')
X(1)
X(197)
X(377)
disp('--')
Y(1)
Y(197)
Y(377)
disp('--')

%Parte d)%
options = odeset('RelTol',1e-10,'Stats','on','AbsTol',1e-10);
[t,u]=ode113(f,[0,40],u0,options);

X=u(:,1);
Y=u(:,2);
figure 
plot(X,Y,'g','Linewidth',2)
grid on
xlabel('$x(t)$','Interpreter','Latex')
ylabel('$y(t)$','Interpreter', 'Latex')
title('Gr\''afica 7','Interpreter','Latex')
legend({'$(x(t),y(t))$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Esta vez se determin� que los valores m�s cercanos del vector t  a T
%y a 2T se encuentran en las posiciones  792 y 1567%
disp('ode113 con opciones')
X(1)
X(792)
X(1567)
disp('--')
Y(1)
Y(792)
Y(1567)
disp('--')
