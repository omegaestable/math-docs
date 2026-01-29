%Parte d)%
c=rand(10^8,1);
x0=0.1;
tic
b=evalCheb(c,x0)
toc
%parte e)%
x0=1;
c=[1/4 -3/2 3/4 -1/2];
b=evalCheb(c,x0)