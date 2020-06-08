clear all;close all;
img=imread('julei.jpg');
img1=im2bw(img);
figure;imshow(img1); 
img1 = medfilt2(img1,[5 5]);
figure;imshow(img1); 

img1=double(img1);
[X Y Z]=size(img1);
[fx,fy]=gradient(img1);
xcont=find(fx);
ycont=find(fy);
segOutline=zeros(X,Y);
segOutline(xcont)=1;
segOutline(ycont)=1;
figure,imshow(segOutline);

segOutline1 = medfilt2(segOutline,[4 4]);
figure;imshow(segOutline1); 


imgMarkup=img1(:,:,1);
imgMarkup(xcont)=1;
imgMarkup(ycont)=1;
figure,imshow(imgMarkup);
title('imgMarkup');


imgTmp1=img1(:,:,1);
imgTmp1(xcont)=0;
imgTmp1(ycont)=0;
imgMarkup(:,:,2)=imgTmp1;
imgMarkup(:,:,3)=imgTmp1;
figure,imshow(imgMarkup);