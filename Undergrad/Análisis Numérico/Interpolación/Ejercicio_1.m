%Ejercicio 1, parte d) El tiempo de ejecucion puede variar dependiendo de
%la computadora
a=rand(10^8,1);
x0=0.1;
%Note que el grado del polinomio ser 10^8 - 1%
%Algoritmo 1%
tic
px0=0;
for i=1:length(a)
    px0=a(i)*x0^(length(a)-i)+px0;
end
px0
toc
%Algoritmo 2%
b=a(1);
tic
for i=2:length(a)
    b=a(i)+b*x0;
end
toc
b
%Algoritmo 3%
tic
v=polyval(a,x0)
toc

%Parte e)
a=ones(10^8,1);
%Algoritmo 1%
px0=0;
for i=1:length(a)
    px0=a(i)*x0^(length(a)-i)+px0;
end
p1=px0
%Algoritmo 2%
b=a(1);
for i=2:length(a)
    b=a(i)+b*x0;
end
p2=b
