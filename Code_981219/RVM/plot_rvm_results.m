clc
clear
close all

dataFolder='D:\UNIstuff\BachelorProject\Code_990304\resultsmRVM';
dataFolder(dataFolder=='\')='/';path_code=pwd;path_code(path_code=='\')='/';
results=zeros(648,4);
k=1;
for seg=3:10
    for bin=10:5:50
        for OverP=0:1:8
            load([dataFolder,'/',sprintf('FinalOutputmRVM_%dseg_%dbins_%d.000000e-01OverP.mat',seg,bin,OverP)]) ;
%             FinalOutputmRVM_3seg_10bins_1.000000e-01OverP
            results(k,1)=accuracy;
            results(k,2)=seg;
            results(k,3)=bin;
            results(k,4)=OverP;
            k=k+1;
            
         end
    end
end
acc = results(:,1);
seg = results(:,2);
bin = results(:,3);
OverP = results(:,4);

acc_seg = [acc,seg];
acc_bin = [acc,bin];
acc_bin=sortrows(acc_bin,2);
acc_OverP = [acc,OverP];
acc_OverP=sortrows(acc_OverP,2);

max_acc_bin = [max(acc_bin(1:72)),max(acc_bin(73:144)),max(acc_bin(145:216)),max(acc_bin(217:288)),max(acc_bin(289:360)),max(acc_bin(361:442)),max(acc_bin(443:514)),max(acc_bin(515:586)),max(acc_bin(587:648))];
max_acc_seg = [max(acc_seg(1:81)),max(acc_seg(82:162)),max(acc_seg(163:243)),max(acc_seg(244:324)),max(acc_seg(325:405)),max(acc_seg(406:486)),max(acc_seg(487:567)),max(acc_seg(568:648))];
max_acc_OverP = [max(acc_OverP(1:72)),max(acc_OverP(73:144)),max(acc_OverP(145:216)),max(acc_OverP(217:288)),max(acc_OverP(289:360)),max(acc_OverP(361:442)),max(acc_OverP(443:514)),max(acc_OverP(515:586)),max(acc_OverP(587:648))];


plot(unique(seg),max_acc_seg,'Marker','x');
title('Test Accuracy VS Segment')
ylabel('Accuracy')
xlabel('Number of Segments')
figure
plot(unique(bin),max_acc_bin,'r','Marker','o');
title('Test Accuracy VS Bins')
ylabel('Accuracy')
xlabel('Number of Bins')
figure
plot(unique(OverP),max_acc_OverP,'m','Marker','+');
title('Test Accuracy VS Overlap')
ylabel('Accuracy')
xlabel('Percentage of Overlap')




