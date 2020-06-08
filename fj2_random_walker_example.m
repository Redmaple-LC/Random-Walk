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

[mask,probabilities] = random_walker(img,[sub2ind([X Y],s1y,s1x);...
    sub2ind([X Y],s2y,s2x)],[zeros(l_s1,1);ones(l_s2,1)]);
[mask3,probabilities3] = random_walker(img,[sub2ind([X Y],s3y,s3x);...
    sub2ind([X Y],s2y,s2x)],[zeros(l_s3,1);ones(l_s2,1)]);%##################
% figure;
% imagesc(mask)
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on
% %plot(s1x,s1y,'g.','MarkerSize',16)
% %plot(s2x,s2y,'b.','MarkerSize',16)
% title('Output mask');

%预分割边缘
% %edg = edge(mask); %边缘线厚度为1像素
% [imgMasks,segOutline,imgMarkup]=segoutput(img,mask);
% figure;
% imagesc(imgMarkup);
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on
% %plot(s1x,s1y,'g.','MarkerSize',16)
% %plot(s2x,s2y,'b.','MarkerSize',16)
% title('Outlined mask')

bw=~mask;
bw3=~mask3;%###############################################################
% figure;
% imagesc(bw)
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on

%膨胀
se=strel('disk',13);
fd=imdilate(bw,se);
fd3=imdilate(bw3,se);%#####################################################
% figure;
% imagesc(fd)
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on

%腐蚀
se=strel('disk',15);
fe=imerode(fd,se);
fe3=imerode(fd3,se);%######################################################
% figure;
% imagesc(fe)
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on


% f2=fe&~bw;
% f3=fe3&~bw3;%##############################################################
% figure;
% imagesc(f2);
% colormap('gray')
% axis equal
% axis tight
% hold on

% %凹槽质心作为前景种子点
% [L,n]=bwlabel(f2,8);
% R=[];C=[];
% for k=1:n
%     [r,c]=find(L==k);
%     rbar=mean(r);
%     cbar=mean(c);
%     %plot(cbar,rbar,'Marker','*','MarkeredgeColor','r')
%     R=[R;rbar];C=[C;cbar];
% end
%R1=round(R);C1=round(C);

% figure;
% imagesc(fd);
% colormap('gray')
% axis equal
% axis tight
% hold on
% plot(C,R,'Marker','*','MarkeredgeColor','r')

edg=edge(fd);
[rd,cd]=find(edg);
ld=length(rd);

edg2=edge(fe);
[re,ce]=find(edg2);
le=length(re);

[mask2,probabilities2] = random_walker(img,[sub2ind([X Y],re,ce);...
    sub2ind([X Y],rd,cd)],[zeros(le,1);ones(ld,1)]);

edg3=edge(fd3);%#########################################################
[rd3,cd3]=find(edg3);
ld3=length(rd3);

edg4=edge(fe3);
[re3,ce3]=find(edg4);
le3=length(re3);

[mask4,probabilities4] = random_walker(img,[sub2ind([X Y],re3,ce3);...
    sub2ind([X Y],rd3,cd3)],[zeros((le3),1);ones((ld3),1)]);%##############

figure;
imagesc(img);
colormap('gray')
axis equal
axis tight
axis off
hold on
plot(ce,re,'g.','MarkerSize',12)
plot(cd,rd,'b.','MarkerSize',12)
plot(ce3,re3,'g.','MarkerSize',12)
plot(cd3,rd3,'b.','MarkerSize',12)

mask5=double(mask2 & mask4);

% figure;
% imagesc(mask5)
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on
[imgMasks2,segOutline2,imgMarkup2]=segoutput(img,mask2);
[imgMasks4,segOutline4,imgMarkup4]=segoutput(img,mask4);
%[imgMasks5,segOutline5,imgMarkup5]=segoutput(img,mask5);
imgMarkup5=imgMarkup2 | imgMarkup4;
%imgMarkup5=(imgMarkup4&~img1);
figure;
imagesc(imgMarkup5);
colormap('gray')
axis equal
axis tight
axis off
hold on

bw5=~mask5;
% result=img.*bw5;
% figure;
% imagesc(result);
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on
% title('肺实质')

%直接对mask进行膨胀、腐蚀、取边缘 VS 对mask膨胀（背景种子点）、腐蚀（前景种子）、再运用random取边缘
% f_e=double((~fe)&(~fe3));
% [imgMasks_e,segOutline_e,imgMarkup_e]=segoutput(img,f_e);
% figure;
% subplot(2,2,1);
% imagesc(f_e)
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on
% title('膨胀+腐蚀')
% 
% subplot(2,2,2);
% imagesc(mask5)
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on
% title('重选种子点')
% 
% subplot(2,2,3);
% imagesc(imgMarkup_e)
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on
% 
% subplot(2,2,4);
% imagesc(imgMarkup5)
% colormap('gray')
% axis equal
% axis tight
% axis off
% hold on