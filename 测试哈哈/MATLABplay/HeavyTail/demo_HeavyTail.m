clear;clc;close all
% Load a natural image
img = imread('peppers.png');

% Convert the image to grayscale if it's not
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Convert to double precision for computations
img = im2double(img);

% Compute gradients
[Gx, Gy] = imgradientxy(img);

% Plot histogram of gradients
figure(1);
subplot(1, 2, 1);
histogram(Gx(:), 'Normalization', 'pdf', 'DisplayStyle', 'stairs');
title('Histogram of Image Gradients in X direction');
set(gca, 'YScale', 'log'); % Set the y-axis to log scale

subplot(1, 2, 2);
histogram(Gy(:), 'Normalization', 'pdf', 'DisplayStyle', 'stairs');
title('Histogram of Image Gradients in Y direction');
set(gca, 'YScale', 'log'); % Set the y-axis to log scale
