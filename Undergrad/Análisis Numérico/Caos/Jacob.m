function [J] =Jacob(f,x0)
%Calcula numéricamente la jacobiana de f en el punto x0
%x0 debe ser un vector columna
[n,~]=size(x0);
for i=1:n
    for j=1:n
        J(i,j)=DerivParcial(f,i,j,x0);
    end
end
end

