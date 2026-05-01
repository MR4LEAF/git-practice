%% demo fft of 1-D phase sine grating

clear;clc;close all
AddPath();
%%

dx= 0.1;
L= 30;
Period= 5; 
x=-L:dx:L;
PV= 0.3;
y= exp(1j*(PV/2)*cos(2*pi*x/Period));
%%

figure(1);clf
plot(x,angle(y))

y_fft= FT3d(y.*hann(numel(y)).','fft');

n= numel(x);
kx= -((n-1)/2):1:(n-1)/2;
kx= kx*(1/dx/n);

%%
figure(2);clf
% plot(kx,log(1+abs(y_fft)))
temp= abs(y_fft);
N= numel(kx);
temp((N+mod(N,2))/2-5:(N+mod(N,2))/2+5)= 0;
plotyy(kx,temp,kx,angle(y_fft));grid on

grid on
xlim([-0.5 0.5])


