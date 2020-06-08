clear all; close all;
tic
I = imread('82.jpg');
imshow(I)
rng('default');
[m, n, p] = size(I);
X = reshape(double(I), m*n, p);
k = 5; b = 5;
[C, dist, J] = fcm(X, k, b);
[~, label] = min(dist, [], 2);
figure
imshow(uint8(reshape(C(label, :), m, n, p)))
figure
plot(1:length(J), J, 'r-*'), xlabel('#iterations'), ylabel('objective function')
C
toc