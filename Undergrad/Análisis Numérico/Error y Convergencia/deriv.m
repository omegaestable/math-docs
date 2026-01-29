function [df] = deriv(f,x0,h)
%Encuentra el valor aproximado de la derivada de una funcion f en un valor
%x0
df=(f(x0 + h) - f(x0-h))./(2*h);
end