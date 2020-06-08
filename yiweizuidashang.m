%一维最大熵法
E = imread('01.jpg');
E = rgb2gray(E);
vHist=imhist(E);
[m,n]=size(E);
p=vHist(find(vHist>0))/(m*n);%求每一不为零的灰度值的概率
Pt=cumsum(p);%计算出选择不同t值时，A区域的概率
Ht=-cumsum(p.*log(p));%计算出选择不同t值时，A区域的熵
HL=-sum(p.*log(p));%计算出全图的熵
Yt=log(Pt.*(1-Pt)+eps)+Ht./(Pt+eps)+(HL-Ht)./(1-Pt+eps);%计算出选择不同t值时，判别函数的值
[a,th]=max(Yt);%th即为最佳阈值
segImg=(E>th);
th
figure,imshow(segImg)

 