%% demo fft of 2-D sine 
clear;close all
dx= 0.01;
L= 10;
x=-L:dx:L;
y= x;

[X,Y]= meshgrid(x,y);

z= sin(2*pi*X/10);

% z= sin(2*pi*X/10).*sin(2*pi*Y/10);

%%
figure(1)
imagesc(x,y,z)

%%
z_fft= fftshift(fft2(z));

n= numel(x);
Kx_1D= -((n-1)/2):1:(n-1)/2;
Kx_1D= Kx_1D*(1/dx/n);

Ky_1D= Kx_1D;

[Kx,Ky]= meshgrid(Kx_1D,Ky_1D);

%%
figure(2);clf
surf(Kx,Ky,log(1+abs(z_fft)))
shading interp

%%
figure(3);clf
temp= z_fft;
temp= 1e2*temp/max(abs(temp(:)));
imagesc(Kx_1D,Ky_1D,log(1+abs(temp)));colorbar;grid on
