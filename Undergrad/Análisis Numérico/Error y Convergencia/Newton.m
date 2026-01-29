function [ ck ] = Newton( f,c0,tol )
       %Metodo de newton para aproximar soluciones a funciones
       %diferenciables. Recibe una funcion f, un valor inicial c0, y una
       %tolerancia tol.
        ck=c0-f(c0)/deriv(f,c0,1e-8);

        while abs(ck-c0)>tol
            c0=ck;
            ck=c0-f(c0)/deriv(f,c0,1e-8);

        end
        
    end
