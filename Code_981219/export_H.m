function H=export_H(mu)
k=0.04;
H=zeros(size(mu,1)/3,size(mu,2)/3,size(mu,3));
for j=1:size(mu,3)
all=mu(:,:,j);
a=all(1:(end/3),1:(end/3));b=all((end/3+1):(2*end/3),1:(end/3));c=all((2*end/3+1):end,1:(end/3));
d=all(1:(end/3),(end/3+1):(2*end/3));e=all((end/3+1):(2*end/3),(end/3+1):(2*end/3));f=all((2*end/3+1):end,(end/3+1):(2*end/3));
g=all(1:(end/3),(2*end/3+1):end);h=all((end/3+1):(2*end/3),(2*end/3+1):end);i=all((2*end/3+1):end,(2*end/3+1):end);
H(:,:,j)=(a.*(e.*i-f.*h)-b.*(d.*i-f.*g)+c.*(d.*h-e.*g))-k*((a+e+i));
imshow(H(:,:,j));
pause(eps);
H(:,:,j) = uint8(256*H(:,:,j));
end


