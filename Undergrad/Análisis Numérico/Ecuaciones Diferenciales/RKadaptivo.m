function [T,y,H] = RKadaptivo(f,y0,t0,Tmax,h0,hmax,tol)
%Modificación del método de Runge Kutta4, selecciona el tamaño de paso
%conforme se detecta estabilidad
t=t0;
T=[t0];
y = [y0]';
h=h0;
H=[h0];
contador=1;
while T(contador)<Tmax
    H=[H,h];
    delta=tol+1;
    while delta>tol
        [t1,y1]=rke4(f,T(contador),T(contador)+h,h,y(:,contador));
        y1=y1(:,2);
        [~,y2]=rke4(f,T(contador),T(contador)+h,h/2,y(:,contador));
        y2=y2(:,3);
        delta=y2-y1;
        if norm(delta) <= tol  %Aquí se selecciona el tamaño de paso nuevo 
            h=0.9*h*(tol/norm(delta))^(0.20);
        else
            h=0.9*h*(tol/norm(delta))^(0.25);        
        end
        h=min(h,hmax);
        
    end
    y=[y,y2+delta/15];   
    T=[T,t1(2)];
    contador=contador+1;
end

