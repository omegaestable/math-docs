
%19/11/18
%                   Particle Swarm Optimization
%                       An�lisis Operativo
%                         Isaac Z. Arias



         
%% Definici�n de la Funci�n

function Resultados = SwarmOpti(PosicionI)
%% Definici�n del Problema

F = @(x) x(1)+x(2)+x(3);           %Funci�n Objetivo

dim_Par = 3;                       %Dimensi�n de la Part�cula 

tam_Par = [1 dim_Par];             %Tama�o de la Part�cula

max_Par = 1500;                    %M�ximo de los posibles valores por part�cula 

min_Peso = 0;                      %M�nimo de los posibles pesos por part�cula

%% Parametros del Algoritmo

iter = 100;                       %N�mero m�ximo de Iteraciones

num_Par = 5;                      %Cantidad de Part�culas (�rdenes)

w = 0.99;                            %Coeficiente de Inercia

c1 = 2;                           %Coeficiente de Aceleraci�n Individual

c2 = 3;                           %Coeficiente de Aceleraci�n Global
   

%% Inicializaci�n

molde_Par.Posicion = [];          %Posici�n de la Particula

molde_Par.Velocidad = [];         %Velocidad de la Particula

molde_Par.Peso = [];              %Peso de la Particula

molde_Par.Mejor.Posicion = [];    %Mejor Posici�n de la Particula

molde_Par.Mejor.Peso = [];        %Mejor Peso de la Particula


%Creamos las Part�culas necesarias
Par = repmat(molde_Par, num_Par, 1);  

%Mejor Valor Global
Global.Peso = inf;
Global.Posicion = repmat(max_Par, 1, dim_Par);

%M�nimo Global
min_Global = 1;

%Inicializando las Part�culas
Par(1).Posicion = PosicionI(1,:);          %Posici�n Tejas
Par(2).Posicion = PosicionI(2,:);          %Posici�n Cumbrera 
Par(3).Posicion = PosicionI(3,:);          %Posici�n Caja Industrial
Par(4).Posicion = PosicionI(4,:);          %Posici�n Caja Nicaragua
Par(5).Posicion = PosicionI(5,:);          %Posici�n Caja Panam�

for i = 1:num_Par
    
    Par(i).Velocidad = zeros(tam_Par);
    
    Par(i).Peso = F(Par(i).Posicion);
    
    Par(i).Mejor.Posicion = Par(i).Posicion;
    
    Par(i).Mejor.Peso = Par(i).Peso;
    
    %Actualizando el Valor Global
    if Par(i).Mejor.Peso < Global.Peso
        Global.Peso = Par(i).Mejor.Peso;
        Global.Posicion = Par(i).Posicion;
    end
    
end


%% C�digo Principal del Algoritmo

%Definici�n de Contador
cont = 0;

while min_Peso < min_Global && cont < iter
        
    %Iteraci�n por Part�cula
    for i = 1:num_Par
        
        %Actualizaci�n de Velocidad
        Par(i).Velocidad = w*Par(i).Velocidad ...
            + c1*transpose(rand(dim_Par, 1)).*(Par(i).Mejor.Posicion - Par(i).Posicion) ...
            + c2*transpose(rand(dim_Par, 1)).*(Global.Posicion - Par(i).Posicion);
            
        %Actualizaci�n de Posici�n
        Par(i).Posicion = Par(i).Posicion + Par(i).Velocidad;
            
        %Actualizaci�n de Peso
        Par(i).Peso = F(Par(i).Posicion);
            
        %Actualizaci�n de Peso y Posici�n Global
        if Par(i).Peso < Par(i).Mejor.Peso
            Par(i).Mejor.Posicion = Par(i).Posicion;
            Par(i).Mejor.Peso = Par(i).Peso;
        end
            
    end
    min_Global = min([Par(1).Peso, Par(2).Peso, Par(3).Peso, Par(4).Peso, Par(5).Peso]);
    cont = cont+1;
end

%% Resultados

Resultados = [Par(1).Peso, Par(2).Peso, Par(3).Peso, Par(4).Peso, Par(5).Peso];

end

%Ejemplo
%Resultados = [1.1910    1.2480    0.0231   -0.1191    0.7825]
%De acuerdo a los resultados obtenidos, en 8 iteraciones la funci�n
%objetivo llega a ser -0.1191 en el valor m�s peque�o y  1.2480 en el m�s alto.
%Ordenando las operaciones de menor a mayor tenemos que el orden de las
%operaciones deber�a de ser 

%                       [4, 3, 5, 1, 2]

%De este modo, se utiliz� exitosamente el m�todo de Swarm Optimization para
%hallar el mejor orden y realizar las ordenes con la combinaci�n m�s eficiente 
%posible.

