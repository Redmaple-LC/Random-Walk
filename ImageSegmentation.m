function imt = ImageSegmentation(file, cluster_n, options)
ima = file;
I = im2double(file); 
[x,y] = size(ima);
number = x * y;  % 图像的元素个数numel(I)
data = reshape(I,number,1); %将矩阵元素转换为一列数据
[center, U] = FCMprocess(data,cluster_n,options); %调用FCMData函数进行聚类
% 对于每个元素对不同聚类中心的隶属度，找出最大的那个隶属度
maxU = max(U); % 找出每一列的最大隶属度
temp = sort(center); 
for i = 1:cluster_n; % 按聚类结果分割图像    
% 前面求出每个元素的最大隶属度，属于各聚类中心的元素坐标，并存放这些坐标    
% 调用eval函数将括号里的字符串转化为命令执行    
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
