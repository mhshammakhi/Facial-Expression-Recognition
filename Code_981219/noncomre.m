function y=noncomre(x,A)
y=zeros(size(x));
mat1=(abs(x)<=(1/A));
mat2=(abs(x)>(1/A));
y(mat1)=A*x(mat1)/(1+log10(A));
y(mat2)=(1+log10(A*abs(x(mat2))))/(1+log10(A));