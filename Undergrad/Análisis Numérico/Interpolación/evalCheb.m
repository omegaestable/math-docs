function [y0] = evalCheb(c,x0)
%Eval�a un polinomio, usando la base de polinomios de Chebyshev, y una
%f�rmula recursiva. El polinomio se expresa en base de Chebyshev, mediante
%el vector c
%NOTA: El vector se introduce en forma decreciente, es decir c(1) es el
%coeficiente del mayor 
n=length(c);
b2=0;
b1=0;
b0=0;
for i=n:-1:2 %Esto pues el tamano de c realmente describe una comb. lineal de tamano n-1
    b0=c(n-i+1)+2*x0*b1-b2; %Hay que cambiar el orden con que se recorre c pues esta al reves
    b2=b1;
    b1=b0;
end
y0=c(n)+x0*b1-b2;
end

