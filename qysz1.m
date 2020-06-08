% 区域生长
clear all;
close all;
clc;
A=imread('9.jpg');
I=rgb2gray(A);
figure,imshow(I),title('原始图像')
I=double(I);
[M,N]=size(I);
[y,x]=getpts;             %获得区域生长起始点
x1=round(x);            %横坐标取整
y1=round(y);            %纵坐标取整
seed=I(x1,y1);           %将生长起始点灰度值存入seed中
Y=zeros(M,N);          %作一个全零与原图像等大的图像矩阵Y，作为输出图像矩阵
Y(x1,y1)=1;             %将Y中与所取点相对应位置的点设置为白场
sum=seed;              %储存符合区域生长条件的点的灰度值的和
suit=1;                 %储存符合区域生长条件的点的个数
count=1;               %记录每次判断一点周围八点符合条件的新点的数目
threshold=15;       %域值
while count>0
s=0;                  %记录判断一点周围八点时，符合条件的新点的灰度值之和
count=0;
for i=1:M
   for j=1:N
     if Y(i,j)==1
      if (i-1)>0 && (i+1)<(M+1) && (j-1)>0 && (j+1)<(N+1) %判断此点是否为图像边界上的点
       for u= -1:1                               %判断点周围八点是否符合域值条件
        for v= -1:1                               %u,v为偏移量
          if Y(i+u,j+v)==0 && abs(I(i+u,j+v)-seed)<=threshold && 1/(1+1/15*abs(I(i+u,j+v)-seed))>0.8%判断是否未存在于输出矩阵Y，并且为符合域值条件的点
             Y(i+u,j+v)=1;                       %符合以上两条件即将其在Y中与之位置对应的点设置为白场
             count=count+1;                                 
             s=s+I(i+u,j+v);                      %此点的灰度之加入s中
          end
        end  
       end
      end
     end
   end
end
suit=suit+count;                                   %将n加入符合点数计数器中
sum=sum+s;                                     %将s加入符合点的灰度值总合中
seed=sum/suit;                                    %计算新的灰度平均值
end
figure,imshow(Y),title('分割后图像')