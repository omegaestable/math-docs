function [ suc ] = Newton( f,c0,tol )
       %Método de newton para aproximar soluciones a funciones
       %diferenciables. Recibe una función f, un valor inicial c0, y una
       %tolerancia tol. Devuelve una sucesión
       ck=c0;
       suc=c0;
        while abs(f(ck))>tol
            ck=ck-f(ck)/deriv(f,ck,1e-6);
            suc=[suc,ck];
        end
        
    end
