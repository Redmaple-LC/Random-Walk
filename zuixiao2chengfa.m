% 最小二乘法目的是得到一条最好的拟合直线

% d*a+e*b = u
% p*a+q*b = v
% 其中p == d

n = 6;
x = zeros(1,n);
y = zeros(1,n);
%x(1,1:n/2) = round(rand(1,n/2)*50);
%y(1,1:n/2) = round(rand(1,n/2)*50);

%x(1,(n/2+1):n) = round(rand(1,n/2)*50+50);
%y(1,(n/2+1):n) = round(rand(1,n/2)*50+50);

%x = round(rand(1,n)*100);
%y = round(rand(1,n)*100);

x = [1.3 1.9 3.2 4.1 5.2 6.3];
y = [2.3 4.1 6.3 8.2 10.3 11.8];
%x = 1:100;
%y(:) = 50+2*x;
plot(x,y,'g*')

d = 0; e = 0; u = 0; p = 0; q = 0; v = 0;
for i = 1:n
    d = d + 2*x(i)*x(i);
    e = e + 2*x(i);
    u = u + 2*x(i)*y(i);
    v = v + 2*y(i);
end
p = e;
q = 2*n;

% 利用克拉默法则来解方程组
D = det([d e; p q]);
a = det([u e; v q])/D;
b = det([d u; p v])/D;

% 绘制出最好的拟合直线
t = min(x):0.1:max(x);
g = a*t+b;
hold on
plot(t,g,'r')
hold off

