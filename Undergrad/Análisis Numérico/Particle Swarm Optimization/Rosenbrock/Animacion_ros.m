
rosbr.a = 1;
rosbr.b = 15;
pkg load statistics
problem = @(x) Rosfun(x, rosbr);
nvar = 2;

busqueda.xmin = -2;
busqueda.xmax = 2;
busqueda.vmin = 0.05*(busqueda.xmax-busqueda.xmin);
busqueda.vmax = -busqueda.vmin;

% Constriction Coeff.
k = 1; phi1 = 2.05; phi2 = 2.05;
phi = phi1+phi2;
%Se incluye este t�rmino para mejorar la estabilidad
chi = 2*k/abs(2-(phi)-sqrt(phi.^2-4*phi));

param.itermax = 60; 
param.npop = 12;  %Aqui se inicia el n�mero part�culas del enjambre
param.w = chi;  %T�rmino corrector,  %Este t�rmino se puede iniciar como 1, para ver comportamiento cl�sico del algoritmo

param.wdamp = 0.99;   %Este es el omega
param.c1 = chi*phi1;
param.c2 = chi*phi2;
PSO_r(problem, nvar, busqueda, param, rosbr)
