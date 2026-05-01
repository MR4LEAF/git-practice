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
D= 0;
for i=1:size(train_images,3)
    temp= squeeze(train_images(:,:,i));
    D_temp= fftshift(fft2(ifftshift(temp)));
    X(:,i)= D_temp(:);
    D= D+ (abs(D_temp)).^2;
end

%% Create the diagonal matrix D
D_diag = diag(D(:));
D_diag_inverse= diag(1./D(:));

%% Column vector
c = ones(P, 1);
c = [1;1;1];

%% MACE filter
temp= X'*D_diag_inverse*X;
H = D_diag_inverse*X*inv(temp)*c;
H_freq = reshape(H, [M, N]);

%% Test image for recognition
test_image = image3;

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

%% Find the peak response
psr = calculatePSR(output_image_norm)

