I = imread('82.jpg');
imshow(I)
%se = strel('disk',1);
%A = imerode(I,se);
%figure,imshow(A)
D = ap(I);
figure,imshow(D)

se0 = strel('disk', 2);
B = imopen(I,se0);
figure,imshow(B)