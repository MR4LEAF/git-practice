
clear;clc;close all


%
N= 1280;
M= 1024;

x= -((M-mod(M,2))/2)*1:1:((M+mod(M,2))/2-1)*1;
y= -((N-mod(N,2))/2)*1:1:((N+mod(N,2))/2-1)*1;
[X,Y]= meshgrid(y,x);

phase= peaks(X/200,Y/200)/5;
phase=phase-mean(phase(:));
E_obbj= 5+6*exp(1i*phase);
I= (abs(E_obbj)).^2;

%%
% fft of inteferogram
I_fft= fftshift(fft2(ifftshift(I)));


% Riesz kernel
temp= sqrt(X.^2+Y.^2);temp(temp==0)= 1;
rx= (X)./(2*pi*temp.^3);
ry= (Y)./(2*pi*temp.^3);

% fft of rx & ry
% rx_fft= fftshift(fft2(ifftshift(rx)));
% ry_fft= fftshift(fft2(ifftshift(ry)));
temp= sqrt(temp);
rx_fft= -1i*X./temp;
ry_fft= -1i*Y./temp;



% f1 & f2
f1_fft=  rx_fft.*I_fft;
f2_fft=  ry_fft.*I_fft;


f1= fftshift(ifft2(ifftshift(f1_fft)));
f2= fftshift(ifft2(ifftshift(f2_fft)));

f1= real(f1);
f2= real(f2);


I_90deg= sign(f1).*sqrt(f1.^2+f2.^2);

% f3,f4,f5
f3_fft= rx_fft.*rx_fft.*I_fft;
f4_fft= ry_fft.*rx_fft.*I_fft;
f5_fft= ry_fft.*ry_fft.*I_fft;

f3= fftshift(ifft2(ifftshift(f3_fft)));
f4= fftshift(ifft2(ifftshift(f4_fft)));
f5= fftshift(ifft2(ifftshift(f5_fft)));

f3= real(f3);
f4= real(f4);
f5= real(f5);


I_180deg= sign(f3).*(f3+f5);

% f6,f7,f8,f9
f6_fft= rx_fft.*rx_fft.*rx_fft.*I_fft;
f7_fft= rx_fft.*rx_fft.*ry_fft.*I_fft;
f8_fft= rx_fft.*ry_fft.*ry_fft.*I_fft;
f9_fft= ry_fft.*ry_fft.*ry_fft.*I_fft;


f6= fftshift(ifft2(ifftshift(f6_fft)));
f7= fftshift(ifft2(ifftshift(f7_fft)));
f8= fftshift(ifft2(ifftshift(f8_fft)));
f9= fftshift(ifft2(ifftshift(f9_fft)));

f6= real(f6);
f7= real(f7);
f8= real(f8);
f9= real(f9);


I_270deg= sign(f9).*sqrt(f6.^2+f9.^2);

% four-step phase shifting algorithm 

phase_r= atan2(I-I_180deg,I_270deg-I_90deg);

figure(77)
subplot(2,1,1)
imagesc(I-I_180deg)
subplot(2,1,2)
imagesc(I_270deg-I_90deg)


figure(88)
subplot(2,1,1)
imagesc(phase);colorbar
title('Truth')
subplot(2,1,2)
imagesc(phase_r);colorbar
title('Reconverd')

[mm_x,mm_y]= gradient(phase);
figure(99)
imagesc(sqrt(mm_x.^2+mm_y.^2))


figure(111)
subplot(2,2,1)
imagesc(I);colorbar
subplot(2,2,2)
imagesc(I_90deg);colorbar
subplot(2,2,3)
imagesc(I_180deg);colorbar
subplot(2,2,4)
imagesc(I_270deg);colorbar
