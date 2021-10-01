clc;clear;clf;
overlap=0.4;A=28;sigma_filt=2;
path_code=pwd;path_code(path_code=='\')='/';
addpath(path_code);
path_Save=path_code;
load('H_label.mat')
for n_seg=3:10
    for n_bins=10:200 
        Data=[];Label=[];
         for k = 1:size(H_label,2)
             n_Label = H_label{2,k} ;
             H =H_label{1,k};
             hist_mov=zeros(1,n_bins*n_seg^2);
             for i = 1 : size(H , 3) 
                 tmp = H(:,:,i);
                 hist_mov=hist_mov+seg_hist(tmp,n_seg,n_bins,overlap,A);
                 hist_mov=hist_mov/size(H,3);
             end
             Data=[Data;hist_mov];
             Label=[Label;n_label];
             data_name=sprintf('Dataset_sig%d_seg%d_bins%d_overlap%01.1f.mat',sigma_filt,n_seg,n_bins,overlap);
             add_save=sprintf([path_Save,'/',data_name]);
             if abs(size(Data,1)-size(Label,1))
                 disp('Size has a problem')
             else
                 save(add_save,'Data','Label','n_seg','n_bins','sigma_filt','overlap');
             end
          
         end
   end

 end 
