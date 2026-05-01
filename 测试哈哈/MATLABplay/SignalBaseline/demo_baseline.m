%% demo
clear;clc;close all

%%
x = -10:0.1:10; % x values
p = [0.0002 0.001 -0.02 0.1]; % Coefficients for a 2nd order polynomial
y_base = polyval(p, x);
y_base= y_base/max(y_base);

y_Gauss= exp(-(x-rand()).^2/2);

%%
figure(1);clf
plot(x,y_base,'b-');hold on;grid on
plot(x,y_Gauss,'r--');

%%
figure(5);clf
plot(abs((fftshift(fft(ifftshift(y_base))))),'b-');hold on;grid on
plot(abs((fftshift(fft(ifftshift(y_Gauss))))),'r--');


%%
figure(10);clf
plot(angle((fftshift(fft(ifftshift(y_base))))),'b-');hold on;grid on
plot(angle((fftshift(fft(ifftshift(y_Gauss))))),'r--');

xlim([101-5, 101+5])