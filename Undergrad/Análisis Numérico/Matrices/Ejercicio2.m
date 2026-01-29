%Se recomienda agrandar las imagenes en pantalla completa.

%Ejercicio 2a) %Tiempo de ejecucio ~3min$
RGB=imread('photo.bmp');
%Ejercicio 2b)
RGB=im2double(RGB);
%Ejercicio 2c)
%Aproximaci�n A5%
n=5;
[U1,S1,V1]=svd(RGB(:,:,1));
[U2,S2,V2]=svd(RGB(:,:,2));
[U3,S3,V3]=svd(RGB(:,:,3));
A5_1=zeros(3648,2736);
A5_2=zeros(3648,2736);
A5_3=zeros(3648,2736);
for i=1:n
    A5_1=U1(:,i)*S1(i,i)*V1(:,i)' + A5_1;
end
for i=1:n
    A5_2=U2(:,i)*S2(i,i)*V2(:,i)' + A5_2;
end
for i=1:n
    A5_3=U3(:,i)*S3(i,i)*V3(:,i)' + A5_3;
end
A5=zeros(3648,2736,3);
A5(:,:,1)=A5_1;
A5(:,:,2)=A5_2;
A5(:,:,3)=A5_3;
error1=norm(RGB(:,:,1)-A5_1);
error2=norm(RGB(:,:,2)-A5_2);
error3=norm(RGB(:,:,3)-A5_3);
subplot(1,3,1)
imshow(RGB)
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
title('RGB','Interpreter','Latex')

subplot(1,3,2)
imshow(A5)
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
title('A5','Interpreter','Latex')
subplot(1,3,3)
imshow(abs(RGB-A5))
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
title('$|RGB-A5|$','Interpreter','Latex')

%Ejercicio 1d)%
tol1_r=0.01*S1(1,1);   %todo se hace una vez por color (R-G-B)
tol1_g=0.01*S2(1,1);
tol1_b=0.01*S3(1,1);
singR=diag(S1);
singG=diag(S2);
singB=diag(S3);
R1_r=0;
R1_g=0;
R1_b=0;
i=1;
while singR(i)>tol1_r
    R1_r=R1_r+1;
    i=i+1;
end
i=1;
while singG(i)>tol1_g
    R1_g=R1_g+1;
    i=i+1;
end
i=1;
while singB(i)>tol1_b
    R1_b=R1_b+1;
    i=i+1;
end
R1=[R1_g , R1_b,R1_r];
R1=max(R1);
%Ahora calculamos las AR1 para cada color%
n=R1;
AR1_1=zeros(3648,2736);
AR1_2=zeros(3648,2736);
AR1_3=zeros(3648,2736);
for i=1:n
    AR1_1=U1(:,i)*S1(i,i)*V1(:,i)' + AR1_1;
end
for i=1:n
    AR1_2=U2(:,i)*S2(i,i)*V2(:,i)' + AR1_2;
end
for i=1:n
    AR1_3=U3(:,i)*S3(i,i)*V3(:,i)' + AR1_3;
end
AR1=zeros(3648,2736,3);
AR1(:,:,1)=AR1_1;
AR1(:,:,2)=AR1_2;
AR1(:,:,3)=AR1_3;

%Repetimos para AR2%
tol2_r=0.005*S1(1,1);   
tol2_g=0.005*S2(1,1);
tol2_b=0.005*S3(1,1);
singR=diag(S1);
singG=diag(S2);
singB=diag(S3);
R2_r=0;
R2_g=0;
R2_b=0;
i=1;
while singR(i)>tol2_r
    R2_r=R2_r+1;
    i=i+1;
end
i=1;
while singG(i)>tol2_g
    R2_g=R2_g+1;
    i=i+1;
end
i=1;
while singB(i)>tol2_b
    R2_b=R2_b+1;
    i=i+1;
end
R2=[R2_g , R2_b,R2_r];
R2=max(R2);
%Ahora calculamos las AR1 para cada color%
n=R2;
AR2_1=zeros(3648,2736);
AR2_2=zeros(3648,2736);
AR2_3=zeros(3648,2736);
for i=1:n
    AR2_1=U1(:,i)*S1(i,i)*V1(:,i)' + AR2_1;
end
for i=1:n
    AR2_2=U2(:,i)*S2(i,i)*V2(:,i)' + AR2_2;
end
for i=1:n
    AR2_3=U3(:,i)*S3(i,i)*V3(:,i)' + AR2_3;
end
AR2=zeros(3648,2736,3);
AR2(:,:,1)=AR2_1;
AR2(:,:,2)=AR2_2;
AR2(:,:,3)=AR2_3;
figure 
subplot(1,2,1)
imshow(AR1)
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
title('$A_{R_1}$','Interpreter','Latex')

subplot(1,2,2)
imshow(AR2)
set(gca,'FontName','Arial','FontSize',18,'FontWeight','Bold')
title('$A_{R_2}$','Interpreter','Latex')


%Ejercicio 2e)%
imwrite(AR2,'photo_comp.bmp');
imwrite(AR2,'photo_comp.jpg');