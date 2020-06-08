ima = imread('03.jpg');
% 先设定FCM的几个初始参数
options=[2;20;1e-5]	% FCM公式中的参数m % 最大迭代次数	% 目标函数的最小误差		 
class_number = 4;  % 分为4类
imt = ImageSegmentation(ima,class_number,options)
%subplot(1,2,1),
imshow(ima),title('原图');
%subplot(1,2,2),
figure,imshow(imt); %显示生成的分割的图像
%kk = strcat('分割成',int2str(class_number),'类的输出图像');
title(kk);
