function A = Kernel_Mtx(x2,x1,sigma)
%x1 : train data
%x2 : test data

N_Sample = size(x1,1);
N_test = size(x2,1);

D1 = N_Sample+1;
D2 = size(x2,2)+1;
x2=permute(x2,[3 2 1]);
test_3d=repmat(x2,N_Sample,1,1);
sample_3d=repmat(x1,1,1,N_test);
A=[ones(1,D2,N_test);[ones(D1-1,1,N_test),exp(-(sample_3d-test_3d).^2/(2*sigma^2))]];
   
end

 