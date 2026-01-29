%Parte b)
m=80;
[U,~]=qr(randn(m));
[V,~]=qr(randn(m));
S=diag(2.^(-1:-1:-80));
A=U*S*V;
%Parte c
[Q1,R1] = GS_inest(A); 
[Q2,R2] = GS_est(A); 
[Q3,R3] = Householder(A);
[Q,R] = qr(A);
Error1= norm((A-Q1*R1),2);
Error2= norm((A-Q2*R2),2);
Error3= norm((A-Q3*R3),2);
Error4= norm((A-Q*R),2);

ErrorUnit1=norm((Q1'*Q1-eye(m)),2);
ErrorUnit2=norm((Q2'*Q2-eye(m)),2);
ErrorUnit3=norm((Q3'*Q3-eye(m)),2);
ErrorUnit4=norm((Q'*Q-eye(m)),2);