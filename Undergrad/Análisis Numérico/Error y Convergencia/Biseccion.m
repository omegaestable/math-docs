function [ c ] = Biseccion( f,a0,b0,epsilon )
%Aplica el metodo de biseccion a la funcion f, en el intervalo [a_0,b_0],
%se detiene cuando b_k-a_k < epsilon.
fa0=f(a0);
fb0=f(b0);
c=[];
if(fa0*fb0 >= 0)
    fprintf('El metodo no sera valido')
elseif abs(fa0)<epsilon
    ck=a_0;
elseif abs(fb0)<epsilon
    ck=b_0;
else
    while b0-a0 >= epsilon
        c0=(a0+b0)/2;
        fc0=f(c0);
        fa0=f(a0);
        fb0=f(b0);
        if fc0==0
            ck=c0;
            c=[c,ck];
            b0=0;
            a0=0;
        elseif fc0*fa0<0
            b0=c0;
        elseif fc0*fb0<0
            a0=c0;

        end
        ck=c0;
        c=[c,ck];
        
    end
    ck=c0;
    
    
end

