%Ejercicio 7.c
f = @(x) 816*x.^3 - 3835*x.^2 + 6000*x -3125;
x0=1.6;
tol=1e-6;
sucNewton = Newton(f,x0,tol);
sucIter = iter(f,x0,tol);
n=length(sucNewton);
m=length(sucIter);
n=0:n;
m=0:m;
c=25/16; %Esta raíz es a la cual convergen
error1 = abs(sucNewton - c);
error1=[abs(x0-c),error1];
error2 = abs(sucIter - c);
error2=[abs(x0-c),error2];
figure
semilogy(n,error1,'g','LineWidth',2) 
grid on
hold on
semilogy(m,error2,'r','LineWidth',2)
xlabel('$n$','Interpreter','Latex')
ylabel('$Error$','Interpreter', 'Latex')
legend({'$|c-c_n|$','$|c-x_n|$'},'Location','northeast','Interpreter','Latex')
title('Gr\''afica 1','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')

%Ejercicio 7.c
xx=linspace(1.4,1.7);
n=length(xx);
convNewton= zeros(1,100);
for i=1:n
    suc=Newton(f,xx(i),1e-7);
    ck=suc(end);
    convNewton(i)=ck;
end
figure 
plot(xx,convNewton,'o','MarkerEdgeColor','black','MarkerFaceColor','black') 
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('Valor de convergencia $c$','Interpreter', 'Latex')
title('Gr\''afica 2','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')

xx=linspace(1.4,1.7);
n=length(xx);
convIter= zeros(1,100);
for i=1:n
    suc=iter(f,xx(i),1e-7);
    ck=suc(end);
    convIter(i)=ck;
end
figure 
plot(xx,convIter,'o','MarkerEdgeColor','red','MarkerFaceColor','red') 
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('Valor de convergencia $c$','Interpreter', 'Latex')
title('Gr\''afica 2','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
