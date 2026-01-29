%Parte b)%
%Inicializamos variables y funciones
m=15;
f=@(x) cos(2*pi*x);
x=rand(1,16);
x(1)=0;
x(16)=1;
x=sort(x);
y=f(x);
A=zeros(16);
b=zeros(16,1);
c=zeros(16,1);

%Rellenamos matrices y vector respuesta
for i=1:m+1
    for j=1:m+1
        if i<m+1 && (i==j || j==i+1)
            A(i,j)=1;
            
        else if i==m+1 && ( j==m+1 || j==2)
                A(i,j)=(-1)^j;
            end
        end
    end
    for i=1:m
        b(i)=(2/(x(i+1)-x(i)))*(y(i+1)-y(i));
    end
   b(m+1)=(2/(x(2)-x(1)))*(y(2)-y(1));
end

%Resolvemos el sistema
sigma=vpa(A\b);
for i=2:m
    c(i)= y(i) - 1/2 * (x(i+1)-x(i))*sigma(i);
end
c(m+1)=y(m+1)-(1/2)*(x(2)-x(1))*sigma(m+1);

%Construimos s
s1= @(t) (t-x(1))^2 /(2*(x(2)-x(1)))*sigma(2) - (x(2)-t)^2 / (2*(x(2)-x(1)))*sigma(1) + c(2);
s2= @(t) (t-x(2))^2 /(2*(x(3)-x(2)))*sigma(3) - (x(3)-t)^2 / (2*(x(3)-x(2)))*sigma(2) + c(3);
s3= @(t) (t-x(3))^2 /(2*(x(4)-x(3)))*sigma(4) - (x(4)-t)^2 / (2*(x(4)-x(3)))*sigma(3) + c(4);
s4= @(t) (t-x(4))^2 /(2*(x(5)-x(4)))*sigma(5) - (x(5)-t)^2 / (2*(x(5)-x(4)))*sigma(4) + c(5);
s5= @(t) (t-x(5))^2 /(2*(x(6)-x(5)))*sigma(6) - (x(6)-t)^2 / (2*(x(6)-x(5)))*sigma(5) + c(6);
s6= @(t) (t-x(6))^2 /(2*(x(7)-x(6)))*sigma(7) - (x(7)-t)^2 / (2*(x(7)-x(6)))*sigma(6) + c(7);
s7= @(t) (t-x(7))^2 /(2*(x(8)-x(7)))*sigma(8) - (x(8)-t)^2 / (2*(x(8)-x(7)))*sigma(7) + c(8);
s8= @(t) (t-x(8))^2 /(2*(x(9)-x(8)))*sigma(9) - (x(9)-t)^2 / (2*(x(9)-x(8)))*sigma(8) + c(9);
s9= @(t) (t-x(9))^2 /(2*(x(10)-x(9)))*sigma(10) - (x(10)-t)^2 / (2*(x(10)-x(9)))*sigma(9) + c(10);
s10= @(t) (t-x(10))^2 /(2*(x(11)-x(10)))*sigma(11) - (x(11)-t)^2 / (2*(x(11)-x(10)))*sigma(10) + c(11);
s11= @(t) (t-x(11))^2 /(2*(x(12)-x(11)))*sigma(12) - (x(12)-t)^2 / (2*(x(12)-x(11)))*sigma(11) + c(12);
s12= @(t) (t-x(12))^2 /(2*(x(13)-x(12)))*sigma(13) - (x(13)-t)^2 / (2*(x(13)-x(12)))*sigma(12) + c(13);
s13= @(t) (t-x(13))^2 /(2*(x(14)-x(13)))*sigma(14) - (x(14)-t)^2 / (2*(x(14)-x(13)))*sigma(13) + c(14);
s14= @(t) (t-x(14))^2 /(2*(x(16)-x(14)))*sigma(15) - (x(15)-t)^2 / (2*(x(15)-x(14)))*sigma(14) + c(15);
s15= @(t) (t-x(15))^2 /(2*(x(16)-x(15)))*sigma(16) - (x(16)-t)^2 / (2*(x(16)-x(15)))*sigma(15) + c(16);
  
%Evaluamos y graficamos
s=zeros(1,16);
s(1)=s1(x(1));
s(2)=s2(x(2));
s(3)=s3(x(3));
s(4)=s4(x(4));
s(5)=s5(x(5));
s(6)=s6(x(6));
s(7)=s7(x(7));
s(8)=s8(x(8));
s(9)=s9(x(9));
s(10)=s10(x(10));
s(11)=s11(x(11));
s(12)=s12(x(12));
s(13)=s13(x(13));
s(14)=s14(x(14));
s(15)=s15(x(15));
s(16)=s15(x(16));
figure
plot(x,s,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','y')
hold on
plot(x,y,'o','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','c')
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('$y$','Interpreter', 'Latex')
title('Gr\''afica 10','Interpreter','Latex')
legend({'$s_2(x)$','$\cos(2\pi x)$'},'Location','north','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

error = abs(s-y);
figure
plot(x,error,'-bo','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','g')
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('$error$','Interpreter', 'Latex')
title('Gr\''afica 11','Interpreter','Latex')
legend({'$|f(x)-s_2(x)|$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Parte c)% Se vuelve a hacer todo
%Inicializamos variables y funciones
m=15;
f=@(x) cos(2*pi*x);
x=linspace(0,1,16);  %Esta es la �nica diferencia
x(1)=0;
x(16)=1;
x=sort(x);
y=f(x);
A=zeros(16);
b=zeros(16,1);
c=zeros(16,1);

%Rellenamos matrices y vector respuesta
for i=1:m+1
    for j=1:m+1
        if i<m+1 && (i==j || j==i+1)
            A(i,j)=1;
            
        else if i==m+1 && ( j==m+1 || j==2)
                A(i,j)=(-1)^j;
            end
        end
    end
    for i=1:m
        b(i)=(2/(x(i+1)-x(i)))*(y(i+1)-y(i));
    end
   b(m+1)=(2/(x(2)-x(1)))*(y(2)-y(1));
end

%Resolvemos el sistema
sigma=vpa(A\b);
for i=2:m
    c(i)= y(i) - 1/2 * (x(i+1)-x(i))*sigma(i);
end
c(m+1)=y(m+1)-(1/2)*(x(2)-x(1))*sigma(m+1);

%Construimos s
s1= @(t) (t-x(1))^2 /(2*(x(2)-x(1)))*sigma(2) - (x(2)-t)^2 / (2*(x(2)-x(1)))*sigma(1) + c(2);
s2= @(t) (t-x(2))^2 /(2*(x(3)-x(2)))*sigma(3) - (x(3)-t)^2 / (2*(x(3)-x(2)))*sigma(2) + c(3);
s3= @(t) (t-x(3))^2 /(2*(x(4)-x(3)))*sigma(4) - (x(4)-t)^2 / (2*(x(4)-x(3)))*sigma(3) + c(4);
s4= @(t) (t-x(4))^2 /(2*(x(5)-x(4)))*sigma(5) - (x(5)-t)^2 / (2*(x(5)-x(4)))*sigma(4) + c(5);
s5= @(t) (t-x(5))^2 /(2*(x(6)-x(5)))*sigma(6) - (x(6)-t)^2 / (2*(x(6)-x(5)))*sigma(5) + c(6);
s6= @(t) (t-x(6))^2 /(2*(x(7)-x(6)))*sigma(7) - (x(7)-t)^2 / (2*(x(7)-x(6)))*sigma(6) + c(7);
s7= @(t) (t-x(7))^2 /(2*(x(8)-x(7)))*sigma(8) - (x(8)-t)^2 / (2*(x(8)-x(7)))*sigma(7) + c(8);
s8= @(t) (t-x(8))^2 /(2*(x(9)-x(8)))*sigma(9) - (x(9)-t)^2 / (2*(x(9)-x(8)))*sigma(8) + c(9);
s9= @(t) (t-x(9))^2 /(2*(x(10)-x(9)))*sigma(10) - (x(10)-t)^2 / (2*(x(10)-x(9)))*sigma(9) + c(10);
s10= @(t) (t-x(10))^2 /(2*(x(11)-x(10)))*sigma(11) - (x(11)-t)^2 / (2*(x(11)-x(10)))*sigma(10) + c(11);
s11= @(t) (t-x(11))^2 /(2*(x(12)-x(11)))*sigma(12) - (x(12)-t)^2 / (2*(x(12)-x(11)))*sigma(11) + c(12);
s12= @(t) (t-x(12))^2 /(2*(x(13)-x(12)))*sigma(13) - (x(13)-t)^2 / (2*(x(13)-x(12)))*sigma(12) + c(13);
s13= @(t) (t-x(13))^2 /(2*(x(14)-x(13)))*sigma(14) - (x(14)-t)^2 / (2*(x(14)-x(13)))*sigma(13) + c(14);
s14= @(t) (t-x(14))^2 /(2*(x(16)-x(14)))*sigma(15) - (x(15)-t)^2 / (2*(x(15)-x(14)))*sigma(14) + c(15);
s15= @(t) (t-x(15))^2 /(2*(x(16)-x(15)))*sigma(16) - (x(16)-t)^2 / (2*(x(16)-x(15)))*sigma(15) + c(16);
  
%Evaluamos y graficamos
s=zeros(1,16);
s(1)=s1(x(1));
s(2)=s2(x(2));
s(3)=s3(x(3));
s(4)=s4(x(4));
s(5)=s5(x(5));
s(6)=s6(x(6));
s(7)=s7(x(7));
s(8)=s8(x(8));
s(9)=s9(x(9));
s(10)=s10(x(10));
s(11)=s11(x(11));
s(12)=s12(x(12));
s(13)=s13(x(13));
s(14)=s14(x(14));
s(15)=s15(x(15));
s(16)=s15(x(16));
figure
plot(x,s,'d','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','y')
hold on
plot(x,y,'o','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','c')
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('$y$','Interpreter', 'Latex')
title('Gr\''afica 12','Interpreter','Latex')
legend({'$s_2(x)$','$\cos(2\pi x)$'},'Location','north','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

error = abs(s-y);
figure
plot(x,error,'-bo','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','g')
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('$error$','Interpreter', 'Latex')
title('Gr\''afica 13','Interpreter','Latex')
legend({'$|f(x)-s_2(x)|$'},'Location','northeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

%Parte d)%
%Escribimos las derivadas
tt=linspace(0,1,200);
ds1=@(t) (x(2)-t)*sigma(1)/(x(2)-x(1)) + (t-x(1))*sigma(2)/(x(2)-x(1));
ds2=@(t)(x(3)-t)*sigma(2)/(x(3)-x(2)) + (t-x(2))*sigma(3)/(x(3)-x(2));
ds3=@(t)(x(4)-t)*sigma(3)/(x(4)-x(3)) + (t-x(3))*sigma(4)/(x(4)-x(3));
ds4=@(t)(x(5)-t)*sigma(4)/(x(5)-x(4)) + (t-x(4))*sigma(5)/(x(5)-x(4));
ds5=@(t)(x(6)-t)*sigma(5)/(x(6)-x(5)) + (t-x(5))*sigma(6)/(x(6)-x(5));
ds6=@(t)(x(7)-t)*sigma(6)/(x(7)-x(6)) + (t-x(6))*sigma(7)/(x(7)-x(6));
ds7=@(t)(x(8)-t)*sigma(7)/(x(8)-x(7)) + (t-x(7))*sigma(8)/(x(8)-x(7));
ds8=@(t)(x(9)-t)*sigma(8)/(x(9)-x(8)) + (t-x(8))*sigma(9)/(x(9)-x(8));
ds9=@(t)(x(10)-t)*sigma(9)/(x(10)-x(9)) + (t-x(9))*sigma(10)/(x(10)-x(9));
ds10=@(t)(x(11)-t)*sigma(10)/(x(11)-x(10)) + (t-x(10))*sigma(11)/(x(11)-x(10));
ds11=@(t)(x(12)-t)*sigma(11)/(x(12)-x(11)) + (t-x(11))*sigma(12)/(x(12)-x(11));
ds12=@(t)(x(13)-t)*sigma(12)/(x(13)-x(12)) + (t-x(12))*sigma(13)/(x(13)-x(12));
ds13=@(t)(x(14)-t)*sigma(13)/(x(14)-x(13)) + (t-x(13))*sigma(14)/(x(14)-x(13));
ds14=@(t)(x(15)-t)*sigma(14)/(x(15)-x(14)) + (t-x(14))*sigma(15)/(x(15)-x(14));
ds15=@(t)(x(16)-t)*sigma(15)/(x(16)-x(15)) + (t-x(15))*sigma(16)/(x(16)-x(15));
%Evaluamos, revisando donde est� t(i) (en que intervalo de la particion)
DS=zeros(1,200);
for i=1:200
    if x(1)<= tt(i) && tt(i) < x(2)
        DS(i)=ds1(tt(i));
    end
     if x(2)<= tt(i) && tt(i) < x(3)
        DS(i)=ds2(tt(i));
     end
     if x(3)<= tt(i) && tt(i) < x(4)
        DS(i)=ds3(tt(i));
     end
     if x(4)<= tt(i) && tt(i) < x(5)
        DS(i)=ds4(tt(i));
     end
     if x(5)<= tt(i) && tt(i) < x(6)
        DS(i)=ds5(tt(i));
     end
     if x(6)<= tt(i) && tt(i) < x(7)
        DS(i)=ds6(tt(i));
     end
     if x(7)<= tt(i) && tt(i) < x(8)
        DS(i)=ds7(tt(i));
     end
     if x(8)<= tt(i) && tt(i) < x(9)
        DS(i)=ds8(tt(i));
     end
     if x(9)<= tt(i) && tt(i) < x(10)
        DS(i)=ds9(tt(i));
     end
     if x(10)<= tt(i) && tt(i) < x(11)
        DS(i)=ds10(tt(i));
     end
     if x(11)<= tt(i) && tt(i) < x(12)
        DS(i)=ds11(tt(i));
     end
     if x(12)<= tt(i) && tt(i) < x(13)
        DS(i)=ds12(tt(i));
     end
     if x(13)<= tt(i) && tt(i) < x(14)
        DS(i)=ds13(tt(i));
     end
     if x(14)<= tt(i) && tt(i) < x(15)
        DS(i)=ds14(tt(i));
     end
     if x(15)<= tt(i) && tt(i) <= x(16)
        DS(i)=ds15(tt(i));
    end
end
%Derivamos
df= @(t) -2*pi*sin(2*pi*t);
DF=df(tt);
%Graficamos
figure
plot(tt,DS,'r','LineWidth',2)
hold on
plot(tt,DF,'g','LineWidth',2)
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('$y''$','Interpreter', 'Latex')
title('Gr\''afica 14','Interpreter','Latex')
legend({'$s_2''(x)$','$f''(x)$'},'Location','southeast','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')

figure
plot(tt,abs(DS-DF),'m','LineWidth',2)
grid on
xlabel('$x$','Interpreter','Latex')
ylabel('$error$','Interpreter', 'Latex')
title('Gr\''afica 15','Interpreter','Latex')
legend({'|$f''(x)-s''_2(x)|$'},'Location','north','Interpreter','Latex')
set(gca,'FontName','Arial','FontSize',22,'FontWeight','Bold')
