clc;clear
data = dir('D:\UNIstuff\BachelorProject\981201_v3\Dataset_981212');
N = length(data);
Accuuracy = [];
path_code=pwd;path_code(path_code=='\')='/';
addpath(path_code);
path_Save=path_code;

for seg = 7:10
    for bin = 10 : 20
        for ovrlp = 4:4
load(sprintf('Dataset_sig2_seg%d_bins%d_overlap0.%d.mat',seg,bin,ovrlp)) ;   

[trainInd,valInd,testInd]=dividerand(size(Data,1),0.8,0,0.2);
xtrain=Data(trainInd,:);ytrain=Label(trainInd);
xtest=Data(testInd,:);ytest=Label(testInd);
ytrain_vec = zeros(7,length(ytrain));
ytest_vec = zeros(7,length(ytest));
    for i = 1:length(ytrain)
        ytrain_vec(ytrain(i),i) = 1.0;
    end

    for i = 1:length(ytest)
        ytest_vec(ytest(i),i) = 1.0;
    end
    
xtrainT = xtrain.';
xtestT= xtest.';
net = feedforwardnet(20);
% net = newff(xtrain,ytrain_vec,20);
net.trainParam.epochs = 100;
[net tr] = train(net,xtrainT,ytrain_vec);

 output = sim(net,xtestT);

[val,ind] = max(output);
output2 = output;
output2(bsxfun(@eq, output2, val)) = -Inf;
[val2,ind2] = max(output2);

data_num = [];
new_xtest = [];
new_ytest = [];
th = 0.25;
for j = 1:length(output)
 if abs(val(j) - val2(j)) < th
 data_num =[data_num;j];     
 new_xtest = [new_xtest,xtestT(:,j)];
 new_ytest = [new_ytest;ind(j) ind2(j)] ;
 end
end 
new_xtestT = new_xtest.';
yFinal=ind;
z = mysvm(xtrain,ytrain,new_xtestT,new_ytest);
for k = 1:length(z)
  yFinal(data_num(k)) = z(k);
end

 acc = mean(ytest==yFinal.');
 tsterr  = mean(ytest ~= yFinal.');
 confmat = confusionmat(ytest,yFinal.');

data_name=sprintf('FinalOutput_MLPSVM_%dseg_%dbins_%doverlap.mat',seg,bin,ovrlp);
add_save=sprintf([path_Save,'/',data_name]);
save(add_save,'seg','bin','ovrlp','acc','tsterr','confmat');

        end
    end
end
