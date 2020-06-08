clear all; close all;
tic
I = imread('53.jpg');
 I=rgb2gray(I);
[m, n, p] = size(I);
% [m, n] = size(I);
k = 6;%聚类种数
[C, label, J] = kmeans(I, k);
I_seg = reshape(C(label, :), m, n, p);
A = reshape(label==2, [m n]); %label为每个类，此句显示每个类
% I_seg = reshape(C(label, :), m, n);
figure, imshow(I, []), title('原图')
figure, imshow(uint8(I_seg), []), title('聚类图')
%figure,imshow(uint8(A), []), title('类n二值化图白色为类')
figure
plot(1:length(J), J), xlabel('#iterations')
C % 聚类中心坐标
% plot(C(:,1),C(:,2),'kx','MarkerSize',14,'LineWidth',4)
% I
% [i,j]=find(I==C(1,1));

toc

