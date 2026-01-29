
function [t,y] = rke4(f,a,b,h,y0)
% Resolver y' = f(t,y) con y(t0)=t0
% en el intervalo [a,b] por el metodo de Runge-Kutta
% h: step size
% f: f(t,y)
t = a:h:b;
n = numel(t);
y = zeros(length(y0),n);
y(:,1) = y0;
for i = 2:n
    k1=f(t(i-1),y(:,i-1));
    k2=f(t(i-1)+h/2,y(:,i-1)+h.*k1/2);
    k3=f(t(i-1)+h/2,y(:,i-1)+h.*k2/2);
    k4=f(t(i-1)+h,  y(:,i-1)+h.*k3);
    y(:,i)=y(:,i-1)+h.*(k1+2*k2+2*k3+k4)/6;
end
end