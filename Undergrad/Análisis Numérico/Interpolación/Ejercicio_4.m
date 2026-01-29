%parte b)%
f= @(x) 1/(1+25*x^2);
n=10;
[c,nodos]=interpCheb(n,f);
c=flipud(c);
xx=linspace(-1,1,1e3);
pn=zeros(length(xx),1);
for i=1:length(xx)
    pn(i)=evalCheb(c,xx(i));
end
yy=zeros(length(xx),1);
for i=1:length(xx)
    yy(i)=f(xx(i));
end
ff=zeros(length(nodos),1);
for i=1:length(nodos)
    ff(i)=f(nodos(i));
end
figure
plot(xx,pn,'r','Linewidth',2)
hold on

plot(xx,yy,'b','Linewidth',2) 
plot(nodos,ff,'ok','Markersize',7,'MarkerFaceColor','k')
grid on
ticks= -1:0.25:1;
ticks2= 0:0.1:1;
xlabel('$x$','Interpreter','Latex')
ylabel('$y$','Interpreter', 'Latex')
title('Gr\''afica 1','Interpreter','Latex')
xticks(ticks);
yticks(ticks2);
legend({'$p_n(x)$','$f(x)$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',16,'FontWeight','Bold')


%parte c)%
ee=zeros(19,1);
for n=2:20
[c,nodos]=interpCheb(n,f);
c=flipud(c);
xx=linspace(-1,1,1e3);
pn=zeros(length(xx),1);
for i=1:length(xx)
    pn(i)=evalCheb(c,xx(i));
end
yy=zeros(length(xx),1);
for i=1:length(xx)
    yy(i)=f(xx(i));
end
ee(n-1)=max(abs(yy-pn));
end
figure
plot(2:20,ee,'or','Linewidth',2)
grid on
ticks= 0:2:21;
ticks2=0:0.1:1;
yticks(ticks2);
xticks(ticks);
title('Gr\''afica 2','Interpreter','Latex')
xlabel('$n$','Interpreter','Latex')
ylabel('$||f(\texttt{xx})-p_n(\texttt{xx})||_{\ell^\infty}$','Interpreter', 'Latex')
legend({'$||f(\texttt{xx})-p_n(\texttt{xx})||_{\ell^\infty}$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',16,'FontWeight','Bold')


%parte d)
n=10;
I=2/5*atan(5);
[c,~]=interpCheb(n,f)
ee=zeros(19,1);
I10=intCheb(c); %Esta funci�n recibe c de forma ascendiente
for n=2:20
    [c,~]=interpCheb(n,f);
    In=intCheb(c);
    ee(n-1)=abs(I-In);
end
figure
semilogy(2:20,ee,'ob','Linewidth',2)
grid on
ticks= 0:2:21;
xticks(ticks);
title('Gr\''afica 3','Interpreter','Latex')
xlabel('$n$','Interpreter','Latex')
ylabel('$error$','Interpreter', 'Latex')
legend({'$|I_n-I|$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
