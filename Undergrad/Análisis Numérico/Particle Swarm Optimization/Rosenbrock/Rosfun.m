%Genera una función de Rosenbrock con parámetros a,b.
function out = Rosfun(x, rosbr)
    a = rosbr.a; b = rosbr.b;
    out = (a-x(1)).^2 + b*(x(2)-x(1).^2).^2;
end

