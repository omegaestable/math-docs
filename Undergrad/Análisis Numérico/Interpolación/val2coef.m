function c = val2coef(values)
n=size(values,1); 
% Mirror the values 
tmp=[values(n:-1:2,:);values(1:n-1,:)]; 
% apply ifft 
c=real(ifft(tmp));
%Truncate
c=c(1:n,:);
%Scale the interior coefficients
c(2:n-1,:)=2*c(2:n-1,:);
end

