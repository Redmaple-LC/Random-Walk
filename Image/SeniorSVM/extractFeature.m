function [trainingFeatures,trainingLabels,testFeatures,testLabels]=extractFeature(trainingSet,testSet)
%% 确定特征向量尺寸
img = read(trainingSet(1), 1);
%转化为灰度图像
img=rgb2gray(img);
%转化为2值图像
lvl = graythresh(img);
img = im2bw(img, lvl);
img=imresize(img,[256 256]);
cellSize = [4 4];
[hog_feature, vis_hog] = extractHOGFeatures(img,'CellSize',cellSize);
glcm_feature = getGLCMFeatures(img);
SizeOfFeature = length(hog_feature)+ length(glcm_feature);

%% 构建训练样本特征向量和训练样本标签
trainingFeatures = [];
trainingLabels   = [];
for digit = 1:numel(trainingSet)       
    numImages = trainingSet(digit).Count;
    features  = zeros(numImages, SizeOfFeature, 'single');%初始化特征向量
    % 遍历每张图片
    for i = 1:numImages
        img = read(trainingSet(digit), i);% 取出第i张图片
        
        img=rgb2gray(img);                % 转化为灰度图像
        glcm_feature = getGLCMFeatures(img);  % 提取GLCM特征
       
        lvl = graythresh(img);            % 阈值化
        img = im2bw(img, lvl);            % 转化为2值图像
        img=imresize(img,[256 256]);
        % 提取HOG特征
        [hog_feature, vis_hog] = extractHOGFeatures(img,'CellSize',cellSize);
        % 合并两个特征
        features(i, :) = [hog_feature glcm_feature];
    end
    % 使用图像描述作为训练标签
    labels = repmat(trainingSet(digit).Description, numImages, 1);  
    % 逐个添加每张训练图片的特征和标签
    trainingFeatures = [trainingFeatures; features];
    trainingLabels   = [trainingLabels; labels];       
end


%% 提取测试图片集的特征向量
testFeatures = [];
testLabels   = [];
for digit = 1:numel(testSet)
           
    numImages = testSet(digit).Count;
    %初始化特征向量
    features  = zeros(numImages, SizeOfFeature, 'single');
    
    for i = 1:numImages
        
        img = read(testSet(digit), i);
        %转化为灰度图像
        img=rgb2gray(img);
        glcm_feature = getGLCMFeatures(img);
        %转化为2值图像
        lvl = graythresh(img);
        img = im2bw(img, lvl);
        img=imresize(img,[256 256]);
        [hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',cellSize);
        features(i, :) = [hog_4x4 glcm_feature];
    end
    
    % 使用图像描述作为训练标签
    labels = repmat(testSet(digit).Description, numImages, 1);
        
    testFeatures = [testFeatures; features];
    testLabels=[testLabels; labels];
        
end
end