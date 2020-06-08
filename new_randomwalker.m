clear all;
close all;
clc

tic
I=imread('001.jpg');
I=rgb2gray(I);

% figure,imhist(I);
% ylim('auto');
% title('灰度直方图')

I=im2double(I);
I=imresize(I,[800,800]);
% I=imadjust(I); % 增强图像

a=mean(mean(I)) % 归一化灰度
b=a*255 % 平均灰度
[x,y]=size(I);
c=zeros(x,y);
for i=1:x
    for j=1:y
        c(i,j)=abs(I(i,j)-a); % 归一化
%         c(i,j)=abs(255*I(i,j)-b);% 非归一化
    end
end
d=mean(mean(c)) % 类内绝对差

% figure,imshow(I); % 原图
% title('原图')
 
% level = graythresh(img); 
% level = a-d*((b-100)/100); % mean 6以上可用
level = a*0.93;
% level = 0.60;
A=im2bw(I,level); 
figure,imshow(A,[]); % 二值化图像
title('二值化图')

se = strel('disk', 1); % 'square', 2   'diamond', 1
B = imclose(A,se); % 闭运算去凹陷 开运算去毛刺
se0 = strel('square', 2);
B = imopen(B,se0);

B = medfilt2(B,[5,5]); % 中值滤波
B = medfilt2(B);

% figure,imshow(B); % 去除干扰
% title('去除干扰图')

% edg=edge(B);
% figure,imshow(edg);
% title('edge分割图')

se1=strel( 'square', 3); %  'diamond', 1
% se1=[0 1 0
%     1 1 1
%     0 1 0];
C=imdilate(B,se1); % 腐蚀
% figure,imshow(C);
edg1 = edge(C);

se2=strel( 'square', 3); % 'square', 3
D=imerode(B,se2); % 膨胀
% figure,imshow(D);
edg2 = edge(D);

% img=imadjust(img); % 增强图像
[X, Y]=size(I);
[rd,cd]=find(edg1);
ld=length(rd);
[re,ce]=find(edg2);
le=length(re);
[mask,probabilities2] =A_random_walker(I,[sub2ind([X Y],re,ce);...
    sub2ind([X Y],rd,cd)],[zeros(le,1);ones(ld,1)]);
% figure,imshow(I); 
% hold on
% plot(ce,re,'b.','MarkerSize',7)
% plot(cd,rd,'r.','MarkerSize',7)
% title('种子点')

% 手动选点
% [sp,sq]=ginput;
% l_s1=length(sp);
% s1x=round(sp); s1y=round(sq);
% plot(s1x,s1y,'r.','MarkerSize',14,'linewidth',3)
% [sm,sn]=ginput;
% l_s2=length(sm);
% s2x=round(sm); s2y=round(sn);
% plot(s2x,s2y,'b.','MarkerSize',14,'linewidth',3)
% [mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x);...
%     sub2ind([X Y],s2y,s2x)],[zeros(l_s1,1);ones(l_s2,1)]);

% figure,imshow(mask)
% hold on
% title('黑白mask');

% 分割边缘
[imgMasks,segOutline,imgMarkup]=segoutput(I,mask);
figure,imshow(imgMarkup);
hold on
title('分割结果图')
toc