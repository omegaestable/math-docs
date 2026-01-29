
%19/11/18
%                   Particle Swarm Optimization
%                       An�lisis Operativo
%                         Isaac Z. Arias


%% Definici�n de Insumos de Simulaci�n

%En este caso, la posici�n consiste en el vector

%       [Montaje, Producci�n, Desmontaje]

%Para cada particual (Orden)
%Se decidi� utilizar como posiciones iniciales las medias empiricas de los
%datos recolesctados.
%Creamos la Posici�n Inicial
PosicionI = [206, 1613, 136;...          %Posici�n 1 Tejas
             111, 1070, 67;...           %Posici�n 2 Cumbrera 
             131, 1217, 89;...           %Posici�n 3 Caja Industrial
             248, 1246, 137;...          %Posici�n 4 Caja Nicaragua
             271, 1148, 206];            %Posici�n 5 Caja Panam�

%Cantidad de Iteraciones necesarias
num_Datos = 10000;

%Matriz de Datos
MD = [];


%% Recolecci�n de Datos

for i = 1:num_Datos
    MD(i, 1:5) = SwarmOpti(PosicionI);
end


%% Resultados

Resultado = [mean(MD(:, 1)), mean(MD(:, 2)), mean(MD(:, 3)), mean(MD(:, 4)), mean(MD(:, 5))];
Resultado