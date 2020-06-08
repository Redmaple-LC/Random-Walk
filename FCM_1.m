function [center, U, obj_fcn] = FCM(data, cluster_n, options)
% 采用FCM(模糊C均值)算法将数据集data聚为cluster_n类
% MATLAB自带的FCM算法整合整理+注释详解整理
% by faruto @ faruto's Studio http://blog.sina.com.cn/faruto
% Email:patrick.lee@foxmail.com QQ:516667408
% http://www.matlabsky.com http://www.mfun.la
% last modified 2010.08.21
% 用法：
% 1. [center,U,obj_fcn] = FCM(Data,N_cluster,options);
% 2. [center,U,obj_fcn] = FCM(Data,N_cluster);
%
% 输入：
% data ---- n*m矩阵,表示n个样本,每个样本具有m维特征值
% cluster_n ---- 标量,表示聚合中心数目,即类别数
% options ---- 4*1列向量，其中
% options(1): 隶属度矩阵U的指数，>1(缺省值: 2.0)
% options(2): 最大迭代次数(缺省值: 100)
% options(3): 隶属度最小变化量,迭代终止条件(缺省值: 1e-5)
% options(4): 每次迭代是否输出信息标志(缺省值: 0)
% 输出：
% center ---- 聚类中心
% U ---- 隶属度矩阵
% obj_fcn ---- 目标函数值
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
%% 初始化initialization

% 输入参数数量检测
if nargin ~= 2 && nargin ~= 3 %判断输入参数个数只能是2个或3个
error('Too many or too few input arguments!');
end

data_n = size(data, 1); % 求出data的第一维(rows)数,即样本个数
data_m = size(data, 2); % 求出data的第二维(columns)数，即特征属性个数
% 设置默认操作参数
default_options = ...
[2; % 隶属度矩阵U的指数
100; % 最大迭代次数
1e-5; % 隶属度最小变化量,迭代终止条件
0]; % 每次迭代是否输出信息标志
if nargin == 2
% 如果输入参数个数是二那么就调用默认的option
options = default_options;
else
% 如果用户给的opition数少于4个那么其他用默认值
if length(options) < 4
tmp = default_options;
tmp(1:length(options)) = options;
options = tmp;
end
% 检测options中是否有nan值
nan_index = find(isnan(options)==1);
% 将denfault_options中对应位置的参数赋值给options中不是数的位置.
options(nan_index) = default_options(nan_index);
% 如果模糊矩阵的指数小于等于1，给出报错
if options(1) <= 1,
error('The exponent should be greater than 1!');
end
end
% 将options中的分量分别赋值给四个变量
expo = options(1); % 隶属度矩阵U的指数
max_iter = options(2); % 最大迭代次数
min_impro = options(3); % 隶属度最小变化量,迭代终止条件
display = options(4); % 每次迭代是否输出信息标志

obj_fcn = zeros(max_iter, 1); % 初始化输出参数obj_fcn
U = initfcm(cluster_n, data_n); % 初始化模糊分配矩阵,使U满足列上相加为1
%% Main loop 主要循环
for i = 1:max_iter
% 在第k步循环中改变聚类中心ceneter,和分配函数U的隶属度值;
[U, center, obj_fcn(i)] = stepfcm(data, U, cluster_n, expo);
if display,
fprintf('FCM:Iteration count = %d, obj.fcn = %f\n', i, obj_fcn(i));
end
% 终止条件判别
if i > 1 && abs(obj_fcn(i) - obj_fcn(i-1)) <= min_impro
break;
end
end
iter_n = i; % 实际迭代次数
obj_fcn(iter_n+1:max_iter) = [];