clear all;
clc;
n=100000;%游走的步数，也是图像中像素个数，所有直接关系到图像的大小，有些位置可能重复，所以白像素小于等于n       
x=0;
y=0;%游走的初始位置           
pixel=zeros(n,2);%游走产生的像素坐标
neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];%游走的八个方向
for i=1:n
    r=floor(1+8*rand());%八邻域随机选一个来走    
    y=y+neighbour(r,1);%y方向游走     
    x=x+neighbour(r,2);%x方向游走，游走时连续的
    pixel(i,:)=[y x];         
end
miny=min(pixel(:,1));         
minx=min(pixel(:,2));%图像坐标不可能为负，所以找最小值再整体提升为正    
 
pixel(:,1)=pixel(:,1)-miny+1;   
pixel(:,2)=pixel(:,2)-minx+1;
 
maxy=max(pixel(:,1));         
maxx=max(pixel(:,2));%找到随机游走得到的图像的大小
  
img=zeros(maxy,maxx);       
for i=1:n                  
    img(pixel(i,1),pixel(i,2))=1;
end
imshow(img)