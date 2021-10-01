function hist_im=seg_hist(im,n_seg,n_bin,overlap,A)
hist_im=zeros(1,n_bin*n_seg^2);n=0;
for i=1:n_seg
    for j=1:n_seg
        x_start=floor((i-1)*size(im,1)/n_seg)+1;x_end=x_start+floor(size(im,1)/n_seg)-1;x_start=x_start-floor((i-1>0)*overlap*size(im,1)/n_seg);
        y_start=floor((j-1)*size(im,2)/n_seg)+1;y_end=y_start+floor(size(im,2)/n_seg)-1;y_start=y_start-floor((j-1>0)*overlap*size(im,2)/n_seg);
        temp=im(x_start:x_end,y_start:y_end);
        first_hist=imhist(temp,n_bin)/numel(temp);
        hist_im((n*n_bin+1):((n+1)*n_bin))=noncomre(first_hist,A);
        n=n+1;
        clear temp;
    end
end
 
