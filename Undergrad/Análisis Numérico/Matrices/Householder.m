function [Q,R] = Householder(A)
%Calcula la factorización QR de una matriz compleja A. A=QR
%con Q unitaria y R triangular superior.
[m,n]=size(A);
  V=zeros(m,n);
for j=1:n
    x=A(j:m,j);
    I=eye(length(x));
    e1=I(:,1);
    if x(1)~=0
        v=sign(x(1))*norm(x,2)*e1 + x;
        
    else
        v=norm(x,2)*e1+x;
    end
    v=v/norm(v,2);
    A(j:m,j:n)=A(j:m,j:n)-2*v*(v'*A(j:m,j:n));
    V(j:m,j)=v;
end
R=A(1:n,1:n);
Q=eye(m,n);
for j=n:-1:1
    Q(j:m,j:n)=Q(j:m,j:n)-2*V(j:m,j)*(V(j:m,j)'*Q(j:m,j:n));
end

