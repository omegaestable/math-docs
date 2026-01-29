%parte c)%
f = @(x) 1/x - sin(x) +1;
a0=-1.3;
b0=-0.5;
tol=1e-8;
c= ReglaFalsa(f,a0,b0,tol);
alfa=c(end); %Se toma el ultimo valor para calcular el orden de convergencia
L= abs((alfa-c(length(c)-1))/(alfa-c(length(c)-2)));


%parte d)%
c1=c;%con regla falsa
c2=Biseccion(f,a0,b0,tol); %con biseccion
c3 = Secante(f,a0,b0,1e-11); %con secante. Se usa menor tolerancia para tener mas iteraciones
s1=c1(end); %solucion final de regla falsa
s2=c2(end); %sol final de biseccion
s3=c3(end); %sol final de secante
k1=1:length(c1)-1;  %Se acomoda para poder graficar
k2=1:length(c2)-1;
k3=1:length(c3)-1;
e1=zeros(length(c1)-1,1);  %Se inicializa el vector de errores
e2=zeros(length(c2)-1,1);
e3=zeros(length(c3)-1,1);
for i=1:(length(c1)-1)
    e1(i,1)=abs(s1-c1(i));
end
for i=1:(length(c2)-1)
    e2(i,1)=abs(s2-c2(i));
end
for i=1:(length(c3)-1)
    e3(i,1)=abs(s3-c3(i));
end
figure
semilogy(k1,e1,'r','Linewidth',2) %regla falsa
hold on

semilogy(k2,e2,'g','Linewidth',2) %biseccion
semilogy(k3,e3,'c','Linewidth',2) %secante
grid on
limits=[0,26,1e-16,1];
ticks= 0:2:26;
xlabel('$k$','Interpreter','Latex')
ylabel('$Error$','Interpreter', 'Latex')
title('Gr\''afica 6','Interpreter','Latex')
axis(limits);
xticks(ticks);
legend({'$|s_1-c_1(k)|$','$|s_2-c_2(k)|$','$|s_3-c_3(k)|$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
