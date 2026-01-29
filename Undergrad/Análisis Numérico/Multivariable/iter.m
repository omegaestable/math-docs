function [suc] = iter(f,x0,tol)
%Recibe una funcion f, con valor inicial x0, y una tolerancia, devuelve la
%sucesion del problema 7 del examen
suc=x0;
xk=x0;
while abs(f(xk))>tol
    xk= xk - f(xk)/(deriv(f,xk,1e-6))*(1-(f(xk)*deriv2(f,xk,1e-6))/(2*(deriv(f,xk,1e-6))^2))^-1;
    suc=[suc,xk];
end
end

