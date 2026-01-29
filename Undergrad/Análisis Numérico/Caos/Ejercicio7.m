%Parte b%
%Escribimos A manualmente
A=[0 0 2 0 0 0 0 0
0 -2 0 6 0 0 0 0
0 0 -6 0 12 0 0 0
0 0 0 -12 0 20 0 0
0 0 0 0 -20 0 30 0
0 0 0 0 0 -30 0 42
0 0 0 0 0 0 -42 0
0 0 0 0 0 0 0 56];
%Calculamos sus valores y vectores propios
[V,D]=eig(A);
f0 = @(x) 1+0*x;
f1 = @(x) x;
f2 = @(x) -0.316227766016838  +  0.948683298050514*x.^2;
f3 = @(x)   -0.514495755427526*x +   0.857492925712544*x.^3;
f4 = @(x)   0.064941758926623 + -0.649417589266229*x.^2 + 0.757653854143933*x.^4;
f5 = @(x)  0.157294589417842*x  -0.734041417283264*x.^3 +   0.660637275554937*x.^5;
f6 = @(x)  -0.012360344545550 + 0.259567235456548*x.^2 -0.778701706369644*x.^4 +0.571047918004405*x.^6;
f7= @(x) 0.013240981967505*x + 0.127996159019214*x.^3+0.435186940665328*x.^5+ 0.891097068981386*x.^7;

% %Graficamos
xx=linspace(-1,1,2000);
ff0=f0(xx);
ff1=f1(xx);
ff2=f2(xx);
ff3=f3(xx);
ff4=f4(xx);
ff5=f5(xx);
ff6=f6(xx);
ff7=f7(xx);

figure 
hold on
plot(xx,ff0,'m','Linewidth',2)
plot(xx,ff1,'y','Linewidth',2)
plot(xx,ff2,'r','Linewidth',2)
plot(xx,ff3,'g','Linewidth',2)
plot(xx,ff4,'c','Linewidth',2)
plot(xx,ff5,'b','Linewidth',2)
plot(xx,ff6,'k','Linewidth',2)
plot(xx,ff7,'-','Linewidth',2)
grid on
xlabel('$p_i(t)$','Interpreter','Latex')
ylabel('$t$','Interpreter', 'Latex')
title('Gr\''afica 9','Interpreter','Latex')
legend({'$p_{0}(t)$','$p_{-2}(t)$','$p_{-6}(t)$','$p_{-12}(t)$','$p_{-20}(t)$',...
    '$p_{-30}(t)$','$p_{-42}(t)$','$p_{-56}(t)$'},...
    'Location','southeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')