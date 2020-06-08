function [mask,probabilities] = random_walker(img,seeds,labels,beta)
%Function [mask,probabilities] = random_walker(img,seeds,labels,beta) uses the 
%random walker segmentation algorithm to produce a segmentation given a 2D 
%image, input seeds and seed labels.
% ͼ�� Ŀ�����ӵ����� �������ӵ����� Ŀ�����ӵ�������0  Ŀ�����ӵ�������1 �������಻ͬ��ǩ��
%Inputs: img   - The image to be segmented  ����ͼ��
%        seeds - The input seed locations (given as image indices, i.e., as produced by sub2ind) 
%                �������ӵ�λ�ã�������ͼ�����꣬ͨ��sub2ind������
%        labels -Integer object labels for each seed.  The labels vector should be the same size as the seeds vector.
%                ÿ�����ӵ�����������ǩ����ǩʸ��Ӧ������������С��ͬ��
%        beta -  Optional weighting parameter (Default beta = 90)
%                ��ѡ��Ȩ������Ĭ��Beta = 90��
%Output: mask -  A labeling of each pixel with values 1-K, indicating the object membership of each pixel
%                ���ÿ�����ص�ֵk����ʾÿ�����صĶ���ĳ�Ա ��������߲���������
% probabilities- Pixel (i,j) belongs to label 'k' with probability equal to probabilities(i,j,k)
%                ���أ�I��j�����ڱ�ǩ��k���ĸ��ʵ��ڸ��ʣ�I��j��K��

% ����ͼ��
if nargin < 4 %�������С��4
    beta = 60;
    betag= 2; % ���ξ���Ȩֵ
end
% ���ͼ���С
img=im2double(img);
[X, Y, Z]=size(img);

% ������
exitFlag=0;
if((Z~=1) && (Z~=3)) %���ͼ��ͨ���� �Ҷ�ͼ����� && �߼��� ����ͬʱΪ��
    disp('����:ͼ�������һ�����Ҷȣ�����������ɫ��ͨ�� .')
    exitFlag=1;
end 
if(sum(isnan(img(:))) || sum(isinf(img(:)))) %��� NaN/Inf ͼ��ֵ
    disp('����: ͼ�����NaN��INFֵ-��֪����δ���.')
    exitFlag=1;
end
% ������ӵ�λ�ò���
if(sum(seeds<1) || sum(seeds>size(img,1)*size(img,2)) || (sum(isnan(seeds)))) 
    disp('������������λ�ñ�����ͼ����.')
    disp('The location is the index of the seed, as if the image is a matrix.')
    disp('i.e., 1 <= seeds <= size(img,1)*size(img,2)')
    exitFlag=1;
end
if(sum(diff(sort(seeds))==0)) % ����ظ����ӵ�
    disp('���󣺼�⵽�ظ����ӵ�.')
    disp('Include only one entry per seed in the "seeds" and "labels" inputs.')
    exitFlag=1;
end
TolInt=0.01*sqrt(eps);
if(length(labels) - sum(abs(labels-round(labels)) < TolInt)) %#ok<BDLOG> % ������ӱ�ǩ����
    disp('���󣺱�ǩ����������ֵ��');
    exitFlag=1;
end
if(length(beta)~=1) % �����Բ���
    disp('���󣺡�Beta������ֻ����һ��ֵ��');
    exitFlag=1;
end
if(exitFlag)
    disp('Exiting...')
    [mask,probabilities]=deal([]);
    return
end

% ����ͼ��
[points, edges]=lattice(X,Y);

% ����Ȩֵ��������˹����
if(Z > 1) % ��ɫͼ��
    tmp=img(:,:,1);
    imgVals=tmp(:);
    tmp=img(:,:,2);
    imgVals(:,2)=tmp(:);
    tmp=img(:,:,3);
    imgVals(:,3)=tmp(:);
else
    imgVals=img(:); %img(:)����˼Ϊ��ÿ����β���д��һ��
end
% Ȩֵ���� ������˹����
weights=makeweights(edges,imgVals,beta,points,betag);%%%�޸�%%%
L=laplacian(edges,weights);

% ȷ�������ǩֵ�ѱ�ʹ��
label_adjust=min(labels); labels=labels-label_adjust+1; % ������ǩ> 0
labels_record(labels)=1;
labels_present=find(labels_record);
number_labels=length(labels_present);

%����Dirichlet����
boundary=zeros(length(seeds),number_labels);
for k=1:number_labels
    boundary(:,k)=(labels(:)==labels_present(k));
end

% ͨ�����Dirichlet�������������߸���
probabilities=dirichletboundary(L,seeds(:),boundary);

%���� mask
[dummy, mask]=max(probabilities,[],2); %#ok<ASGLU>
mask=labels_present(mask)+label_adjust-1; % ��ԭʼ��ǩ�����mask
mask=reshape(mask,[X Y]);
probabilities=reshape(probabilities,[X Y number_labels]);