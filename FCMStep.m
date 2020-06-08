function [newU,center,obj_function] = FCMStep(data, U, cluster_num, m)
% dataΪ����������,UΪ�����Ⱦ���,cluster_numΪ���������,mΪFCM�еĲ���m
% �������ú�õ��µ������Ⱦ���newU,��������center,Ŀ�꺯��ֵobj_function 
%�����Ǽ���ģ��������Ut    
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
mf = Ud.^m;       % FMC�е�U^m
%  center = nf*data./((ones(size(data, 2), 1)*sum(nf'))'); % �õ���������    data1 = zeros(x,y);   
data1(1,:) = data';   
data1(2,:) = data';   
data1(3,:) = data';   
data1(4,:) = data';
%   data1(5,:) = data';  
center = sum(nf.*data1,2)./sum(nf,2); % �õ���������

dist = Distance(center, data);      % ����myfcmdist����������������뱻�������ݵľ���
obj_function = sum(sum((dist.^2).*mf))+obj;  % �õ�Ŀ�꺯��ֵ
tmp = dist.^(-2/(m-1));      % �������������Ϊ1,�����µ������Ⱦ��� 
newU = tmp./(ones(cluster_num, 1)*sum(tmp)); % U_newΪ�µ������Ⱦ���