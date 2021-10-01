function z = multisvm(TrainingSet,GroupTrain,TestSet)
%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier according to a 
%one vs one relation. 
%
%This code was written by Cody Mohammad Hassan Shammakhi , mh.shammakhi@aut.ac.ir , MSPRL Lab
%Amirkabir University of Technology, Tehran Iran

u=unique(GroupTrain);
numClasses=length(u);
%result = zeros(length(TestSet(:,1)),1);

%build models
for i=1:numClasses-1
    for j=i+1:numClasses
        %Vectorized statement that binaries Group
        %where 1 is the current class and 0 is another class
        G1=TrainingSet(GroupTrain==u(i),:);G2=TrainingSet(GroupTrain==u(j),:);
        G1_l=ones(sum(GroupTrain==u(i)),1);G2_l=zeros(sum(GroupTrain==u(j)),1);
        models{10*i+j} = fitcsvm([G1;G2],[G1_l;G2_l],'Standardize',true,'KernelFunction','RBF','KernelScale','auto');
    end
end
%classify test cases
k=1;
for i=1:(numClasses-1)
    for j=(i+1):numClasses
    [~,~,c]=predict(models{10*i+j},TestSet);
    l(:,k)=i*c(:,1)+j*c(:,2);
    k=k+1;
    end
end
for i=1:numClasses
    tmp=i*ones(size(l));
    num_l(:,i)=sum(((tmp==l)+0),2);
end
[~,z]=max(num_l,[],2);
z=u(z);
end
