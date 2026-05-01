
clear;clc;close all

addpath('E:\MATLAB_codes\CustomedLibraries\FFT_related');

%% 
mag=9.8*2.6;
pixel=5.3;
lamda=0.78;
N=1280;
M=1024;
p=4;
focal=2*p^2/lamda;
s=lamda*focal/p;
k=2*pi/lamda;
a= N*pixel;% Side length of the object's matrix
dx= pixel;
x1=-a/2:dx:a/2-dx;
b=M*pixel;% Side length of the object's matrix
dy=pixel;
y1=-b/2:dy:b/2-dy;
[xx,yy]=meshgrid(x1,y1);
fxs=N/a;
dfx=fxs/N;
fx=linspace(-fxs/2,fxs/2-dfx,N);
% [ffx,ffy]=meshgrid(fx,fx);
fys=M/b;
dfy=fys/M;
fy=linspace(-fys/2,fys/2-dfy,M);
[ffx,ffy]=meshgrid(fx,fy);
mm=peaks(xx/500,yy/500);
E_obbj=5+6*exp(1i*mm);
I=E_obbj.*conj(E_obbj);

% 
figure(1);clf
subplot(3,1,1)
imagesc(I)
subplot(3,1,2)
imagesc(mm)
% fft of inteferogram
I_fft= FFTOperations.ft2(I);
subplot(3,1,3)
imagesc(angle(I_fft))

%
dxy= dx;
[x, y]= axis_spatial(1, M, N);
[X,Y]= meshgrid(y,x);
X= X*dxy;
Y= Y*dxy;

% Riesz kernel
temp= X.^2+Y.^2;temp(temp==0)= eps;
rx= (-X)./(2*pi*sqrt(temp.^3));
ry= (-Y)./(2*pi*sqrt(temp.^3));
% 
% figure(2)
% subplot(1,2,1)
% imagesc(rx)
% subplot(1,2,2)
% imagesc(ry)
% 
% 
% 
rx_fft= FFTOperations.ft2(rx);
ry_fft= FFTOperations.ft2(ry);
% 
figure(3)
subplot(1,2,1)
imagesc(log(1+abs(rx_fft)))
subplot(1,2,2)
imagesc(log(1+abs(ry_fft)))
% 
I_rx_fft=  rx_fft.*I_fft;
I_ry_fft=  ry_fft.*I_fft;

% 
figure(4)
subplot(3,1,1)
imagesc(angle(I_rx_fft))
subplot(3,1,2)
imagesc(angle(I_ry_fft))
subplot(3,1,3)
imagesc(angle(I_rx_fft)-angle(I_ry_fft))

I_rx= FFTOperations.ift2(I_rx_fft);
I_ry= FFTOperations.ift2(I_ry_fft);

norm(sign(I_rx)-sign(I_ry),2)

figure(5)
subplot(2,1,1)
imagesc(I_rx)
subplot(2,1,2)
imagesc(I_ry)

I_90deg= sign(I_rx).*sqrt(I_rx.^2+I_ry.^2);


