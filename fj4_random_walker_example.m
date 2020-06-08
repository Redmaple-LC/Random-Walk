%Script gives a sample usage of the random walker function for image segmentation

clear
close all

%Read image
img=im2double(imread('01.jpg'));
img = rgb2gray(img);
[X Y]=size(img);

figure;
imagesc(img);
colormap('gray')
axis equal
axis tight
axis off
hold on

[sp,sq]=ginput;
l_s1=length(sp);
s1x=round(sp); s1y=round(sq);
plot(s1x,s1y,'g.','MarkerSize',16)
[su,sv]=ginput;
l_s3=length(su);
s3x=round(su);s3y=round(sv);
plot(s3x,s3y,'m.','MarkerSize',16)
[sm,sn]=ginput;
l_s2=length(sm);
s2x=round(sm); s2y=round(sn);
plot(s2x,s2y,'b.','MarkerSize',16)

tic

[mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x);...
    sub2ind([X Y],s2y,s2x)],[zeros(l_s1,1);ones(l_s2,1)]);
[mask3,probabilities3] = random_walker(img,[sub2ind([X Y],s3y,s3x);...
    sub2ind([X Y],s2y,s2x)],[zeros(l_s3,1);ones(l_s2,1)]);


bw=~mask;
bw3=~mask3;

%≈Ú’Õ
se=strel('disk',22);
fd=imdilate(bw,se);
fd3=imdilate(bw3,se);

%∏Ø ¥
se=strel('disk',26);
fe=imerode(fd,se);
fe3=imerode(fd3,se);

edg=edge(fd);
[rd,cd]=find(edg);
ld=length(rd);

edg2=edge(fe);
[re,ce]=find(edg2);
le=length(re);

[mask2,probabilities2] = random_walker(img,[sub2ind([X Y],re,ce);...
    sub2ind([X Y],rd,cd)],[zeros(le,1);ones(ld,1)]);

edg3=edge(fd3);
[rd3,cd3]=find(edg3);
ld3=length(rd3);

edg4=edge(fe3);
[re3,ce3]=find(edg4);
le3=length(re3);

[mask4,probabilities4] = random_walker(img,[sub2ind([X Y],re3,ce3);...
    sub2ind([X Y],rd3,cd3)],[zeros((le3),1);ones((ld3),1)]);

figure;
imagesc(img);
colormap('gray')
axis equal
axis tight
axis off
hold on
plot(ce,re,'r.','MarkerSize',7)
plot(cd,rd,'b.','MarkerSize',7)
plot(ce3,re3,'r.','MarkerSize',7)
plot(cd3,rd3,'b.','MarkerSize',7)

mask5=double(mask2 & mask4);

[imgMasks2,xcont2,ycont2]=my2segoutput(img,mask2);
[imgMasks4,xcont4,ycont4]=my2segoutput(img,mask4);
%[imgMasks5,segOutline5,imgMarkup5]=segoutput(img,mask5);
%imgMarkup5=imgMarkup2 | imgMarkup4;
xcont=[xcont2;xcont4];
ycont=[ycont2;ycont4];

imgMarkup5=img(:,:,1);
imgMarkup5(xcont)=1;
imgMarkup5(ycont)=1;

imgTmp2=img(:,:,1);
imgTmp2(xcont)=0;
imgTmp2(ycont)=0;
imgMarkup5(:,:,2)=imgTmp2;

imgTmp3=img(:,:,1);
imgTmp3(xcont)=0;
imgTmp3(ycont)=0;
imgMarkup5(:,:,3)=imgTmp3;

figure;
imagesc(imgMarkup5);
colormap('gray')
axis equal
axis tight
axis off
hold on
%imwrite(imgMarkup5,'imgMarkup5.bmp','bmp')

bw5=~mask5;
%imwrite(bw5,'bw5.bmp','bmp')
%img = rgb2gray(img);
%imwrite(img,'img.bmp','bmp')
time=toc
result=img.*bw5;
figure;
imagesc(result);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('∑Œ µ÷ ')
imwrite(result,'result.bmp','bmp')