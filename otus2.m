close all;%�ر����д���

clear;%���������״̬����  
clc;%��������� 
tic

I=imread('06.jpg');  
%subplot(1,2,1);  
imshow(I);  
title('ԭͼ');  
bw=graythresh(I);  
disp(strcat('otsu��ֵ�ָ����ֵ:',num2str(bw*255)));%��command window����ʾ�� :��������ֵ:��ֵ  
A=im2bw(I,bw);  
%subplot(1,2,2);  
figure,imshow(A);  
title('otsu��ֵ�ָ�');

toc