function [Q,R] = GS_inest(A)
%Calcula la factorización QR de una matriz compleja A. A=QR
%con Q unitaria y R triangular superior.
[~,n]=size(A);
for j=1:n
    v(:,j)=A(:,j);
    q(:,j)=A(:,j);
    for i=1:(j-1)
        R(i,j)=q(:,i)'*A(:,j);
        v(:,j)=v(:,j)-R(i,j)*q(:,i);
    end
    R(j,j)=norm(v(:,j),2);
    q(:,j)=1/(R(j,j))*v(:,j);
end
Q=q;
R=R;
end
