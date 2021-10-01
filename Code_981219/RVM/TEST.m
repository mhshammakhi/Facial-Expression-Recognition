clear;clc;
dataFolder='D:\UNIstuff\BachelorProject\Result_990506';
dataFolder(dataFolder=='\')='/';path_code=pwd;path_code(path_code=='\')='/';
path_Save=path_code;

acc=[];
for seg=3:10
    for bin=10:5:50
        for OverP=0:1:8
            load([dataFolder,'/',sprintf('Dataset_sig2_seg%d_bins%d_overlap0.%d.mat',seg,bin,OverP)]) ;
            [trainInd,valInd,testInd]=dividerand(size(Data,1),0.75,0,0.25);
            
            xtrain=Data(trainInd,:);ytrain=Label(trainInd);
            xtest=Data(testInd,:);ytest=Label(testInd);
            u=unique(ytrain);
            numClasses=length(u);
             X = xtrain;
             P = numClasses;
            N		= size(xtrain,1);
            M = size(xtest,1);
            t	= zeros(N,P);
            
            for p=1:P
                t(find(ytrain==p),p)=1;
            end
            t=t';
            
            s	= zeros(M,P);
            
            for p=1:P
                s(find(ytest==p),p)=1;
            end
            s=s';
            
            OUTPUT = train_mRVM1('-p',X,t,1,2,1200,'gaussian',0.001,0);
        
            [class_memberships, accuracy , confmat] = predict_mRVM(OUTPUT,xtest,s);
            
            data_name=sprintf('FinalOutputmRVM_%dseg_%dbins_%dOverP.mat',seg,bin,OverP);
            add_save=sprintf([path_Save,'/',data_name]);
            save(add_save,'seg','bin','OverP','accuracy','class_memberships','confmat');
            disp(['seg:',num2str(seg),' bin:',num2str(bin),' overlap:',num2str(OverP)])

            end
    end
end