function [Q,R] = GS_est(A)
%Calcula la factorización QR de una matriz compleja A. A=QR
%con Q unitaria y R triangular superior.
[~,n]=size(A);
V=A;
for i=1:n
    R(i,i)=norm(V(:,i),2);
    Q(:,i)=V(:,i)/R(i,i);
    for j=i+1:n
        R(i,j)=(Q(:,i)')*V(:,j);
        V(:,j)=V(:,j)-R(i,j)*Q(:,i);
    end
end
end

