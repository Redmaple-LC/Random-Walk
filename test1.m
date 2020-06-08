A = imread('02.jpg');
A = im2bw(A);
figure,imshow(A)



se = strel('disk',8);
f = imerode(A,se);
figure,imshow(f)

BW5 = imfill(f,'holes');
%subplot(121), imshow(BW4), title('源图像二值化')
subplot(122), imshow(BW5), title('填充后的图像')