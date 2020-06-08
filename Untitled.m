I=imread('01.jpg');
I=rgb2gray(I);

% figure,imhist(I);
% ylim('auto');
% title('灰度直方图')

I=im2double(I);
I=imresize(I,[800,800]);
% I=imadjust(I); % 增强图像

a=mean(mean(I)) % 归一化灰度