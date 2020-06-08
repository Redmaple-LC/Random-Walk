close all;%关闭所有窗口

clear;%清除变量的状态数据  
clc;%清除命令行 
tic

I=imread('06.jpg');  
%subplot(1,2,1);  
imshow(I);  
title('原图');  
bw=graythresh(I);  
disp(strcat('otsu阈值分割的阈值:',num2str(bw*255)));%在command window里显示出 :迭代的阈值:阈值  
A=im2bw(I,bw);  
%subplot(1,2,2);  
figure,imshow(A);  
title('otsu阈值分割');

toc