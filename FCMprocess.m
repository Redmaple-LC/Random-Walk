function [center, U] = FCMprocess(data, cluster_num, options) 
%data为聚类数据,cluster_num为类别数
m = options(1);		% 参数m
max_iteration = options(2);		% 最终的迭代次数
min_deviation = options(3);		% 最小判别误差
data_number = size(data, 1);    % 元素个数
obj_function = zeros(max_iteration, 1); % obj_function用于存放目标函数的值
% 生成隶属度矩阵U
U = rand(cluster_num, data_number); % 随机生成隶属度矩阵U
sumU = sum(U,1);   % 计算U中每列元素和
for k = 1:data_number    
U(:,k) = U(:,k) ./ sumU(k);  % 对隶属矩阵U进行归一化处理
end 

for i = 1:max_iteration	
[U, center, obj_function(i)] = FCMStep(data, U, cluster_num, m); %调用FCMStep函数进行迭代		
fprintf('第%d次迭代, 目标函数值为%f\n', i, obj_function(i));	
% 检查迭代终止条件	
if i > 1,		
if abs(obj_function(i) - obj_function(i-1)) < min_deviation        
break;         
end	
end
end