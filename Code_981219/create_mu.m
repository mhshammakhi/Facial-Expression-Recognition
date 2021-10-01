function mu = create_mu(f,sigma)
f_double = im2double(f);
L = imgaussfilt3(f_double ,sigma);
%%
Lx=zeros(size(L));Lx(:,2:end,:)=diff(L,1,2);
Ly=zeros(size(L));Ly(2:end,:,:)=diff(L,1,1);
Lt=zeros(size(L));Lt(:,:,2:end)=diff(L,1,3);
%%
second_moment=[Lx.*Lx,Lx.*Ly,Lx.*Lt;   Lx.*Ly,Ly.*Ly,Ly.*Lt; Lx.*Lt,Ly.*Lt,Lt.*Lt];
mu=imgaussfilt3(second_moment,sigma);
%%
end



