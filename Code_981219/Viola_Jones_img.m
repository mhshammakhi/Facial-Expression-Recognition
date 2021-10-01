function output = Viola_Jones_img( Img )
%Viola_Jones_img( Img )
% Img - input image
% Example how to call function: Viola_Jones_img(imread('name_of_the_picture.jpg'))

faceDetector = vision.CascadeObjectDetector;
bboxes = step(faceDetector, Img);
bboxes=sortrows(bboxes,-3);
bboxes=bboxes(1,:);
output=[bboxes(1),(bboxes(1)+bboxes(3)),bboxes(2),bboxes(2)+bboxes(4)];
% figure, imshow(Img), title('Detected faces');hold on;impixelinfo;
% for i=1:size(bboxes,1)
%     rectangle('Position',bboxes(i,:),'LineWidth',2,'EdgeColor','y');
% end
end