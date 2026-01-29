%Parte b)%
f=@(t,y) log(t+0.01)+1/(t-4);
y0=0.8;
t0=0;
Tmax=3.99;
h0=1e-5;
hmax=1e-2;
tol=1e-12;
[t,y,H]=RKadaptivo(f,y0,t0,Tmax,h0,hmax,tol);

plot(t,y,'g','Linewidth',2)
grid on
xlabel('$t$','Interpreter','Latex')
ylabel('$y$','Interpreter', 'Latex')
title('Gr\''afica 2','Interpreter','Latex')
legend({'$\frac{dy}{dt}= \log(t+0.01)+\frac{1}{t-4} $'},'Location','southwest','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

figure 
semilogy(t,H,'r','Linewidth',2)
grid on
axis([0,4,0,0.015])
ticky= 10.^(-(5:-1:0));
yticks(ticky);
xlabel('$t$','Interpreter','Latex')
ylabel('$h$','Interpreter', 'Latex')
title('Gr\''afica 3','Interpreter','Latex')
legend({'$h$'},'Location','south','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')


%La solucion general%
F=@(t) (t+0.01).*log(t+0.01)-t-0.01+log(4-t)+0.8+0.01*log(100)+0.01-log(4);
FF=F(t);
figure 
semilogy(t,abs(FF-y),'b','Linewidth',2)
grid on
xlabel('$t$','Interpreter','Latex')
ylabel('$|y(t)-\tilde{y}(t)|$','Interpreter', 'Latex')
title('Gr\''afica 4','Interpreter','Latex')
legend({'$|y(t)-\tilde{y}(t)|$'},'Location','north','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')
