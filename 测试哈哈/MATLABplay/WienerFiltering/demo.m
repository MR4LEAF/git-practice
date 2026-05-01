%% demo of self-built wiener filtering vs MATLAB wiener filtering


clc ; clear ; close all


RGB = imread('saturn.png');
I = rgb2gray(RGB);
I= double(I);
Inoisy= I + 35*randn(size(I));
Inoisy= min(max(Inoisy,0),255);

Idenoise= wiener2(Inoisy,[5,5]);

Idenoise2= simplified_wiener2(Inoisy,[5,5]);


psnr(Inoisy,I)
psnr(Idenoise,I)
psnr(Idenoise2,I)

%%
residual= Inoisy - I;

hist(residual(:))

mean(residual(:))

%%
residual= Idenoise - I;

hist(residual(:))

mean(residual(:))
%%
figure(1); clf;
subplot(2,2,1);
imshow(uint8(I)); 
title('Original Image');

subplot(2,2,2);
imshow(uint8(Inoisy)); 
title('Noisy Image');

subplot(2,2,3);
imshow(uint8(Idenoise));
title('Denoised Image 1');

subplot(2,2,4);
imshow(uint8(Idenoise2)); 
title('Denoised Image 2');

%%
figure(2); clf;
subplot(2,2,1);
imagesc(uint8(I));
title('Original Image');

subplot(2,2,2);
imagesc(uint8(Inoisy));
title('Noisy Image');

subplot(2,2,3);
imagesc(uint8(Idenoise));
title('Denoised Image 1');

subplot(2,2,4);
imagesc(uint8(Idenoise2));
title('Denoised Image 2');
