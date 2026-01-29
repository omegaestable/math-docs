function [df] = deriv2(f,x0,h)
%Encuentra el valor aproximado de la segunda derivada de una funcion f en un valor
%x0
df=(deriv(f,x0+h,1e-5) - deriv(f,x0-h,1e-5))./(2*h);
end