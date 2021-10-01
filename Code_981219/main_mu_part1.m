clc;clear;clf;
addre={};
sigma_filt=2;
Data=[];Label=[];Address={};
path_code=pwd;path_code(path_code=='\')='/';
addpath(path_code);
path_data=[path_code,'/extended-cohn-kanade-images'];
path_Save=path_code;
kj=1;
list_up=dir(path_data);
eval(['cd ',path_data]);
H_label = {};
k = 1;
for i=3:4
%     size(list_up,1)
    tmp=list_up(i,1);
    tmp=tmp.name;
    eval(['cd ',tmp]);
    list_down=dir;
    for j=3:size(list_down,1)
        tmp2=list_down(j,1);
        tmp2=tmp2.name;
        eval(['cd ',tmp2]);
        path2=pwd;
        path2(path2=='\')='/';
        
        try
            list_tmp = dir([[path2,'/'],'*.png']);list_tmp=list_tmp(end,:);
            list_tmp=list_tmp.name;list_tmp((end-3):end)=[];
            fileID = fopen([[path2,'/'],list_tmp,'_emotion.txt'],'r');
            n_label = fscanf(fileID,'%s');
            n_label=str2double(n_label);
            fclose(fileID);
            movie = make_video_face([path2,'/']);
            mu =  create_mu(movie,sigma_filt);
            H = export_H(mu);
            H_label{1,k} = H;
            H_label{2,k} = n_label;
            k  = k+1;
            disp(i);
            
        catch
            add_tmp=path2((end-7):end);
            addre{kj}=add_tmp;
            kj=kj+1;
        end
        cd ..;
    end
    cd ..;
end
save([path_code,'/H_label.mat'],'-v7.3');




