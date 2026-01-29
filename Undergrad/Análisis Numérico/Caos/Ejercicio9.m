%Parte a)
Lambda=15;
gamma=1/35;
mu=1/75;
beta=1/5500;
t=[0,365];
y0=[999,1,0];
%Se inicia la funcion
f = @(t,y)[Lambda-mu*y(1)-beta*y(1).*y(2)
    beta*y(1).*y(2)-gamma*y(2)-mu*y(2)
    gamma*y(2) - mu*y(3)];
[t,y] = ode45(f,t,y0);
%Se grafica
figure 
plot(t,y(:,1),'r','Linewidth',2)
hold on
plot(t,y(:,2),'g','Linewidth',2)
plot(t,y(:,3),'b','Linewidth',2)
grid on
xlabel('$t$','Interpreter','Latex')
ylabel('$(S,I,R)$','Interpreter', 'Latex')
title('Gr\''afica 16','Interpreter','Latex')
legend({'$S(t)$','$I(t)$','$R(t)$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Parte b)%
beta=1./linspace(25000,29000);
I=[];
t=[0,3650];
for i=1:100
    % Se inicia la funcion cada iteracion
    f = @(t,y)[Lambda-mu*y(1)-beta(i)*y(1).*y(2)
        beta(i)*y(1).*y(2)-gamma*y(2)-mu*y(2)
        gamma*y(2) - mu*y(3)];
    [t,y] = ode45(f,t,y0);
    %Se a�aden entradas a I
    I=[I,y(end,2)];
end
R0=Lambda/(mu^2+mu*gamma)*beta;
%Se grafica
figure 
semilogy(R0,I,'c','Linewidth',2)
grid on
xlabel('$R_0(\beta)$','Interpreter','Latex')
ylabel('$I(3650)$','Interpreter', 'Latex')
title('Gr\''afica 17','Interpreter','Latex')
legend({'$I(3650)$'},'Location','northwest','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')


%Parte c)%
beta=1/5500;
f = @(y)[Lambda-mu*y(1)-beta*y(1).*y(2)
    beta*y(1).*y(2)-gamma*y(2)-mu*y(2)
    gamma*y(2) - mu*y(3)];
s=[];
%Se buscan exaustivamente ceros de la funcion, puede tardar unos segundos.
for t=0:50:1000
    for u=0:50:1000
        for v=0:50:1000
            sol=[u,t,v]';
            sol=NewtonMulti(f,sol,1e-5);
            s=[s,sol]; %habr�n muchas entradas repetidas.
     
        end
    end
end
%Se encontraron 2 ceros
s1=[1125,0,0];
s2=[230.5,284.6,609.9];


