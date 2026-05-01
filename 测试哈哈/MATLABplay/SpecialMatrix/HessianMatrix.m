%% Hessian matrix for an image
clc;clear;clf;close all;

%%
m= 512;
n= 512;

% im= double(imread('cameraman.tif'));
% % x= double(imread('USAF-1951.png'));
% im= abs(imresize(im,[m,n]));im= 255*im/max(im(:));

NA= 0.50; lambda= 0.78e-6; dxy= 0.1e-6;
[im,OTF]= Get_TF(NA,lambda,dxy,m,n); 

%% Hessian matrix
[ox,oy]= gradient(im);
[oxx,oxy]= gradient(ox);
[oyx,oyy]= gradient(oy);

%% Gaussian kernel
kernel_size= 5;
[x,y]= meshgrid(-(kernel_size-1)/2:1:(kernel_size-1)/2);
kernel_sigma= 0.8;
kernel= exp(-(x.^2+y.^2)/(2*kernel_sigma^2));
kernel= kernel/sum(kernel(:));
%%
j11= conv2(oxx,kernel,'same');
j12= conv2(oxy,kernel,'same');
j21= conv2(oyx,kernel,'same');
j22= conv2(oyy,kernel,'same');
%%

%%
LocalVarianceImage= im - conv2(im,ones(3,3)/9,'same');
LocalVarianceImage= (LocalVarianceImage- min(LocalVarianceImage(:)))/(max(LocalVarianceImage(:))-min(LocalVarianceImage(:)));
%%
LV= 1./(1+1e2*LocalVarianceImage);

%%
figure(1);clf
subplot(3,1,1)
imagesc(im);colorbar
subplot(3,1,2)
imagesc(LocalVarianceImage);colorbar
subplot(3,1,3)
imagesc(LV);colorbar