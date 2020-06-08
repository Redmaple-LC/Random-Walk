clear;
dir=('C:\Users\LC\Documents\MATLAB\识别分类实验\图像识别分类源代码\SVM\pictures');
testdir=('C:\Users\LC\Documents\MATLAB\识别分类实验\图像识别分类源代码\SVM\testPictures\test');
trainingSet = imageSet(dir,'recursive');
testSet = imageSet(testdir,'recursive');

[trainingFeatures,trainingLabels,testFeatures,testLabels]=extractFeature(trainingSet,testSet);
%% 
%训练一个svm分类器
%fitcecoc 使用1对1的方案
classifier = fitcecoc(trainingFeatures, trainingLabels);
save classifier.mat classifier;

% 使用测试图像的特征向量预测样本标签
predictedLabels = predict(classifier, testFeatures);

%% 评估分类器
%使用没有标签的图像数据进行测试，生成一个混淆矩阵表明分类效果
confMat=confusionmat(testLabels, predictedLabels)
accuracy=(confMat(1,1)/sum(confMat(1,:))+confMat(2,2)/sum(confMat(2,:))+...
    confMat(3,3)/sum(confMat(3,:))+confMat(4,4)/sum(confMat(4,:)))/4


Predict('C:\Users\LC\Documents\MATLAB\识别分类实验\图像识别分类源代码\SVM\testPictures\test\flw\flower9.jpg');