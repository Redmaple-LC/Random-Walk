clear all; close all;
tic
I = imread('53.jpg');
 I=rgb2gray(I);
[m, n, p] = size(I);
% [m, n] = size(I);
k = 6;%��������
[C, label, J] = kmeans(I, k);
I_seg = reshape(C(label, :), m, n, p);
A = reshape(label==2, [m n]); %labelΪÿ���࣬�˾���ʾÿ����
% I_seg = reshape(C(label, :), m, n);
figure, imshow(I, []), title('ԭͼ')
figure, imshow(uint8(I_seg), []), title('����ͼ')
%figure,imshow(uint8(A), []), title('��n��ֵ��ͼ��ɫΪ��')
figure
plot(1:length(J), J), xlabel('#iterations')
C % ������������
% plot(C(:,1),C(:,2),'kx','MarkerSize',14,'LineWidth',4)
% I
% [i,j]=find(I==C(1,1));

toc

