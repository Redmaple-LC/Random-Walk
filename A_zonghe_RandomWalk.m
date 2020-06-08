close all;                   % 关闭所有图形窗口
clear all;                   % 清空工作区
clc;                         % 清空命令行窗口

% 增强+小波维纳去噪           
I=imread('01.jpg');               
 I=rgb2gray(I);
I=imadjust(I);
figure(1); 
imshow(I); 
title('增强图像');                            
I=double(I);  

[c,s]=wavedec2(I,1,'coif2');
a3=appcoef2(c,s,'coif2',1);%提取高频系数
d3=detcoef2('h',c,s,1);    %提取第一层的低频系数
d2=detcoef2('v',c,s,1);
d1=detcoef2('d',c,s,1);
cc=[a3,d3,d2,d1];

%维纳滤波
cD1=wiener2(d1,[8 8]);
cD2=wiener2(d2,[8 8]);
cD3=wiener2(d3,[8 8]);
A3=wiener2(a3,[3 3]);

%非线性扩散滤波
%cD1 = anisodiff(I,40,15,0.25,1);
%cD2 = anisodiff(I,40,15,0.25,1);
%cD3 = anisodiff(I,40,15,0.25,1);
%A3 = anisodiff(I,40,15,0.25,1);

cd=[A3,cD3,cD2,cD1];
xs=waverec2(cd,s,'coif2');%重构
figure(2);
imshow(uint8(xs));
title('维纳小波去噪');

img=im2double(uint8(xs)); % im2double 双精度型（0-1）double double型（0-255）rgb2gray uint8型（0-255）
[X, Y]=size(img);
% figur(3);
% imshow(img);
% colormap('gray')
% axis equal  
% axis tight  
% axis off    
% hold on
% title('原始图像');

% 建立坐标系
figure(3);
imshow(img);
colormap('gray')
axis equal  % 坐标刻度一致
axis tight  % 坐标系和数据范围一致
axis on    % 坐标系显示关闭
hold on
title('手动选点界面');

% 目标种子点
% sq=[93;98;98;110;110;125;125;140;140;160];
% sp=[158;160;175;170;185;175;185;175;185;170];
[sp,sq]=ginput;   % 手动画点
l_s1=length(sp);  % 查找点的数量
s1x=round(sp); s1y=round(sq); % 将点的坐标归为整数
plot(s1x,s1y,'r.','MarkerSize',14,'linewidth',3) % 显示所画点

% 背景种子点
% sn=[97;103;113;125;145;165;175;165;145;120;100;85;85;80];
% sm=[151;155;155;160;160;160;170;185;195;195;190;180;165;155];
[sm,sn]=ginput;
l_s2=length(sm);
s2x=round(sm); s2y=round(sn);
plot(s2x,s2y,'b.','MarkerSize',14,'linewidth',3)

% 一次随机游走 mask为黑色部分
[mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x);...
    sub2ind([X Y],s2y,s2x)],[zeros(l_s1,1);ones(l_s2,1)]);

% 显示黑白掩模
figure(4);
imshow(mask)
colormap('gray')
axis equal
axis tight
axis off
hold on
% plot(s1x,s1y,'g.','MarkerSize',16)
% plot(s2x,s2y,'b.','MarkerSize',16)
title('一次RW掩模');

% 显示一次分割边缘
edg = edge(mask); % 边缘线厚度为1像素
% figure(10),imshow(edg);
[imgMasks,segOutline,imgMarkup]=segoutput(img,mask); % 分割边缘
figure(5);
imshow(imgMarkup);
% imshow(edg); % 显示边缘，在二值化图上
colormap('gray')
axis equal
axis tight
axis off
hold on
title('一次RW边缘')

% 对掩模膨胀腐蚀
bw=~mask; % ~为非的意思
se=strel('disk',3); % 膨胀 提取斑块5
fd=imdilate(bw,se);
se=strel('disk',5); % 腐蚀 提取斑块8
fe=imerode(fd,se);

%记录膨胀腐蚀后的边缘
% f2=fe&~bw;
edg1=edge(fd); % 膨胀边缘
[rd,cd]=find(edg1);
ld=length(rd); % 记录背景种子点

edg2=edge(fe); % 腐蚀边缘
[re,ce]=find(edg2);
le=length(re); % 记录目标种子点

% 二次随机游走
[mask2,probabilities2] = random_walker(img,[sub2ind([X Y],re,ce);...
    sub2ind([X Y],rd,cd)],[zeros(le,1);ones(ld,1)]);
% 显示膨胀腐蚀轮廓线
figure(6);
imshow(img);
colormap('gray')
axis equal
axis tight
axis off
hold on
plot(ce,re,'w.','MarkerSize',7) % 显示种子点，即显示膨胀腐蚀边缘
plot(cd,rd,'k.','MarkerSize',7)
title('二次RW种子点')

% 显示二次分割边缘
[imgMasks2,segOutline2,imgMarkup2]=segoutput(img,mask2); % 分割边缘
figure(7);
imshow(imgMarkup2);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('二次RW边缘')

% 显示斑块
figure(8);
imshow(mask2);
title('斑块掩模');

bw2=~mask2; % 选取非掩模
result=img.*bw2; % 非斑块区域显示为黑色
figure(9);
imshow(result);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('斑块区域黑底')

result2=mask2+result; % 非斑块区域显示为白色
figure(10);
imshow(result2);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('斑块区域白底')
