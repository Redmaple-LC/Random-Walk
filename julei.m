ima = imread('03.jpg');
% ���趨FCM�ļ�����ʼ����
options=[2;20;1e-5]	% FCM��ʽ�еĲ���m % ����������	% Ŀ�꺯������С���		 
class_number = 4;  % ��Ϊ4��
imt = ImageSegmentation(ima,class_number,options)
%subplot(1,2,1),
imshow(ima),title('ԭͼ');
%subplot(1,2,2),
figure,imshow(imt); %��ʾ���ɵķָ��ͼ��
%kk = strcat('�ָ��',int2str(class_number),'������ͼ��');
title(kk);
