% clc;clear;
dataFolder='D:\UNIstuff\BachelorProject\Code_990214';
dataFolder(dataFolder=='\')='/';

path_code=pwd;path_code(path_code=='\')='/';
path_Save=path_code;
max_acc_train=0;
max_acc_test=0;
n_fold=10;
for seg = 7:7
    for bin = 10 :11
        for ovrlp = 4:4
            load([dataFolder,'/',sprintf('Dataset_sig2_seg%d_bins%d_overlap0.%d.mat',seg,bin,ovrlp)]) ;
%             [W,T]= pca(Data);
            Reduced_Data = Data;
            n_data=size(Reduced_Data,1);
            block_size=floor(n_data/n_fold);
            index=datasample(1:n_data,n_data,'Replace',false);
            acc_test=0;
            for z=1:n_fold
                test_num_indx=(z-1)*block_size+(1:block_size);
                testInd=index(test_num_indx);
                trainInd= setdiff(1:n_data,testInd);
                xtrain=Reduced_Data(trainInd,:);ytrain=Label(trainInd);
                xtest=Reduced_Data(testInd,:);ytest=Label(testInd);
                t_per=multisvm_OnevsAll(xtrain,ytrain,xtest);
                acc_test = acc_test+mean(ytest==t_per) ;
            end
            acc = acc_test/n_fold;
            disp(acc)
            data_name=sprintf('FinalOutput_kfold_SVM_%dseg_%dbins_%doverlap.mat',seg,bin,ovrlp);
            add_save=sprintf([path_Save,'/',data_name]);
            save(add_save,'seg','bin','ovrlp','acc');
            disp(['seg:',num2str(seg),' bin:',num2str(bin),' ovrlp:',num2str(ovrlp)])
        end
    end
end

