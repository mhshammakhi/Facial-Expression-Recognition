function z = multisvm_OnevsAll(TrainingSet,GroupTrain,TestSet)

u=unique(GroupTrain);
numClasses=length(u);
for i=1:numClasses
   
        G1=TrainingSet(GroupTrain==u(i),:);G2=TrainingSet(GroupTrain~=u(i),:);
        G1_l=ones(sum(GroupTrain==u(i)),1);G2_l=zeros(sum(GroupTrain~=u(i)),1);
        models{i} = fitcsvm([G1;G2],[G1_l;G2_l],'Standardize',true,'KernelFunction','linear','KernelScale','auto');
    
end
%classify test cases

for i=1:numClasses
   
    [a,b]=predict(models{i},TestSet);
    L1(:,i)= a(:,1) ;
    L2(:,i)= b(:,2) ;
    
end
% for j = 1:numClasses
%     l(:,j) = l(:,j)*j;
% end

[~,z] = max(L2,[],2);

end
