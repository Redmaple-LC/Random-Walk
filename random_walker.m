function [mask,probabilities] = random_walker(img,seeds,labels,beta)
%Function [mask,probabilities] = random_walker(img,seeds,labels,beta) uses the 
%random walker segmentation algorithm to produce a segmentation given a 2D 
%image, input seeds and seed labels.
% 图像 目标种子点坐标 背景种子点坐标 目标种子点数量个0  目标种子点数量个1 （即两类不同标签）
%Inputs: img   - The image to be segmented  输入图像
%        seeds - The input seed locations (given as image indices, i.e., as produced by sub2ind) 
%                输入种子点位置（给定的图像坐标，通过sub2ind产生）
%        labels -Integer object labels for each seed.  The labels vector should be the same size as the seeds vector.
%                每个种子点的整数对象标签。标签矢量应与种子向量大小相同。
%        beta -  Optional weighting parameter (Default beta = 90)
%                可选加权参数（默认Beta = 90）
%Output: mask -  A labeling of each pixel with values 1-K, indicating the object membership of each pixel
%                标记每个像素的值k，表示每个像素的对象的成员 即随机游走产生的区域
% probabilities- Pixel (i,j) belongs to label 'k' with probability equal to probabilities(i,j,k)
%                像素（I，j）属于标签“k”的概率等于概率（I，j，K）

% 读入图像
if nargin < 4 %如果参数小于4
    beta = 60;
    betag= 2; % 几何距离权值
end
% 获得图像大小
img=im2double(img);
[X, Y, Z]=size(img);

% 错误检查
exitFlag=0;
if((Z~=1) && (Z~=3)) %检查图像通道数 灰度图像可用 && 逻辑与 两边同时为真
    disp('错误:图像必须有一个（灰度）或三个（彩色）通道 .')
    exitFlag=1;
end 
if(sum(isnan(img(:))) || sum(isinf(img(:)))) %检查 NaN/Inf 图像值
    disp('错误: 图像包含NaN或INF值-不知道如何处理.')
    exitFlag=1;
end
% 检查种子点位置参数
if(sum(seeds<1) || sum(seeds>size(img,1)*size(img,2)) || (sum(isnan(seeds)))) 
    disp('错误：所有种子位置必须在图像内.')
    disp('The location is the index of the seed, as if the image is a matrix.')
    disp('i.e., 1 <= seeds <= size(img,1)*size(img,2)')
    exitFlag=1;
end
if(sum(diff(sort(seeds))==0)) % 检查重复种子点
    disp('错误：检测到重复种子点.')
    disp('Include only one entry per seed in the "seeds" and "labels" inputs.')
    exitFlag=1;
end
TolInt=0.01*sqrt(eps);
if(length(labels) - sum(abs(labels-round(labels)) < TolInt)) %#ok<BDLOG> % 检查种子标签参数
    disp('错误：标签必须是整型值。');
    exitFlag=1;
end
if(length(beta)~=1) % 检查测试参数
    disp('错误：“Beta”参数只包含一个值。');
    exitFlag=1;
end
if(exitFlag)
    disp('Exiting...')
    [mask,probabilities]=deal([]);
    return
end

% 构建图像
[points, edges]=lattice(X,Y);

% 生成权值和拉普拉斯矩阵
if(Z > 1) % 彩色图像
    tmp=img(:,:,1);
    imgVals=tmp(:);
    tmp=img(:,:,2);
    imgVals(:,2)=tmp(:);
    tmp=img(:,:,3);
    imgVals(:,3)=tmp(:);
else
    imgVals=img(:); %img(:)的意思为把每列首尾相接写成一列
end
% 权值函数 拉普拉斯函数
weights=makeweights(edges,imgVals,beta,points,betag);%%%修改%%%
L=laplacian(edges,weights);

% 确定哪类标签值已被使用
label_adjust=min(labels); labels=labels-label_adjust+1; % 调整标签> 0
labels_record(labels)=1;
labels_present=find(labels_record);
number_labels=length(labels_present);

%设置Dirichlet问题
boundary=zeros(length(seeds),number_labels);
for k=1:number_labels
    boundary(:,k)=(labels(:)==labels_present(k));
end

% 通过求解Dirichlet问题求解随机游走概率
probabilities=dirichletboundary(L,seeds(:),boundary);

%生成 mask
[dummy, mask]=max(probabilities,[],2); %#ok<ASGLU>
mask=labels_present(mask)+label_adjust-1; % 将原始标签分配给mask
mask=reshape(mask,[X Y]);
probabilities=reshape(probabilities,[X Y number_labels]);