close all;                   % �ر�����ͼ�δ���
clear all;                   % ��չ�����
clc;                         % ��������д���

% ʹ�þ���任�ͷ�ˮ��任�ָ��ֵͼ��
f=imread('82.jpg');
f = rgb2gray(f);
g = im2bw(f, graythresh(f));
% figure,imshow(g);
gc = ~g;
D = bwdist(gc); % ����任 
L = watershed(-D);
w = L == 0;
% figure,imshow(w); % ��ˮ�뼹��
g2 = g-w;
% figure,imshow(g2); % �Ժ�ɫ������ԭʼ��ֵͼ���ϵķ�ˮ�뼹��

% ʹ���ݶȺͷ�ˮ��任�ָ�Ҷ�ͼ��
f=imread('35.jpg');
f = rgb2gray(f);
fd = tofloat(f);
h = fspecial('sobel');
g = sqrt(imfilter(fd, h, 'replicate') .^ 2 + ...
imfilter(fd, h', 'replicate') .^ 2);
% figure,imshow(g); % �ݶ�

L = watershed(g);
wr = L == 0;
% figure,imshow(wr); % ��ˮ�뼹��

g2 = imclose(imopen(g, ones(3,3)), ones(3,3));
L2 = watershed(g2);
wr2 = L2 == 0;
% figure,imshow(wr2); % �Ľ��ķ�ˮ�뼹��

f2 = f;
f2(wr2) = 255;
figure,imshow(f2); % �ָ���

% ���Ʊ�Ƿ��ķ�ˮ��ָ�
f=imread('47.jpg');
f = rgb2gray(f);
fd = tofloat(f);
h = fspecial('sobel');
g = sqrt(imfilter(fd, h, 'replicate') .^ 2 + ...
imfilter(fd, h', 'replicate') .^ 2);
L = watershed(g);
wr = L == 0;
% figure,imshow(wr); % ��ˮ�뼹��

rm = imregionalmin(g);
im = imextendedmin(f,2);
fim = f;
fim(im) = 175;
Lim = watershed(bwdist(im));
em = Lim == 0;
% figure,imshow(em); % �Ľ��ķ�ˮ�뼹��

g2 = imimposemin(g, im | em);
L2 = watershed(g2);
f2 = f;
f2(L2 == 0) = 255;
% figure,imshow(f2); % �ָ���