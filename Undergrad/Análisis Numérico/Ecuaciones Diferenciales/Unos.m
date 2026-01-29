function [ A ] = Unos( m )
%Recibe m y devuelve una matriz con 1's en la diagonal y encima de ella, y
%-1s debajo de ella
A=zeros(m);
for i=1:m
    for j=1:m
        if i>j
            A(i,j)=-1;
        else
            if j==m || i==j
            A(i,j)=1;
            else
                A(i,j)=0;
            end
    end
end


end

