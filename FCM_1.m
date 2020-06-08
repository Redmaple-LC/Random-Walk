function [center, U, obj_fcn] = FCM(data, cluster_n, options)
% ����FCM(ģ��C��ֵ)�㷨�����ݼ�data��Ϊcluster_n��
% MATLAB�Դ���FCM�㷨��������+ע���������
% by faruto @ faruto's Studio http://blog.sina.com.cn/faruto
% Email:patrick.lee@foxmail.com QQ:516667408
% http://www.matlabsky.com http://www.mfun.la
% last modified 2010.08.21
% �÷���
% 1. [center,U,obj_fcn] = FCM(Data,N_cluster,options);
% 2. [center,U,obj_fcn] = FCM(Data,N_cluster);
%
% ���룺
% data ---- n*m����,��ʾn������,ÿ����������mά����ֵ
% cluster_n ---- ����,��ʾ�ۺ�������Ŀ,�������
% options ---- 4*1������������
% options(1): �����Ⱦ���U��ָ����>1(ȱʡֵ: 2.0)
% options(2): ����������(ȱʡֵ: 100)
% options(3): ��������С�仯��,������ֹ����(ȱʡֵ: 1e-5)
% options(4): ÿ�ε����Ƿ������Ϣ��־(ȱʡֵ: 0)
% �����
% center ---- ��������
% U ---- �����Ⱦ���
% obj_fcn ---- Ŀ�꺯��ֵ
% Example:
% data = rand(100,2);
% options = [2;100;1e-5;1];
% [center,U,obj_fcn] = FCM(data,2,options);
% figure;
% plot(data(:,1), data(:,2),'o');
% title('DemoTest of FCM Cluster');
% xlabel('1st Dimension');
% ylabel('2nd Dimension');
% grid on;
% hold on;
% maxU = max(U);
% index1 = find(U(1,:) == maxU);
% index2 = find(U(2,:) == maxU);
% line(data(index1,1),data(index1,2),'marker','*','color','g');
% line(data(index2,1),data(index2,2),'marker','*','color','r');
% plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
% hold off;
%% ��ʼ��initialization

% ��������������
if nargin ~= 2 && nargin ~= 3 %�ж������������ֻ����2����3��
error('Too many or too few input arguments!');
end

data_n = size(data, 1); % ���data�ĵ�һά(rows)��,����������
data_m = size(data, 2); % ���data�ĵڶ�ά(columns)�������������Ը���
% ����Ĭ�ϲ�������
default_options = ...
[2; % �����Ⱦ���U��ָ��
100; % ����������
1e-5; % ��������С�仯��,������ֹ����
0]; % ÿ�ε����Ƿ������Ϣ��־
if nargin == 2
% ���������������Ƕ���ô�͵���Ĭ�ϵ�option
options = default_options;
else
% ����û�����opition������4����ô������Ĭ��ֵ
if length(options) < 4
tmp = default_options;
tmp(1:length(options)) = options;
options = tmp;
end
% ���options���Ƿ���nanֵ
nan_index = find(isnan(options)==1);
% ��denfault_options�ж�Ӧλ�õĲ�����ֵ��options�в�������λ��.
options(nan_index) = default_options(nan_index);
% ���ģ�������ָ��С�ڵ���1����������
if options(1) <= 1,
error('The exponent should be greater than 1!');
end
end
% ��options�еķ����ֱ�ֵ���ĸ�����
expo = options(1); % �����Ⱦ���U��ָ��
max_iter = options(2); % ����������
min_impro = options(3); % ��������С�仯��,������ֹ����
display = options(4); % ÿ�ε����Ƿ������Ϣ��־

obj_fcn = zeros(max_iter, 1); % ��ʼ���������obj_fcn
U = initfcm(cluster_n, data_n); % ��ʼ��ģ���������,ʹU�����������Ϊ1
%% Main loop ��Ҫѭ��
for i = 1:max_iter
% �ڵ�k��ѭ���иı��������ceneter,�ͷ��亯��U��������ֵ;
[U, center, obj_fcn(i)] = stepfcm(data, U, cluster_n, expo);
if display,
fprintf('FCM:Iteration count = %d, obj.fcn = %f\n', i, obj_fcn(i));
end
% ��ֹ�����б�
if i > 1 && abs(obj_fcn(i) - obj_fcn(i-1)) <= min_impro
break;
end
end
iter_n = i; % ʵ�ʵ�������
obj_fcn(iter_n+1:max_iter) = [];