clear;
dir=('C:\Users\LC\Documents\MATLAB\ʶ�����ʵ��\ͼ��ʶ�����Դ����\SVM\pictures');
testdir=('C:\Users\LC\Documents\MATLAB\ʶ�����ʵ��\ͼ��ʶ�����Դ����\SVM\testPictures\test');
trainingSet = imageSet(dir,'recursive');
testSet = imageSet(testdir,'recursive');

[trainingFeatures,trainingLabels,testFeatures,testLabels]=extractFeature(trainingSet,testSet);
%% 
%ѵ��һ��svm������
%fitcecoc ʹ��1��1�ķ���
classifier = fitcecoc(trainingFeatures, trainingLabels);
save classifier.mat classifier;

% ʹ�ò���ͼ�����������Ԥ��������ǩ
predictedLabels = predict(classifier, testFeatures);

%% ����������
%ʹ��û�б�ǩ��ͼ�����ݽ��в��ԣ�����һ�����������������Ч��
confMat=confusionmat(testLabels, predictedLabels)
accuracy=(confMat(1,1)/sum(confMat(1,:))+confMat(2,2)/sum(confMat(2,:))+...
    confMat(3,3)/sum(confMat(3,:))+confMat(4,4)/sum(confMat(4,:)))/4


Predict('C:\Users\LC\Documents\MATLAB\ʶ�����ʵ��\ͼ��ʶ�����Դ����\SVM\testPictures\test\flw\flower9.jpg');