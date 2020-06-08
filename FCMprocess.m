function [center, U] = FCMprocess(data, cluster_num, options) 
%dataΪ��������,cluster_numΪ�����
m = options(1);		% ����m
max_iteration = options(2);		% ���յĵ�������
min_deviation = options(3);		% ��С�б����
data_number = size(data, 1);    % Ԫ�ظ���
obj_function = zeros(max_iteration, 1); % obj_function���ڴ��Ŀ�꺯����ֵ
% ���������Ⱦ���U
U = rand(cluster_num, data_number); % ������������Ⱦ���U
sumU = sum(U,1);   % ����U��ÿ��Ԫ�غ�
for k = 1:data_number    
U(:,k) = U(:,k) ./ sumU(k);  % ����������U���й�һ������
end 

for i = 1:max_iteration	
[U, center, obj_function(i)] = FCMStep(data, U, cluster_num, m); %����FCMStep�������е���		
fprintf('��%d�ε���, Ŀ�꺯��ֵΪ%f\n', i, obj_function(i));	
% ��������ֹ����	
if i > 1,		
if abs(obj_function(i) - obj_function(i-1)) < min_deviation        
break;         
end	
end
end