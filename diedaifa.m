close all;%�ر����д���  
clear;%���������״̬����  
clc;%���������  
tic
I=imread('01.jpg');  
subplot(1,2,1);  
imshow(I);  
title('ԭͼ');  

%����ʽ��ֵ�ָ�   
zmax=max(max(I));%ȡ�����Ҷ�ֵ  
zmin=min(min(I));%ȡ����С�Ҷ�ֵ  
tk=(zmax+zmin)/2;  
bcal=1;  
[m,n]=size(I);  
while(bcal)  
    %����ǰ���ͱ�����  
    iforeground=0;  
    ibackground=0;  
    %����ǰ���ͱ����Ҷ��ܺ�  
    foregroundsum=0;  
    backgroundsum=0;  
    for i=1:m  
        for j=1:n  
            tmp=I(i,j);  
            if(tmp>=tk)  
                %ǰ���Ҷ�ֵ  
                iforeground=iforeground+1;  
                foregroundsum=foregroundsum+double(tmp);  
            else  
                ibackground=ibackground+1;  
                backgroundsum=backgroundsum+double(tmp);  
            end  
        end  
    end  
    %����ǰ���ͱ�����ƽ��ֵ  
    z1=foregroundsum/iforeground;  
    z2=foregroundsum/ibackground;  
    tktmp=uint8((z1+z2)/2);  
    if(tktmp==tk)  
        bcal=0;  
    else  
        tk=tktmp;  
    end  
    %����ֵ���ٱ仯ʱ,˵����������  
end  
disp(strcat('��������ֵ:',num2str(tk)));%��command window����ʾ�� :��������ֵ:��ֵ  
newI=im2bw(I,double(tk)/255);%����im2bwʹ����ֵ��threshold���任���ѻҶ�ͼ��grayscale image��
figure,imshow(newI)

se0 = strel('square', 2);
B = imopen(newI,se0); %������
figure,imshow(B)
title('������ȥ��ë��')


toc