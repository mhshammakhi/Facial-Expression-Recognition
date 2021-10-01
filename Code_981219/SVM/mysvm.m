function z = mysvm(TrainingSet,GroupTrain,TestSet,y_test)
u=unique(GroupTrain);
numClasses=length(u);

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

for k=1:size(TestSet,1)
   a= y_test(k,:);
   if a(1)< a(2)
      i = a(1);
      j = a(2);
   else
     i = a(2);
     j = a(1);
    end
   [~,~,c] = predict(models{10*i+j},TestSet(k,:));
   result(k) = i*c(:,1)+j*c(:,2); 
end
z = result;
end
