% demo dct 1D matrix

clc;clear;

numrows= 64;
numcolums= 64; 
X= double(imread('cameraman.tif'));
X= imresize(X,[numrows,numcolums]);

% 2-D DCT

dct2_X = dct2(X);

W1= dctmtx(numrows);
W2= dctmtx(numcolums);
A= kron(W2,W1);     %  transpose(W)=W 


dct2_X1 = A * X(:);

err = dct2_X1 - dct2_X(:);

norm(err,2)

% 1-D iDCT

idct2_X = idct2(X);

B= kron(W2',W1');     %  transpose(W)=W 


idct2_X1 = B * X(:);

err = idct2_X1 - idct2_X(:);

norm(err,2)


% orthogonality
AHA= A'*A;
[sum(AHA(:)),sum(AHA(:).^2)]


BHB= B'*B;
[sum(BHB(:)),sum(BHB(:).^2)]


AB= A*B;
[sum(AB(:)),sum(AB(:).^2)]

%% sort 
clc
figure(1); set(gcf, 'Color', 'white', 'Position', [500 500 750 450]);
subplot(2,2,[1,2])

plot(sort(abs(dct2_X(:))),'b-*');grid on
set(gca,'YScale','log')

dct2_X_thresholded= dct2_X;
dct2_X_thresholded(abs(dct2_X)<=1e1)= 0;
CompressionRatio= nnz(dct2_X_thresholded)/(numrows*numcolums)

subplot(2,2,3)
imagesc(X)
title('original')
subplot(2,2,4)
X_recover= idct2(dct2_X_thresholded);
imagesc(X_recover)
title('recover')

psnr(X_recover,X,255)