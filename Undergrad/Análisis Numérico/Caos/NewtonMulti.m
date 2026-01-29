function [s] = NewtonMulti(f,x0,tol)
%Calcula el método de Newton para funciones multivariables. f(x0) debe ser
%un vector columna
while norm(f(x0))>tol
    x0=x0-(Jacob(f,x0))\f(x0);
end
s=x0;
end

