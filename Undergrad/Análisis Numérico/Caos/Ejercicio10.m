%Parte b)%
f=@(t,y) log(t+0.01)+1/(t-4);
y0=0.8;
a=0;
b=3.99;
h=5e-4;
[t,y]=RK4imp(f,a,b,h,y0);
plot(t,y,'g','Linewidth',2)
grid on
xlabel('$t$','Interpreter','Latex')
ylabel('$y$','Interpreter', 'Latex')
title('Gr\''afica 18','Interpreter','Latex')
legend({'$\frac{dy}{dt}= \log(t+0.01)+\frac{1}{t-4} $'},'Location','southwest','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%La solucion general%
F=@(t) (t+0.01).*log(t+0.01)-t-0.01+log(4-t)+0.8+0.01*log(100)+0.01-log(4);
FF=F(t);

figure 
semilogy(t,abs(FF-y),'b','Linewidth',2)
grid on
xlabel('$t$','Interpreter','Latex')
ylabel('$|y(t)-\tilde{y}(t)|$','Interpreter', 'Latex')
title('Gr\''afica 19','Interpreter','Latex')
legend({'$|y(t)-\tilde{y}(t)|$'},'Location','north','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')
