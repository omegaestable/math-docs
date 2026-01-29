function [ c,k ] = NewtonMulti( f,c0,m,tol )
       %Metodo de newton para aproximar soluciones a funciones
       %diferenciables con raices multiples. Recibe una funcion f, 
       %un valor inicial c0, el orden esperado del cero, y una
       %tolerancia tol.
        ck=c0-f(c0)/deriv(f,c0,1e-5); %pedimos una precision de 1e-5,
                                       %pues podemos tener una convergencia
                                     %demasiado rapida, que arroja 0/0
        c=c0;
        k=0;
        cont=0;
        while abs(ck-c0)>tol
            c0=ck;
            ck=c0-m*f(c0)/deriv(f,c0,1e-5);
            c=[c,ck];
            cont=cont+1;
            k=[k,cont];
        end
        
    end
