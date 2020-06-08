function [] = Predict(imageurl)
load classifier.mat;
figure;
img = imread(imageurl);
imshow(img);

%��ȡͼ�����������
%ת��Ϊ�Ҷ�ͼ��
img=rgb2gray(img);
glcm_feature = getGLCMFeatures(img);
%ת��Ϊ2ֵͼ��
lvl = graythresh(img);
img = im2bw(img, lvl);

% imshow(img);
% figure
img=imresize(img,[256 256]);
[hog_4x4, ~] = extractHOGFeatures(img,'CellSize',[4 4]);
testFeature = [hog_4x4 glcm_feature];


% ʹ�ò���ͼ�����������Ԥ��������ǩ
predictedLabel = predict(classifier, testFeature);

str = ['��������' predictedLabel];
dim = [0.25 0.0004 0.2 0.2];
annotation('textbox', dim, 'string', str, 'fontsize', 20, 'color', 'g','edgecolor', 'none');