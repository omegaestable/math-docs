%Parte b%
sigma=10;
rho=28;
beta=8/3;
f=@(x) [sigma*(x(2)-x(1)),x(1)*(rho-x(3))-x(2),x(1)*x(2)-beta*x(3)]';
s=[];
%Se buscan exaustivamente ceros de la funcion, puede tardar unos segundos.
for t=-21:7:21
    for u=-21:7:21
        for v=-21:7:21
            sol=[u,t,v]';
            sol=NewtonMulti(f,sol,1e-5);
            s=[s,sol]; %habr�n muchas entradas repetidas.
     
        end
    end
end
%Se encontraron 3 ceros
s1=[0,0,0]';
s2=[8.485281374244376,8.485281374244376, 27]';
s3=[-8.485281374259436 ,-8.485281374259436,27]';

%Parte b)%

f=@(t,x) [sigma*(x(2)-x(1)),x(1)*(rho+x(3))-x(2),x(1)*x(2)-beta*x(3)]';
T=[0,100];
x0=[1,1,1]';
[t,x] = ode45(f,T,x0);
x1=x(:,1);
y1=x(:,2);
z1=x(:,3);

%Parte c)%
f=@(t,x) [sigma*(x(2)-x(1)),x(1)*(rho+x(3))-x(2),x(1)*x(2)-beta*x(3)]';
x00=[1,1,1.00001]';
[t,x] = ode45(f,T,x00);
x2=x(:,1);
y2=x(:,2);
z2=x(:,3);

%Parte d)%
figure 
plot3(x1,y1,z1,'c','Linewidth',2)
hold on
plot3(x2,y2,z2,'m','Linewidth',2)
plot3(s1(1),s1(2),s1(3),'-ko','Linewidth',2)
plot3(s2(1),s2(2),s2(3),'ko','Linewidth',2)
plot3(s3(1),s3(2),s3(3),'ko','Linewidth',2)
grid on
xlabel('$x(t)$','Interpreter','Latex')
ylabel('$y(t)$','Interpreter', 'Latex')
zlabel('$z(t)$','Interpreter', 'Latex')
title('Gr\''afica 7','Interpreter','Latex')
legend({'$x_0 = (1,1,1)$','$x_0=(1,1,1.00001)$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Parte e)%
sol1 = ode45(f,T,x0);
sol2 = ode45(f,T,x00);
tt=linspace(0,100,1000);
X1=deval(sol1,tt);
X2=deval(sol2,tt);
d=sqrt((X1(1,:) - X2(1,:)).^2 + (X1(2,:) - X2(2,:)).^2 + (X1(3,:) - X2(3,:)).^2);

figure 
plot(tt,d,'b','Linewidth',1)
grid on
xlabel('$t$','Interpreter','Latex')
ylabel('$d(t)$','Interpreter', 'Latex')
title('Gr\''afica 8','Interpreter','Latex')
legend({'$d(t) = \sqrt{(x_1(t) - x_2(t))^2 + (y_1(t) - y_2(t))^2 + (z_1(t) - z_2(t))^2}$'},...
    'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')
