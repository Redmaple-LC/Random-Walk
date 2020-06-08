clear all
a=imread('037.jpg');
a = rgb2gray(a);
imshow(a)
count=imhist(a);
[m,n]=size(a);
N=m*n;
L=256;
count=count/N;%%每一个像素的分布概率
count

for i=1:L
    if count(i)~=0
        st=i-1;
        break;
    end
end
st
for i=L:-1:1
    if count(i)~=0
        nd=i-1;
        break;
    end
end
nd
f=count(st+1:nd+1);  %f是每个灰度出现的概率
size(f)
E=[];
for Th=st:nd-1   %%%设定初始分割阈值为Th
av1=0;
av2=0;
Pth=sum(count(1:Th+1));
%%%第一类的平均相对熵为
for i=0:Th
    av1=av1-count(i+1)/Pth*log(count(i+1)/Pth+0.00001);
end
%%%第二类的平均相对熵为
for i=Th+1:L-1
    av2=av2-count(i+1)/(1-Pth)*log(count(i+1)/(1-Pth)+0.00001);
end
E(Th-st+1)=av1+av2;
end
position=find(E==(max(E)));
th=st+position-1

 for i=1:m
    for j=1:n
        if a(i,j)>th
            a(i,j)=255;
        else
            a(i,j)=0;
        end
    end
end 
figure,imshow(E);
