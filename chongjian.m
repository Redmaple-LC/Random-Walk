P=phantom(256);
figure(1),imshow(P);
% ����ͶӰ���ؽ��ĳ�����Ҳ������˰ɣ�
% randon�任��
theta1=0:10:170;theta2=0:5:175;theta3=0:2:178;

[R1,xp]=radon(P,theta1); %#ok<*ASGLU>
[R2,xp]=radon(P,theta2);
[R3,xp]=radon(P,theta3);
figure(2),imagesc(theta3,xp,R3);
colormap(hot);colorbar
xlabel(' \theta ' );ylabel(' x\prime ' );

%���ò�ͬ���ֵ�randon��任���ع�ͼ��
I1=iradon(R1,10);I2=iradon(R2,5);I3=iradon(R3,2);
figure(3);
subplot(1,3,1);
imshow(I1);title('��R1�ع�ͼ��');
subplot(1,3,2);
imshow(I2);title('��R2�ع�ͼ��');
subplot(1,3,3);
imshow(I3);title('��R3�ع�ͼ��');
