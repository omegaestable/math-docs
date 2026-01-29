%Script del profe (parte a)$
n_max = 20;
e = zeros(n_max,1);
for n = 1:n_max
e(n) = norm(abs((n:-1:1)'-roots(poly(1:n))),'inf');
end
semilogy(1:n_max, e, '.-'), grid on
xlabel('$n$','Interpreter','Latex')
ylabel('$\|{v}-{w}\|_\infty$','Interpreter', 'Latex')
title('Ejercicio 1','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')


%Script de la parte b).%
v=1:20;
v=v';
n=20;
w=roots(poly(1:n));
z=w;
for i=1:20
    z(i)=w(20-i+1); %hay que reordenar el vector por que w est� al rev�s
end
c=zeros(20,1); %aqui vamos a guardar las aproximaciones de Newton
f= @(x) polyval (poly(1:n),x);
for i=1:20
    c(i)=Newton(f,z(i),1e-6);
end
error1 = abs(v-z);
error2= abs(v-c);
figure
semilogy(v,error1,'g','LineWidth',2),grid on
hold on
semilogy(v,error2,'r','LineWidth',2)
xlabel('$n$','Interpreter','Latex')
ylabel('$Error$','Interpreter', 'Latex')
legend({'$|v_n-w_n|$','$|v_n-c_n|$'},'Location','southeast','Interpreter','Latex')
title('Gr\''afica 3','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
