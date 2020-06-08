clear all;
clc;
tic 

a=imread('011.jpg');
figure,imshow(a);
a0=double(a);
[m,n]=size(a);
h=1;
a1=zeros(m,n); 
%?计算平均领域灰度的一维灰度直方图???
for i=1:m
    for j=1:n
        for k=-h:h
            for w=-h:h;
                p=i+k;
                q=j+w;
                if (p<=0)||(p>m)
                    p=i;
                end
                if (q<=0)||(q>n)
                    q=j;
                end
                a1(i,j)=a0(p,q)+a1(i,j);
            end
        end
        a2(i,j)=uint8(1/9*a1(i,j));
    end
end
fxy=zeros(256,256);
%?计算二维直方图???
for i=1:m
    for j=1:n
        c1=a0(i,j);
        d=double(a2(i,j));
        fxy(c1+1,d+1)=fxy(c1+1,d+1)+1;
    end
end
Pxy=fxy/m/n;
%??figure,??? 
%???mesh(Pxy);??? 
%???title('二维灰度直方图');???
%计算Hl???
Hl=0;

for i=1:256
    for j=1:256
        if Pxy(i,j)>0.00001
            Hl=Hl-Pxy(i,j)*log(Pxy(i,j));
        else
            Hl=Hl;
        end
    end
end 
%计算PA,HA??? 
PA=zeros(256,256);
HA=zeros(256,256);
PB=zeros(256,256);

PA(1,1)=Pxy(1,1);
if PA(1,1)<1e-4
    HA(1,1)=0;
else
    HA(1,1)=-PA(1,1)*log(PA(1,1));
end
for i=2:256
    PA(i,1)=PA(i-1,1)+Pxy(i,1);
    if Pxy(i,1)>0.00001
        HA(i,1)=HA(i-1,1)-Pxy(i,1)*log(Pxy(i,1));
    else
        HA(i,1)=HA(i-1,1);
    end
end
for j=2:256
    PA(1,j)=PA(1,j-1)+Pxy(1,j);
    if Pxy(1,j)>0.00001
            HA(1,j)=HA(1,j-1)-Pxy(1,j)*log(Pxy(1,j));
    else
            HA(1,j)=HA(1,j-1);
    end
end

for i=2:256
    for j=2:256
        PA(i,j)=PA(i-1,j)+PA(i,j-1)-PA(i-1,j-1)+Pxy(i,j);
        if Pxy(i,j)>0.00001
            HA(i,j)=HA(i-1,j)+HA(i,j-1)-HA(i-1,j-1)-Pxy(i,j)*log(Pxy(i,j));
        else
            HA(i,j)=HA(i-1,j)+HA(i,j-1)-HA(i-1,j-1);
        end
    end
end 
%计算最大熵?????? 
PB=1-PA;
h=zeros(256,256);
hmax=0;

for i=1:256
    for j=1:256
        if abs(PA(i,j))>0.00001&&abs(PB(i,j))>0.00001
            h(i,j)=log(PA(i,j)*PB(i,j))+HA(i,j)/PA(i,j)+(Hl-HA(i,j))/PB(i,j);
        else
            h(i,j)=0;
        end
        if h(i,j)>hmax
            hmax=h(i,j);
            s=i-1;
            t=j-1;
        end
    end
end 
z=ones(m,n);
for i=1:m
    for j=1:n
        if a0(i,j)<=s&&a2(i,j)<=t
            %if?double(a(i,j))+double(a2(i,j))+a3(i,j)<=s+t+q???????????????????
            z(i,j)=0;
        else
            z(i,j)=255;
        end
    end
end
hmax
s
t
figure,imshow(z);
toc