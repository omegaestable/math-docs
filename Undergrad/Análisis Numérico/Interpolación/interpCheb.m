function [coef,nodos] = interpCheb(n,f)
%Recibe el grado del polinomio de interpolación, y la función a interpolar
%Calcula los nodos de Chebyshev, y los coeficientes {c_k}
nodos=zeros(n+1,1);
for i=1:n+1
    nodos(i)=cos((i-1)*pi/n);
end
values=zeros(n+1,1);
for i=1:n+1
    values(i)=f(nodos(i));
end
coef=val2coef(values);
end

