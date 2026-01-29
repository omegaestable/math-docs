function [P] = Pendulo(t,theta,L)
O=[0,0];
axis(gca,'equal');
axis([-1.5,1.5,-1.5,1.5]);
grid on
for i=1:length(t)
    P= L*[sin(theta(i,1)), -cos(theta(i,1))];
    O_circ=viscircles(O,0.01); %Circulo en origen
    pend=line([O(1),P(1)],[O(2),P(2)]); %Pendulo
    bola=viscircles(P,0.05); %Bola
    pause(0.001); %Intervalos de tiempo
    if i<length(t)
        delete(pend);
        delete(bola);
        delete(O_circ);
    end
end
end

