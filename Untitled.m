I=imread('01.jpg');
I=rgb2gray(I);

% figure,imhist(I);
% ylim('auto');
% title('�Ҷ�ֱ��ͼ')

I=im2double(I);
I=imresize(I,[800,800]);
% I=imadjust(I); % ��ǿͼ��

a=mean(mean(I)) % ��һ���Ҷ�