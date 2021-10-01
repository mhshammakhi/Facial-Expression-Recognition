function movie=make_video_face(folder_address)
n_for=size(dir([folder_address,'\*.png']),1);
list=dir([folder_address,'*.png']);
list=list.name;list((end-5):end)=[];
ref=list;clear list;
for i=1:1
    name_pic=sprintf([ref,'%02d.png'],i);
    tmp=imread([folder_address,name_pic]);
    face_location=Viola_Jones_img(tmp);
end
movie=uint8(zeros(face_location(4)-face_location(3)+1,face_location(2)-face_location(1)+1,n_for));
% sit=0;
i=1;
while i<=n_for
    name_pic=sprintf([ref,'%02d.png'],i);
    tmp=imread([folder_address,name_pic]);
    movie(:,:,i)=sum(tmp(face_location(3):face_location(4),face_location(1):face_location(2),:),3)/size(tmp,3);
    imshow(movie(:,:,i));
    pause(eps);
    i=i+1;
end