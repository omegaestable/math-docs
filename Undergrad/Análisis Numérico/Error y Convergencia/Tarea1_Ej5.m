%parte b%
t=[0 0.2 0.4 0.6 0.8];
T=[37 36.72 36.41 36.12 35.90];
Ta= 21;
T0=37;
%Como vamos a calcular puntos criticos de f, usamos su derivada de una vez$
df = @(k,t,T) -2*(Ta+(T0-Ta)*exp(-k*t) - T)*(T0-Ta)*t*exp(-k*t); %Se inicializa sin evaluar
F =@(k) df(k,t(1),T(1))+  df(k,t(2),T(2))+  df(k,t(3),T(3)) +  df(k,t(4),T(4)) +  df(k,t(5),T(5));
F(0);
F(1);
%F tiene un cero entre 0 y 1
k=Secante(F,0,1,1e-8);
k=k(end);%Solo nos interesa el ultimo valor
concav= deriv(F,k,1e-5); %Este valor es positivo, entonces k es un minimo.

%parte c%
%Solo tenemos que resolver la ecuacion
%temp = 34
Ta=31;
temp = @(t) Ta+(T0-Ta)*exp(-k*t)-34;
%es facil ver que entre 7 y 8 hay una raiz
t=Secante(temp,7,8,1e-8);
disp(t)
t=t(end);
%fin
