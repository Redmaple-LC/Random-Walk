clear
close all

img=im2double(imread('192.bmp'));
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
[sm,sn]=ginput;
l_s2=length(sm);
s2x=round(sm); s2y=round(sn);
plot(s2x,s2y,'m.','MarkerSize',16)

% [mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x);...
%     sub2ind([X Y],s2y,s2x)],[zeros(l_s1,1);ones(l_s2,1)]);

[sv,sw]=ginput;
l_s3=length(sv);
s3x=round(sv); s3y=round(sw);
plot(s3x,s3y,'b.','MarkerSize',16)

[mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x);...
    sub2ind([X Y],s2y,s2x);sub2ind([X Y],s3y,s3x);],[zeros(l_s1,1);ones(l_s2,1);ones(l_s3,1)+1]);

figure;
imagesc(mask)
colormap('gray')
axis equal
axis tight
axis off
hold on
% plot(s1x,s1y,'g.','MarkerSize',16)
% plot(s2x,s2y,'b.','MarkerSize',16)
title('Output mask');
% imwrite(mask,'mask.bmp','bmp')

[imgMasks,segOutline,imgMarkup]=segoutput(img,mask);
figure;
imagesc(imgMarkup);
colormap('gray')
axis equal
axis tight
axis off
hold on
%plot(s1x,s1y,'g.','MarkerSize',16)
%plot(s2x,s2y,'b.','MarkerSize',16)

imwrite(mask,'mask.bmp','bmp') 
imwrite(imgMarkup,'imgMarkup.bmp','bmp')