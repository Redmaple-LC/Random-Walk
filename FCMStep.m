function [newU,center,obj_function] = FCMStep(data, U, cluster_num, m)
% data为被聚类数据,U为隶属度矩阵,cluster_num为聚类类别数,m为FCM中的参数m
% 函数调用后得到新的隶属度矩阵newU,聚类中心center,目标函数值obj_function 
%以下是计算模糊隶属度Ut    
[x,y] = size(U);    
A = ones(x,y);          
a = 0.85;            
Ut = abs(A - U -(A - (U).^a).^(1/a));            
Ud = U  + Ut;            
[j,k,l] = size(data);            
pp =  y;            
pai = (sum(Ut,2)) ./pp;            
obj = sum(pai.*exp(1-pai)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%         Ud = U;            
%         obj = 0; 
nf = Ud;
mf = Ud.^m;       % FMC中的U^m
%  center = nf*data./((ones(size(data, 2), 1)*sum(nf'))'); % 得到聚类中心    data1 = zeros(x,y);   
data1(1,:) = data';   
data1(2,:) = data';   
data1(3,:) = data';   
data1(4,:) = data';
%   data1(5,:) = data';  
center = sum(nf.*data1,2)./sum(nf,2); % 得到聚类中心

dist = Distance(center, data);      % 调用myfcmdist函数计算聚类中心与被聚类数据的距离
obj_function = sum(sum((dist.^2).*mf))+obj;  % 得到目标函数值
tmp = dist.^(-2/(m-1));      % 如果迭代次数不为1,计算新的隶属度矩阵 
newU = tmp./(ones(cluster_num, 1)*sum(tmp)); % U_new为新的隶属度矩阵