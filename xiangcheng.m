A=imread('01.jpg');%读取原图像
B=rgb2gray(A);%将原图像转换为灰度图像
t=graythresh(B);%计算阈值t
C=im2bw(B,t);%根据阈值二值化图像
D=imfill(C,8,'holes');%对二值化后的图像填充肺实质
E=D-C;%得到肺实质的图像E
F=imfill(E,8,'holes');%填充肺实质空洞
B=double(B); %%%%%%%%%%%%%%%注意这个地方，必须换成double类型
G=B.*F;
imshow(A);figure,imshow(G);
