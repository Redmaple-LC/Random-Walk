A = imread('02.jpg');
A = im2bw(A);
figure,imshow(A)



se = strel('disk',8);
f = imerode(A,se);
figure,imshow(f)

BW5 = imfill(f,'holes');
%subplot(121), imshow(BW4), title('Դͼ���ֵ��')
subplot(122), imshow(BW5), title('�����ͼ��')