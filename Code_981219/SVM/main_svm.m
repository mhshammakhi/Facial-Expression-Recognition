clc;clear;
data = dir('D:\UNIstuff\BachelorProject\981201_v3\Dataset_981212');
N = length(data);
Accuuracy = [];
path_code=pwd;path_code(path_code=='\')='/';
addpath(path_code);
path_Save=path_code;

for seg = 7:10
    for bin = 10 :20
        for ovrlp = 4:4
load(sprintf('Dataset_sig2_seg%d_bins%d_overlap0.%d.mat',seg,bin,ovrlp)) ; 
[trainInd,valInd,testInd]=dividerand(size(Data,1),0.8,0,0.2);
xtrain=Data(trainInd,:);ytrain=Label(trainInd);
xtest=Data(testInd,:);ytest=Label(testInd);


t_per=multisvm(xtrain,ytrain,xtest);

acc = mean(ytest==t_per) ;
confmat = confusionmat(ytest,yFinal.');

data_name=sprintf('FinalOutput_SVM_%dseg_%dbins_%doverlap.mat',seg,bin,ovrlp);
add_save=sprintf([path_Save,'/',data_name]);
save(add_save,'seg','bin','ovrlp','acc','tsterr','confmat');

        end
    end
end

