%һά����ط�
E = imread('01.jpg');
E = rgb2gray(E);
vHist=imhist(E);
[m,n]=size(E);
p=vHist(find(vHist>0))/(m*n);%��ÿһ��Ϊ��ĻҶ�ֵ�ĸ���
Pt=cumsum(p);%�����ѡ��ͬtֵʱ��A����ĸ���
Ht=-cumsum(p.*log(p));%�����ѡ��ͬtֵʱ��A�������
HL=-sum(p.*log(p));%�����ȫͼ����
Yt=log(Pt.*(1-Pt)+eps)+Ht./(Pt+eps)+(HL-Ht)./(1-Pt+eps);%�����ѡ��ͬtֵʱ���б�����ֵ
[a,th]=max(Yt);%th��Ϊ�����ֵ
segImg=(E>th);
th
figure,imshow(segImg)

 