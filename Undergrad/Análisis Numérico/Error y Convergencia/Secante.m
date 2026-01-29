function [c] = Secante(f,c0,c1,tol)
%Aplica el metodo de la Secante para aproximar la solucion de f en el
%intervalo [c0,c1], con una tolerancia predeterminada %se inicializa el vector c
c=[]; %se inicializa el vector c
while abs(c0-c1)>tol
    ck= (c0*f(c1) - c1*f(c0))/(f(c1)-f(c0));
    c=[c,ck];
    if f(ck)==0
        c0=0;
        c1=0;
    else
        c0=c1;
        c1=ck;
    end
    
end