function [I] = cuad1(f)
%Recibe una función f de dos variables, devuelve la cuadratura de orden 1
%para la integral doble de fdydx sobre el triángulo estándar.
I=(1/2)*f(1/3,1/3);
end
