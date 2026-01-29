function [c] = ReglaFalsa(f,a0,b0,tol)
%Aplica el metodo de la ReglaFalsa para aproximar la solucion de f en el
%intervalo [a0,b0], con una tolerancia predeterminada
c=[]; %se inicializa el vector c
if f(a0)*f(b0)>=0
    fprintf('El metodo no sera valido!')
elseif f(a0)*f(b0)<0
    while abs(a0-b0)>tol
        ck= (a0*f(b0) - b0*f(a0))/(f(b0)-f(a0));
        c=[c,ck];
        if f(ck)==0
            a0=0;
            b0=0;
        elseif f(a0)*f(ck)<0
            b0=ck;
        elseif f(ck)*f(b0)<0
            a0=ck;
        end
    end

end

