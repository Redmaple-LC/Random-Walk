A=imread('01.jpg');%��ȡԭͼ��
B=rgb2gray(A);%��ԭͼ��ת��Ϊ�Ҷ�ͼ��
t=graythresh(B);%������ֵt
C=im2bw(B,t);%������ֵ��ֵ��ͼ��
D=imfill(C,8,'holes');%�Զ�ֵ�����ͼ������ʵ��
E=D-C;%�õ���ʵ�ʵ�ͼ��E
F=imfill(E,8,'holes');%����ʵ�ʿն�
B=double(B); %%%%%%%%%%%%%%%ע������ط������뻻��double����
G=B.*F;
imshow(A);figure,imshow(G);
