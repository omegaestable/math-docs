function [I] = cuad2(f)
%Recibe una función f de dos variables, devuelve la cuadratura de orden 2
%para la integral doble de fdydx sobre el triángulo estándar.
I=(1/6)*(f(1/6,1/6) + f(2/3,1/6) + f(1/6,2/3));
end

