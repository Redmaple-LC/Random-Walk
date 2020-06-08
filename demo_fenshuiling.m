close all;                   % 关闭所有图形窗口
clear all;                   % 清空工作区
clc;                         % 清空命令行窗口

% 使用距离变换和分水岭变换分割二值图像
f=imread('82.jpg');
f = rgb2gray(f);
g = im2bw(f, graythresh(f));
% figure,imshow(g);
gc = ~g;
D = bwdist(gc); % 距离变换 
L = watershed(-D);
w = L == 0;
% figure,imshow(w); % 分水岭脊线
g2 = g-w;
% figure,imshow(g2); % 以黑色叠加在原始二值图像上的分水岭脊线

% 使用梯度和分水岭变换分割灰度图像
f=imread('35.jpg');
f = rgb2gray(f);
fd = tofloat(f);
h = fspecial('sobel');
g = sqrt(imfilter(fd, h, 'replicate') .^ 2 + ...
imfilter(fd, h', 'replicate') .^ 2);
% figure,imshow(g); % 梯度

L = watershed(g);
wr = L == 0;
% figure,imshow(wr); % 分水岭脊线

g2 = imclose(imopen(g, ones(3,3)), ones(3,3));
L2 = watershed(g2);
wr2 = L2 == 0;
% figure,imshow(wr2); % 改进的分水岭脊线

f2 = f;
f2(wr2) = 255;
figure,imshow(f2); % 分割结果

% 控制标记符的分水岭分割
f=imread('47.jpg');
f = rgb2gray(f);
fd = tofloat(f);
h = fspecial('sobel');
g = sqrt(imfilter(fd, h, 'replicate') .^ 2 + ...
imfilter(fd, h', 'replicate') .^ 2);
L = watershed(g);
wr = L == 0;
% figure,imshow(wr); % 分水岭脊线

rm = imregionalmin(g);
im = imextendedmin(f,2);
fim = f;
fim(im) = 175;
Lim = watershed(bwdist(im));
em = Lim == 0;
% figure,imshow(em); % 改进的分水岭脊线

g2 = imimposemin(g, im | em);
L2 = watershed(g2);
f2 = f;
f2(L2 == 0) = 255;
% figure,imshow(f2); % 分割结果