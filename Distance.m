function out = Distance(center, data)     

data_number = size(data,1);  
class_number = size(center, 1);  
kk = ones(data_number,1); % ���������ݴ�С��ͬ��ȫ1����kk  
out = zeros(class_number, data_number);   
if size(center, 2) > 1, %�����������1       
for k = 1:class_number         
out(k, :) = sqrt(sum(((data - kk...                        
*center(k,:)).^2)'));      
end   
else % dataΪһά����       
for k = 1:class_number         
out(k, :) = abs(center(k) - data)';       
end   
end