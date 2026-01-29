function [t,y] = RK4imp(f,a,b,h,y0)
% Resolver dy f(t,y) con y(t0)=t0
%NO funciona para sistemas de ecuaciones
% en el intervalo [a,b] por el metodo de Runge-Kutta
% h: step size
% f: f(t,y)
t = a:h:b;
n = numel(t);
y = zeros(length(y0),n);
%Guardamos A
A=[1/4 1/4-sqrt(3)/6
    1/4+sqrt(3)/6    1/4];
%Guardamos C
c=[1/2-sqrt(3)/6
    1/2+sqrt(3)/6];
y(1) = y0;
for i = 2:n
    %Establecemos la ecuacion implicita con solucion k1, k2
    K= @(k) [k(1) - f(t(i-1) + c(1)*h,y(i-1)+A(1,1)*h*k(1)+A(1,2)*h*k(2))
        k(2) - f(t(i-1)+c(2)*h,y(i-1)+A(2,1)*h*k(1)+A(2,2)*h*k(2))];
    K0=[y(i-1),y(i-1)];
    %Usamos Newton multivariable
    K=NewtonMulti(K,K0,1e-5);
    k1=K(1);
    k2=K(2);
    %Aplicamos la iteracion del m�todo
    y(i)=y(i-1)+(h/2)*(k1+k2);
end
end