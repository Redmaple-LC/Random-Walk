close all;                   % �ر�����ͼ�δ���
clear all;                   % ��չ�����
clc;                         % ��������д���

% ��ǿ+С��ά��ȥ��           
I=imread('01.jpg');               
 I=rgb2gray(I);
I=imadjust(I);
figure(1); 
imshow(I); 
title('��ǿͼ��');                            
I=double(I);  

[c,s]=wavedec2(I,1,'coif2');
a3=appcoef2(c,s,'coif2',1);%��ȡ��Ƶϵ��
d3=detcoef2('h',c,s,1);    %��ȡ��һ��ĵ�Ƶϵ��
d2=detcoef2('v',c,s,1);
d1=detcoef2('d',c,s,1);
cc=[a3,d3,d2,d1];

%ά���˲�
cD1=wiener2(d1,[8 8]);
cD2=wiener2(d2,[8 8]);
cD3=wiener2(d3,[8 8]);
A3=wiener2(a3,[3 3]);

%��������ɢ�˲�
%cD1 = anisodiff(I,40,15,0.25,1);
%cD2 = anisodiff(I,40,15,0.25,1);
%cD3 = anisodiff(I,40,15,0.25,1);
%A3 = anisodiff(I,40,15,0.25,1);

cd=[A3,cD3,cD2,cD1];
xs=waverec2(cd,s,'coif2');%�ع�
figure(2);
imshow(uint8(xs));
title('ά��С��ȥ��');

img=im2double(uint8(xs)); % im2double ˫�����ͣ�0-1��double double�ͣ�0-255��rgb2gray uint8�ͣ�0-255��
[X, Y]=size(img);
% figur(3);
% imshow(img);
% colormap('gray')
% axis equal  
% axis tight  
% axis off    
% hold on
% title('ԭʼͼ��');

% ��������ϵ
figure(3);
imshow(img);
colormap('gray')
axis equal  % ����̶�һ��
axis tight  % ����ϵ�����ݷ�Χһ��
axis on    % ����ϵ��ʾ�ر�
hold on
title('�ֶ�ѡ�����');

% Ŀ�����ӵ�
% sq=[93;98;98;110;110;125;125;140;140;160];
% sp=[158;160;175;170;185;175;185;175;185;170];
[sp,sq]=ginput;   % �ֶ�����
l_s1=length(sp);  % ���ҵ������
s1x=round(sp); s1y=round(sq); % ����������Ϊ����
plot(s1x,s1y,'r.','MarkerSize',14,'linewidth',3) % ��ʾ������

% �������ӵ�
% sn=[97;103;113;125;145;165;175;165;145;120;100;85;85;80];
% sm=[151;155;155;160;160;160;170;185;195;195;190;180;165;155];
[sm,sn]=ginput;
l_s2=length(sm);
s2x=round(sm); s2y=round(sn);
plot(s2x,s2y,'b.','MarkerSize',14,'linewidth',3)

% һ��������� maskΪ��ɫ����
[mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x);...
    sub2ind([X Y],s2y,s2x)],[zeros(l_s1,1);ones(l_s2,1)]);

% ��ʾ�ڰ���ģ
figure(4);
imshow(mask)
colormap('gray')
axis equal
axis tight
axis off
hold on
% plot(s1x,s1y,'g.','MarkerSize',16)
% plot(s2x,s2y,'b.','MarkerSize',16)
title('һ��RW��ģ');

% ��ʾһ�ηָ��Ե
edg = edge(mask); % ��Ե�ߺ��Ϊ1����
% figure(10),imshow(edg);
[imgMasks,segOutline,imgMarkup]=segoutput(img,mask); % �ָ��Ե
figure(5);
imshow(imgMarkup);
% imshow(edg); % ��ʾ��Ե���ڶ�ֵ��ͼ��
colormap('gray')
axis equal
axis tight
axis off
hold on
title('һ��RW��Ե')

% ����ģ���͸�ʴ
bw=~mask; % ~Ϊ�ǵ���˼
se=strel('disk',3); % ���� ��ȡ�߿�5
fd=imdilate(bw,se);
se=strel('disk',5); % ��ʴ ��ȡ�߿�8
fe=imerode(fd,se);

%��¼���͸�ʴ��ı�Ե
% f2=fe&~bw;
edg1=edge(fd); % ���ͱ�Ե
[rd,cd]=find(edg1);
ld=length(rd); % ��¼�������ӵ�

edg2=edge(fe); % ��ʴ��Ե
[re,ce]=find(edg2);
le=length(re); % ��¼Ŀ�����ӵ�

% �����������
[mask2,probabilities2] = random_walker(img,[sub2ind([X Y],re,ce);...
    sub2ind([X Y],rd,cd)],[zeros(le,1);ones(ld,1)]);
% ��ʾ���͸�ʴ������
figure(6);
imshow(img);
colormap('gray')
axis equal
axis tight
axis off
hold on
plot(ce,re,'w.','MarkerSize',7) % ��ʾ���ӵ㣬����ʾ���͸�ʴ��Ե
plot(cd,rd,'k.','MarkerSize',7)
title('����RW���ӵ�')

% ��ʾ���ηָ��Ե
[imgMasks2,segOutline2,imgMarkup2]=segoutput(img,mask2); % �ָ��Ե
figure(7);
imshow(imgMarkup2);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('����RW��Ե')

% ��ʾ�߿�
figure(8);
imshow(mask2);
title('�߿���ģ');

bw2=~mask2; % ѡȡ����ģ
result=img.*bw2; % �ǰ߿�������ʾΪ��ɫ
figure(9);
imshow(result);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('�߿�����ڵ�')

result2=mask2+result; % �ǰ߿�������ʾΪ��ɫ
figure(10);
imshow(result2);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('�߿�����׵�')
