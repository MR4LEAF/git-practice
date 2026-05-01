% Load the image
image0 = im2double(imread('cameraman.tif')); % Replace 'your_image_file.jpg' with the actual file name and path
image0= imresize(image0,[127,127]);

image= zeros(257,257);

pos_x= 66:192;
pos_y= 66:192;
image(pos_x,pos_y)= image0;


% Compute the Fourier transform of the original image
fft_image_original = fftshift(fft2(image));

% Compute the magnitude spectrum of the original image
magnitude_spectrum_original = abs(fft_image_original);

% Rotate the image
rotated_image = imrotate(image, 170, 'bilinear', 'crop');

% Compute the Fourier transform of the rotated image
fft_image_rotated = fftshift(fft2(rotated_image));

% Compute the magnitude spectrum of the rotated image
magnitude_spectrum_rotated = abs(fft_image_rotated);

% Display the original and rotated images
figure(1)
subplot(1, 2, 1);
imagesc(image);
title('Original Image');
subplot(1, 2, 2);
imagesc(rotated_image);
title('Rotated Image');

% Display the magnitude spectra
figure(2);
subplot(1, 2, 1);
imagesc(log(1 + magnitude_spectrum_original));
title('Original Image - Fourier Magnitude Spectrum');
subplot(1, 2, 2);
imagesc(log(1 + magnitude_spectrum_rotated));
title('Rotated Image - Fourier Magnitude Spectrum');

[sum(magnitude_spectrum_rotated(:).^2),sum(magnitude_spectrum_original(:).^2)]