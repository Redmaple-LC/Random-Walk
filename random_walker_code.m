 %Script gives a sample usage of the random walker function for image segmentation

clear
close all

%Read image
img=im2double(imread('007.bmp'));
% img = rgb2gray(img);
[X, Y]=size(img);

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
plot(s1x,s1y,'r.','MarkerSize',14,'linewidth',3)
[sm,sn]=ginput;
l_s2=length(sm);
s2x=round(sm); s2y=round(sn);
plot(s2x,s2y,'b.','MarkerSize',14,'linewidth',3)

[mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x);...
    sub2ind([X Y],s2y,s2x)],[zeros(l_s1,1);ones(l_s2,1)]);
figure;
imagesc(mask)
colormap('gray')
axis equal
axis tight
axis off
hold on
%plot(s1x,s1y,'g.','MarkerSize',16)
%plot(s2x,s2y,'b.','MarkerSize',16)
title('Output mask');
% imwrite(mask,'mask.bmp','bmp')

%预分割边缘
% %edg = edge(mask); %边缘线厚度为1像素
[imgMasks,segOutline,imgMarkup]=segoutput(img,mask);
figure;
imagesc(imgMarkup);
colormap('gray')
axis equal
axis tight
axis off
hold on
% %plot(s1x,s1y,'g.','MarkerSize',16)
% %plot(s2x,s2y,'b.','MarkerSize',16)
% title('Outlined mask')

bw=~mask;

%膨胀
se=strel('disk',13);
fd=imdilate(bw,se);

%腐蚀
se=strel('disk',18);
fe=imerode(fd,se);

f2=fe&~bw;


edg = edge(fd);
[rd,cd]=find(edg);
ld=length(rd);

edg2=edge(fe);
[re,ce]=find(edg2);
le=length(re);

% s11x=cat(1,s1x,ce);
% s11y=cat(1,s1y,re);
% s22x=cat(1,s2x,cd);
% s22y=cat(1,s2y,rd);
[mask2,probabilities2] = random_walker(img,[sub2ind([X Y],re,ce);...
    sub2ind([X Y],rd,cd)],[zeros(le,1);ones(ld,1)]);

figure;
imagesc(img);
colormap('gray')
axis equal
axis tight
axis off
hold on
plot(ce,re,'w.','MarkerSize',7)
plot(cd,rd,'k.','MarkerSize',7)
title('种子点')

[imgMasks2,segOutline2,imgMarkup2]=segoutput(img,mask2);
figure;
imagesc(imgMarkup2);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('轮廓线')

bw2=~mask2;
result=img.*bw2;
figure;
imagesc(result);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('肺实质')

result2=mask2+result;
figure;
imagesc(result2);
colormap('gray')
axis equal
axis tight
axis off
hold on
title('肺实质')