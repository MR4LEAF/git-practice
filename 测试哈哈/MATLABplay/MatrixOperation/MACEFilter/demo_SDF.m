

clear;clc

%% Load built-in images
image1 = im2double(imread('cameraman.tif'));
image2 = im2double(imread('circles.png'));
image3 = im2double(imread('coins.png'));

% Resize images to have the same size
image1 = imresize(image1, [128 128]);
image2 = imresize(image2, [128 128]);
image3 = imresize(image3, [128 128]);

% Create a 3D array to store the training images
train_images = cat(3, image1, image2, image3);

[M, N, P] = size(train_images);

%% X is  [MN,P]
X = reshape(train_images, [M*N, P]);


%% Column vector
c = ones(P, 1);
c = [1;1;1];

%% ECP-SDF Filter
h = X*pinv(X'*X)*c;
h = reshape(h, [M, N]);
H_freq = fftshift(fft2(ifftshift(h)));

%% Test image for recognition
test_image = image1;

%% Recognition
test_image_freq = fftshift(fft2(ifftshift(test_image)));
output_image_freq = test_image_freq .* conj(H_freq);
output_image = fftshift(ifft2(ifftshift(output_image_freq)));


%% Normalize the output image for display
output_image_norm = abs(output_image) / max(abs(output_image(:)));

%% Display the output image
figure(1);
surf(output_image_norm);
shading interp
title('Output Image with MACE Filter');

% Find the peak response
[max_val, max_idx] = max(output_image_norm(:));
[row, col] = ind2sub(size(output_image_norm), max_idx);
disp(['Max Response: ' num2str(max_val)]);
disp(['Peak Location: (' num2str(row) ', ' num2str(col) ')']);
