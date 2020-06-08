clear all;
close all;
clc

tic
I=imread('001.jpg');
I=rgb2gray(I);

% figure,imhist(I);
% ylim('auto');
% title('�Ҷ�ֱ��ͼ')

I=im2double(I);
I=imresize(I,[800,800]);
% I=imadjust(I); % ��ǿͼ��

a=mean(mean(I)) % ��һ���Ҷ�
b=a*255 % ƽ���Ҷ�
[x,y]=size(I);
c=zeros(x,y);
for i=1:x
    for j=1:y
        c(i,j)=abs(I(i,j)-a); % ��һ��
%         c(i,j)=abs(255*I(i,j)-b);% �ǹ�һ��
    end
end
d=mean(mean(c)) % ���ھ��Բ�

% figure,imshow(I); % ԭͼ
% title('ԭͼ')
 
% level = graythresh(img); 
% level = a-d*((b-100)/100); % mean 6���Ͽ���
level = a*0.93;
% level = 0.60;
A=im2bw(I,level); 
figure,imshow(A,[]); % ��ֵ��ͼ��
title('��ֵ��ͼ')

se = strel('disk', 1); % 'square', 2   'diamond', 1
B = imclose(A,se); % ������ȥ���� ������ȥë��
se0 = strel('square', 2);
B = imopen(B,se0);

B = medfilt2(B,[5,5]); % ��ֵ�˲�
B = medfilt2(B);

% figure,imshow(B); % ȥ������
% title('ȥ������ͼ')

% edg=edge(B);
% figure,imshow(edg);
% title('edge�ָ�ͼ')

se1=strel( 'square', 3); %  'diamond', 1
% se1=[0 1 0
%     1 1 1
%     0 1 0];
C=imdilate(B,se1); % ��ʴ
% figure,imshow(C);
edg1 = edge(C);

se2=strel( 'square', 3); % 'square', 3
D=imerode(B,se2); % ����
% figure,imshow(D);
edg2 = edge(D);

% img=imadjust(img); % ��ǿͼ��
[X, Y]=size(I);
[rd,cd]=find(edg1);
ld=length(rd);
[re,ce]=find(edg2);
le=length(re);
[mask,probabilities2] =A_random_walker(I,[sub2ind([X Y],re,ce);...
    sub2ind([X Y],rd,cd)],[zeros(le,1);ones(ld,1)]);
% figure,imshow(I); 
% hold on
% plot(ce,re,'b.','MarkerSize',7)
% plot(cd,rd,'r.','MarkerSize',7)
% title('���ӵ�')

% �ֶ�ѡ��
% [sp,sq]=ginput;
% l_s1=length(sp);
% s1x=round(sp); s1y=round(sq);
% plot(s1x,s1y,'r.','MarkerSize',14,'linewidth',3)
% [sm,sn]=ginput;
% l_s2=length(sm);
% s2x=round(sm); s2y=round(sn);
% plot(s2x,s2y,'b.','MarkerSize',14,'linewidth',3)
% [mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x);...
%     sub2ind([X Y],s2y,s2x)],[zeros(l_s1,1);ones(l_s2,1)]);

% figure,imshow(mask)
% hold on
% title('�ڰ�mask');

% �ָ��Ե
[imgMasks,segOutline,imgMarkup]=segoutput(I,mask);
figure,imshow(imgMarkup);
hold on
title('�ָ���ͼ')
toc