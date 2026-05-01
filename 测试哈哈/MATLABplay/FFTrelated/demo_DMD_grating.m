%% demo DMD grating

clear;clc;close all

% Define grating parameters
Period = 5; % Frequency of the grating
phase = 0; % Phase of the grating
sizeX = 1000; % Width of the grating in pixels
sizeY = 800; % Height of the grating in pixels

% Create a meshgrid for the grating
[X, Y] = meshgrid(1:sizeX, 1:sizeY);

% Calculate the grating pattern
grating_x = 0.5 + 0.5 * cos(2 * pi * X / Period + phase);

grating_y = 0.5 + 0.5 * cos(2 * pi * Y / Period + phase);

grating= grating_x.*grating_y;

% Duty cycle of the grating
dutyCycle= 0.8; 

% Apply the threshold to make the grating binary with the specified duty cycle
grating = grating > dutyCycle;
%% Display the grating
figure(1);
imagesc(grating);
colormap('gray');
% axis image off;

%%
figure(2)
grating_fft= FT3d(grating,'fft');

vkx= make_axis_freq(sizeX,1,'101');
vky= make_axis_freq(sizeY,1,'101');


imagesc(vky,vkx,log(1+abs(grating_fft)));
colormap('gray');

%axis image off;
%%
figure(3);clf
plot(1:sizeX,grating(401,:))
xlim([20 50])
%%
figure(4)
plot(vkx,log(1+abs(grating_fft(401,:))))

