%Ejercicio 1b)%
n=40;
x=-1:(2/n):1;
A=zeros(n+1);
for i=0:n
    for j=0:n
        A(i+1,j+1)=x(i+1)^j;
    end
end
condicion=cond(A);
rango=rank(A);
determinante=det(A);

%Ejercicio 1c)%
xx=linspace(-1,1,1000);
f= @(x) 1./(1.+25*x.^2);
b=f(x);
b=b'; %Hay que transponer
a = (A \b);
a=flip(a);
fyy=f(xx);
pyy=polyval(a,xx);
error=max(abs(fyy-pyy));

%Ejercicio 1d%
[U,S,V]=svd(A);
a=V*(S^-1)*U'*b;
a=flip(a);
pyy2=polyval(a,xx);
error2=max(abs(fyy-pyy2));
d=diag(S);
m=1:length(d);
rangoS=rank(S);
figure
semilogy(m,d','o','MarkerEdgeColor','b',...
    'MarkerFaceColor','b')
grid on
ytick=10.^(-20:2:0);
xtick=0:41;
yticks(ytick)
xlabel('$m$','Interpreter','Latex')
ylabel('$\sigma_m$','Interpreter', 'Latex')
title('Gr\''afica 1','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Ejercicio 1e)%
tol = 2.^(-linspace(2,17));
sigma1=S(1,1);
Error=zeros(length(tol),1);
for k=1:length(tol)
    Sk=S;
    for i=1:n+1
        for j=1:n+1
            if S(i,j)<sigma1*tol(k)
                Sk(i,j)=0;
            else
                Sk(i,j)=Sk(i,j)^-1;
            end
        end
        
    end
    x_svd=(V*Sk*U')*b;
    x_svd=flip(x_svd);
    pyy3=polyval(x_svd,xx);
    Error(k)=max(abs(f(xx)-pyy3));
end
figure
loglog(tol,Error,'o','MarkerEdgeColor','black',...
    'MarkerFaceColor','g')
grid on
xlabel('$Tolerancia$','Interpreter','Latex')
ylabel('$Error$','Interpreter', 'Latex')
title('Gr\''afica 2','Interpreter','Latex')
legend({'$||f(\texttt{xx})-p_n(\texttt{xx})||_{\ell^\infty}$'},'Location','north','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')

%Ejercicio 1f)%
[error_minimo,posicion]=min(Error);
tol_min=tol(posicion);
%Hay que volver a calcular Sk porque la sobreescribimos
Sk=S;
for i=1:n+1
    for j=1:n+1
        if S(i,j)<sigma1*tol_min
            Sk(i,j)=0;
        else
            Sk(i,j)=Sk(i,j)^-1;
        end
    end
    
end
x_svd_min=(V*Sk*U')*b;
x_svd_min=flip(x_svd_min);
px=polyval(x_svd_min,xx);

figure
plot(xx,f(xx),'r',x,f(x),'-rd',xx,px,'b','LineWidth',3,'MarkerSize',10,...
    'MarkerEdgeColor','black','MarkerFaceColor','black')
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('$y$','Interpreter', 'Latex')
title('Gr\''afica 3','Interpreter','Latex')
legend({'$f(\texttt{xx})$',' $x_j$','$p(\texttt{xx})$'},'Location','south','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')

%Ejercicio 1g)%
tol_f=1e-5;
%Hay que volver a calcular Sk porque la sobreescribimos
Sk=S;
for i=1:n+1
    for j=1:n+1
        if S(i,j)<sigma1*tol_f
            Sk(i,j)=0;
        else
            Sk(i,j)=Sk(i,j)^-1;
        end
    end
    
end
x_svd_min=(V*Sk*U')*b;
x_svd_min=flip(x_svd_min);
px=polyval(x_svd_min,xx);

figure
plot(xx,f(xx),'r',x,f(x),'-rd',xx,px,'b','LineWidth',3,'MarkerSize',10,...
    'MarkerEdgeColor','black','MarkerFaceColor','black')
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('$y$','Interpreter', 'Latex')
title('Gr\''afica 4','Interpreter','Latex')
legend({'$f(\texttt{xx})$',' $x_j$','$p(\texttt{xx})$'},'Location','south','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')

