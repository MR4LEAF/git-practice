% demo of a half-Gaussian filter
clear

%% Load an example image
image = imread('cameraman.tif');
image= double(image);
figure(1);clf
imagesc(image);
title('Original Image');

%% Apply a half-Gaussian filter
sigma = 2; % Standard deviation of the Gaussian distribution
filterSize = 5; % Size of the filter kernel
halfFilterSize = floor(filterSize/2);

% Generate the half-Gaussian filter kernel
filter = fspecial('gaussian', [1 filterSize], sigma);
filter = filter(1:halfFilterSize+1);

%%
figure(2);clf
imagesc(filter)

% Apply the filter to the image using imfilter
filteredImage = imfilter(image, filter, 'replicate');

%% Display the filtered image
figure(3);clf
imshow(filteredImage);
title('Filtered Image');
