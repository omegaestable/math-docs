function [dfidxj] = DerivParcial(f,i,j,x0)
%Calcula la derivada parcial de fi con respecto a xj, en el punto x0.
%Solo para funciones de Rn en Rn
%x0 debe ser un vector columna
%f tambi�n
[n,~]=size(x0);
e=eye(n);
h=1e-6;
e=e(j,:)';
fi=f(x0);
fi_h=f(x0+h*e);
dfidxj= 1/h * (fi_h(i)-fi(i));
end

