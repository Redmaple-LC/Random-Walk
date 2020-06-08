RGB = imread('01.jpg');
I = rgb2gray(RGB);
%I = I(401:100,1:400);

J = imnoise(I,'gaussian',0,0.005);
J = im2double(J);

K = mywiener2(J,[8 8]);

figure;
imshow(I), title('original image');

figure;
imshow(K),title('filtered image');

%figure;
%subplot(1,2,1), subimage(J), title('noised image');
%subplot(1,2,2), subimage(K), title('denoised image');
