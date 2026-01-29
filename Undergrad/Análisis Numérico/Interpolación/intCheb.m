function [I] = intCheb(c)
%Recibe un vector c. Devuelve la integral entre -1 y 1 del polinomio cuyo vector de
%coordenadas
%en la base de Chebyshev es c.}
%Esta vez el vector se recibe en forma ascendiente [c0,c1,...]
I=0;
for i=1:length(c)
    if mod(i,2)==1 %así pues MATLAB comienza a indexar en 1
    I=I+(2*c(i))/(1-(i-1)^2); %Se tiene que correr el i en el denominador para que comience en 0
    end
end
end

