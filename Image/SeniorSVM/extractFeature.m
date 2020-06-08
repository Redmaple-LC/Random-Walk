function [trainingFeatures,trainingLabels,testFeatures,testLabels]=extractFeature(trainingSet,testSet)
%% ȷ�����������ߴ�
img = read(trainingSet(1), 1);
%ת��Ϊ�Ҷ�ͼ��
img=rgb2gray(img);
%ת��Ϊ2ֵͼ��
lvl = graythresh(img);
img = im2bw(img, lvl);
img=imresize(img,[256 256]);
cellSize = [4 4];
[hog_feature, vis_hog] = extractHOGFeatures(img,'CellSize',cellSize);
glcm_feature = getGLCMFeatures(img);
SizeOfFeature = length(hog_feature)+ length(glcm_feature);

%% ����ѵ����������������ѵ��������ǩ
trainingFeatures = [];
trainingLabels   = [];
for digit = 1:numel(trainingSet)       
    numImages = trainingSet(digit).Count;
    features  = zeros(numImages, SizeOfFeature, 'single');%��ʼ����������
    % ����ÿ��ͼƬ
    for i = 1:numImages
        img = read(trainingSet(digit), i);% ȡ����i��ͼƬ
        
        img=rgb2gray(img);                % ת��Ϊ�Ҷ�ͼ��
        glcm_feature = getGLCMFeatures(img);  % ��ȡGLCM����
       
        lvl = graythresh(img);            % ��ֵ��
        img = im2bw(img, lvl);            % ת��Ϊ2ֵͼ��
        img=imresize(img,[256 256]);
        % ��ȡHOG����
        [hog_feature, vis_hog] = extractHOGFeatures(img,'CellSize',cellSize);
        % �ϲ���������
        features(i, :) = [hog_feature glcm_feature];
    end
    % ʹ��ͼ��������Ϊѵ����ǩ
    labels = repmat(trainingSet(digit).Description, numImages, 1);  
    % ������ÿ��ѵ��ͼƬ�������ͱ�ǩ
    trainingFeatures = [trainingFeatures; features];
    trainingLabels   = [trainingLabels; labels];       
end


%% ��ȡ����ͼƬ������������
testFeatures = [];
testLabels   = [];
for digit = 1:numel(testSet)
           
    numImages = testSet(digit).Count;
    %��ʼ����������
    features  = zeros(numImages, SizeOfFeature, 'single');
    
    for i = 1:numImages
        
        img = read(testSet(digit), i);
        %ת��Ϊ�Ҷ�ͼ��
        img=rgb2gray(img);
        glcm_feature = getGLCMFeatures(img);
        %ת��Ϊ2ֵͼ��
        lvl = graythresh(img);
        img = im2bw(img, lvl);
        img=imresize(img,[256 256]);
        [hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',cellSize);
        features(i, :) = [hog_4x4 glcm_feature];
    end
    
    % ʹ��ͼ��������Ϊѵ����ǩ
    labels = repmat(testSet(digit).Description, numImages, 1);
        
    testFeatures = [testFeatures; features];
    testLabels=[testLabels; labels];
        
end
end