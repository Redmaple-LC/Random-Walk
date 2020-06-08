close all;                   %关闭当前所有图形窗口
clear all;                   %清空工作空间变量
clc;     
blood = imread('1.jpg');
figure,imshow(blood)
[x,y,z]=size(blood);                % 求出图象大小
I=double(blood);                  
for i=1:x                         % 实际图象的灰度为0～255
    for j=1:y
        if (I(i,j)>255)
            I(i,j)=255;
        end
        if (I(i,j)<0)
            I(i,j)=0;
        end
    end
end    
z0=max(max(I));                   % 求出图象中最大的灰度
z1=min(min(I));                   % 最小的灰度 
T=(z0+z1)/2;                      
TT=0;
S0=0; n0=0;
S1=0; n1=0;
allow=0.5;                       % 新旧阈值的允许接近程度
d=abs(T-TT);
count=0;                         % 记录几次循环
while(d>=allow)                 % 迭代最佳阈值分割算法
    count=count+1;
    for i=1:x
        for j=1:y
            if (I(i,j)>=T)
                S0=S0+I(i,j);
                n0=n0+1;
            end
            if (I(i,j)<T)
                S1=S1+I(i,j);
                n1=n1+1;
            end
        end
    end 
    T0=S0/n0;
    T1=S1/n1;
    TT=(T0+T1)/2;
    d=abs(T-TT);
    T=TT;
end
Seg=zeros(x,y);
for i=1:x
    for j=1:y
        if(I(i,j)>=T)
            Seg(i,j)=1;               % 阈值分割的图象
        end
    end
end
% SI=1-Seg;                            % 阈值分割后的图象求反，便于用腐蚀算法求边缘
S=Seg;
B1=[0 1 0
    1 1 1
    0 1 0];
B2=[0 0 1 0 0
    0 1 1 1 0
    1 1 1 1 1
    0 1 1 1 0
    0 0 1 0 0];
S1=imopen(S,B2);
S2=imclose(S1,B2);
S3=imdilate(S2,B1);
S4=imerode(S2,B1);
% se1=strel('square',3);               % 定义腐蚀算法的结构‘suqare’为正方形‘disk’为圆盘
% SI1=imerode(SI,se1);                 % 腐蚀算法

% BW=SI-SI1;                           % 边缘检测
BW=S3-S4;                       
%=====传统的边缘检测方法======%
I=uint8(I);
BW1=edge(S,'prewitt', 0.11);
BW2=edge(S,'canny', 0.1);
%===========图象显示==========%
figure(1);
imshow(I);title('Original') 
figure(2)
imshow(S);title('2zhihua') % 显示阈值分割的图象
figure(3);
imshow(BW2);title('prewitt')                       
figure(4)
imshow(BW1);title('canny') 
figure(5)
imshow(BW);title('New algorithm')% 显示新算法的边缘图象