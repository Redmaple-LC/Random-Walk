clear all;
clc;
n=100000;%���ߵĲ�����Ҳ��ͼ�������ظ���������ֱ�ӹ�ϵ��ͼ��Ĵ�С����Щλ�ÿ����ظ������԰�����С�ڵ���n       
x=0;
y=0;%���ߵĳ�ʼλ��           
pixel=zeros(n,2);%���߲�������������
neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];%���ߵİ˸�����
for i=1:n
    r=floor(1+8*rand());%���������ѡһ������    
    y=y+neighbour(r,1);%y��������     
    x=x+neighbour(r,2);%x�������ߣ�����ʱ������
    pixel(i,:)=[y x];         
end
miny=min(pixel(:,1));         
minx=min(pixel(:,2));%ͼ�����겻����Ϊ������������Сֵ����������Ϊ��    
 
pixel(:,1)=pixel(:,1)-miny+1;   
pixel(:,2)=pixel(:,2)-minx+1;
 
maxy=max(pixel(:,1));         
maxx=max(pixel(:,2));%�ҵ�������ߵõ���ͼ��Ĵ�С
  
img=zeros(maxy,maxx);       
for i=1:n                  
    img(pixel(i,1),pixel(i,2))=1;
end
imshow(img)