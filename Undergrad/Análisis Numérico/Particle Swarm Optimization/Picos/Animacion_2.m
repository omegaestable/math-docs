%Se anima el algoritmo PSO para una funci�n con muchos �ptimos locales
pkg load statistics
clear;
clf;

problema = @(x) picos(x);
nvar = 2;

%Espacio de b�squeda
bound.xmin = -3;
bound.xmax = 3;
bound.vmin = 0.05*(bound.xmax-bound.xmin);
bound.vmax = -bound.vmin;

%Coeficientes
k = 1; phi1 = 1.55; phi2 = 1.55;  %Par�metros de operaci�n
phi = phi1+phi2;
chi = 2*k/abs(2-(phi)-sqrt(phi.^2-4*phi));  %T�rmino corrector

param.itermax = 75;  %M�ximo de iteraciones
param.npop = 20;  %Poblacion
param.w = chi;  
param.wdamp = 0.59; %Omega
param.c1 = chi*phi1;
param.c2 = chi*phi2;

PSO(problema, nvar, bound, param)

