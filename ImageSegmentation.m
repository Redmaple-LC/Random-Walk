function imt = ImageSegmentation(file, cluster_n, options)
ima = file;
I = im2double(file); 
[x,y] = size(ima);
number = x * y;  % ͼ���Ԫ�ظ���numel(I)
data = reshape(I,number,1); %������Ԫ��ת��Ϊһ������
[center, U] = FCMprocess(data,cluster_n,options); %����FCMData�������о���
% ����ÿ��Ԫ�ضԲ�ͬ�������ĵ������ȣ��ҳ������Ǹ�������
maxU = max(U); % �ҳ�ÿһ�е����������
temp = sort(center); 
for i = 1:cluster_n; % ���������ָ�ͼ��    
% ǰ�����ÿ��Ԫ�ص���������ȣ����ڸ��������ĵ�Ԫ�����꣬�������Щ����    
% ����eval��������������ַ���ת��Ϊ����ִ��    
eval(['class_',int2str(i), '= find(U(', int2str(i), ',:) == maxU);']);     
%gray = round(255 * (i-1) / (cluster_n-1));        
index = find(temp == center(i));     
switch index         
case 1             
gray = 0;         
case cluster_n             
gray = 255;         
otherwise             
gray = fix(255*(index-1)/(cluster_n-1));     
end     
eval(['I(class_',int2str(i), '(:))=', int2str(gray),';']); 
end; 
imt = mat2gray(I);
