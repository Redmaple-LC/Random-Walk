close all;                   %�رյ�ǰ����ͼ�δ���
clear all;                   %��չ����ռ����
clc;     
blood = imread('1.jpg');
figure,imshow(blood)
[x,y,z]=size(blood);                % ���ͼ���С
I=double(blood);                  
for i=1:x                         % ʵ��ͼ��ĻҶ�Ϊ0��255
    for j=1:y
        if (I(i,j)>255)
            I(i,j)=255;
        end
        if (I(i,j)<0)
            I(i,j)=0;
        end
    end
end    
z0=max(max(I));                   % ���ͼ�������ĻҶ�
z1=min(min(I));                   % ��С�ĻҶ� 
T=(z0+z1)/2;                      
TT=0;
S0=0; n0=0;
S1=0; n1=0;
allow=0.5;                       % �¾���ֵ������ӽ��̶�
d=abs(T-TT);
count=0;                         % ��¼����ѭ��
while(d>=allow)                 % ���������ֵ�ָ��㷨
    count=count+1;
    for i=1:x
        for j=1:y
            if (I(i,j)>=T)
                S0=S0+I(i,j);
                n0=n0+1;
            end
            if (I(i,j)<T)
                S1=S1+I(i,j);
                n1=n1+1;
            end
        end
    end 
    T0=S0/n0;
    T1=S1/n1;
    TT=(T0+T1)/2;
    d=abs(T-TT);
    T=TT;
end
Seg=zeros(x,y);
for i=1:x
    for j=1:y
        if(I(i,j)>=T)
            Seg(i,j)=1;               % ��ֵ�ָ��ͼ��
        end
    end
end
% SI=1-Seg;                            % ��ֵ�ָ���ͼ���󷴣������ø�ʴ�㷨���Ե
S=Seg;
B1=[0 1 0
    1 1 1
    0 1 0];
B2=[0 0 1 0 0
    0 1 1 1 0
    1 1 1 1 1
    0 1 1 1 0
    0 0 1 0 0];
S1=imopen(S,B2);
S2=imclose(S1,B2);
S3=imdilate(S2,B1);
S4=imerode(S2,B1);
% se1=strel('square',3);               % ���帯ʴ�㷨�Ľṹ��suqare��Ϊ�����Ρ�disk��ΪԲ��
% SI1=imerode(SI,se1);                 % ��ʴ�㷨

% BW=SI-SI1;                           % ��Ե���
BW=S3-S4;                       
%=====��ͳ�ı�Ե��ⷽ��======%
I=uint8(I);
BW1=edge(S,'prewitt', 0.11);
BW2=edge(S,'canny', 0.1);
%===========ͼ����ʾ==========%
figure(1);
imshow(I);title('Original') 
figure(2)
imshow(S);title('2zhihua') % ��ʾ��ֵ�ָ��ͼ��
figure(3);
imshow(BW2);title('prewitt')                       
figure(4)
imshow(BW1);title('canny') 
figure(5)
imshow(BW);title('New algorithm')% ��ʾ���㷨�ı�Եͼ��