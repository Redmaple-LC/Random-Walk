tic
I = imread('82.jpg');
imshow(I)
title('ԭͼ')
I = rgb2gray(I);
out1 = anisodiff(I,90,10,0.15,2);
% out2 = anisodiff(I,150,15,0.18,2);
A = out1/255;
% B = out2/255;
figure,imshow(A);
% title('����һ')
% figure,imshow(B);
% title('������')

%f = im2bw(A);
%figure,imshow(f)
 
%se = strel('disk', 5); % 'square', 2   'diamond', 1
%B = imclose(f,se); % ������ȥ���� ������ȥë��
%se0 = strel('disk', 4);
%C = imopen(f,se0);
%figure,imshow(C)




 toc