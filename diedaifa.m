close all;%关闭所有窗口  
clear;%清除变量的状态数据  
clc;%清除命令行  
tic
I=imread('01.jpg');  
subplot(1,2,1);  
imshow(I);  
title('原图');  

%迭代式阈值分割   
zmax=max(max(I));%取出最大灰度值  
zmin=min(min(I));%取出最小灰度值  
tk=(zmax+zmin)/2;  
bcal=1;  
[m,n]=size(I);  
while(bcal)  
    %定义前景和背景数  
    iforeground=0;  
    ibackground=0;  
    %定义前景和背景灰度总和  
    foregroundsum=0;  
    backgroundsum=0;  
    for i=1:m  
        for j=1:n  
            tmp=I(i,j);  
            if(tmp>=tk)  
                %前景灰度值  
                iforeground=iforeground+1;  
                foregroundsum=foregroundsum+double(tmp);  
            else  
                ibackground=ibackground+1;  
                backgroundsum=backgroundsum+double(tmp);  
            end  
        end  
    end  
    %计算前景和背景的平均值  
    z1=foregroundsum/iforeground;  
    z2=foregroundsum/ibackground;  
    tktmp=uint8((z1+z2)/2);  
    if(tktmp==tk)  
        bcal=0;  
    else  
        tk=tktmp;  
    end  
    %当阈值不再变化时,说明迭代结束  
end  
disp(strcat('迭代的阈值:',num2str(tk)));%在command window里显示出 :迭代的阈值:阈值  
newI=im2bw(I,double(tk)/255);%函数im2bw使用阈值（threshold）变换法把灰度图像（grayscale image）
figure,imshow(newI)

se0 = strel('square', 2);
B = imopen(newI,se0); %开运算
figure,imshow(B)
title('开运算去除毛刺')


toc