%Ejercicio 1b%
A=Unos(60);
[L,U]=lu(A);
ro_A=max(max(U))/(max(max(A)));
norma=norm(A-L*U,2);
%Ejercicio 1c%
error1=zeros(51,1);
error2=zeros(51,1);
 for m=10:60
     A=Unos(m);
     [L,U]=lu(A);
     xExact=rand(m,1);
     b=A*xExact;
     %LU%
     y=L\b;
     xApr=U\y;
     error1(m-9)=norm(xApr-xExact,2);
     %QR%
     [Q,R]=qr(A);
     y=Q\b;
     xApr=R\y;
     error2(m-9)=norm(xApr-xExact,2);
 end
 figure
semilogy(10:60,error1,'g',10:60,error2,'r','Linewidth',2)
grid on
ticky= 10.^(-(18:-2:0));
yticks(ticky);
xlabel('$m$','Interpreter','Latex')
ylabel('$||\texttt{xExact-xApr}||$','Interpreter', 'Latex')
title('Gr\''afica 1','Interpreter','Latex')
legend({'LU','QR'},'Location','northwest','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

