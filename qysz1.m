% ��������
clear all;
close all;
clc;
A=imread('9.jpg');
I=rgb2gray(A);
figure,imshow(I),title('ԭʼͼ��')
I=double(I);
[M,N]=size(I);
[y,x]=getpts;             %�������������ʼ��
x1=round(x);            %������ȡ��
y1=round(y);            %������ȡ��
seed=I(x1,y1);           %��������ʼ��Ҷ�ֵ����seed��
Y=zeros(M,N);          %��һ��ȫ����ԭͼ��ȴ��ͼ�����Y����Ϊ���ͼ�����
Y(x1,y1)=1;             %��Y������ȡ�����Ӧλ�õĵ�����Ϊ�׳�
sum=seed;              %��������������������ĵ�ĻҶ�ֵ�ĺ�
suit=1;                 %��������������������ĵ�ĸ���
count=1;               %��¼ÿ���ж�һ����Χ�˵�����������µ����Ŀ
threshold=15;       %��ֵ
while count>0
s=0;                  %��¼�ж�һ����Χ�˵�ʱ�������������µ�ĻҶ�ֵ֮��
count=0;
for i=1:M
   for j=1:N
     if Y(i,j)==1
      if (i-1)>0 && (i+1)<(M+1) && (j-1)>0 && (j+1)<(N+1) %�жϴ˵��Ƿ�Ϊͼ��߽��ϵĵ�
       for u= -1:1                               %�жϵ���Χ�˵��Ƿ������ֵ����
        for v= -1:1                               %u,vΪƫ����
          if Y(i+u,j+v)==0 && abs(I(i+u,j+v)-seed)<=threshold && 1/(1+1/15*abs(I(i+u,j+v)-seed))>0.8%�ж��Ƿ�δ�������������Y������Ϊ������ֵ�����ĵ�
             Y(i+u,j+v)=1;                       %����������������������Y����֮λ�ö�Ӧ�ĵ�����Ϊ�׳�
             count=count+1;                                 
             s=s+I(i+u,j+v);                      %�˵�ĻҶ�֮����s��
          end
        end  
       end
      end
     end
   end
end
suit=suit+count;                                   %��n������ϵ�����������
sum=sum+s;                                     %��s������ϵ�ĻҶ�ֵ�ܺ���
seed=sum/suit;                                    %�����µĻҶ�ƽ��ֵ
end
figure,imshow(Y),title('�ָ��ͼ��')