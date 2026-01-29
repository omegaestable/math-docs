%Parte c)%
g=@(x) x.^3 - 3*x.^2 + 3*x - 1;
x0=1/2;
tol = 1e-8;
m=1:4;
[c1,k1]=NewtonMulti(g,x0,1,tol); %se corre el m�todo para cada multiplicidad
[c2,k2]=NewtonMulti(g,x0,2,tol);
[c3,k3]=NewtonMulti(g,x0,3,tol);
[c4,k4]=NewtonMulti(g,x0,4,tol);
e1=abs(1-c1); %Se inicializan los errores
e2=abs(1-c2);
e3=abs(1-c3);
e4=abs(1-c4);
limits=[0,32,1e-11,1];
ticks= 0:4:32;
semilogy(k1,e1,k2,e2,k3,e3,k4,e4,'Linewidth',2)
xlabel('$k$','Interpreter','Latex')
ylabel('$Error$','Interpreter', 'Latex')
xticks(ticks);
title('Gr\''afica 4','Interpreter','Latex')
axis(limits)
legend({'$|1-c_1(k)|$','$|1-c_2(k)|$','$|1-c_3(k)|$','$|1-c_4(k)|$'},'Location','southeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
clear all

%parte (d)%
g= @(x) (x-1)*(x-0.9999)*(x-1.0001);
x0=1/2;
tol = 5e-5; %Se ajust� la tolerancia, ya que provocaba demasiadas fluctuaciones por redondeos
m=1:4;
[c1,k1]=NewtonMulti(g,x0,1,tol);
[c2,k2]=NewtonMulti(g,x0,2,tol);
[c3,k3]=NewtonMulti(g,x0,3,tol);
[c4,k4]=NewtonMulti(g,x0,4,tol);
e1=abs(1.0001-c1);
e2=abs(1.0001-c2);
e3=abs(1.0001-c3);
e4=abs(1.0001-c4);
figure
semilogy(k1,e1,k2,e2,k3,e3,k4,e4,'Linewidth',2)
limits=[0,21,5e-6,1];
ticks= 0:3:21;
ticks2= 10.^(-5:0);
xlabel('$k$','Interpreter','Latex')
ylabel('$Error$','Interpreter', 'Latex')
title('Gr\''afica 5','Interpreter','Latex')
axis(limits);
xticks(ticks);
yticks(ticks2);
legend({'$|1.0001-c_1(k)|$','$|1.0001-c_2(k)|$','$|1.0001-c_3(k)|$','$|1.0001-c_4(k)|$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')