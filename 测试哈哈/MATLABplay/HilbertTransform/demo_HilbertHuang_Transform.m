
clear;clc;close all

% Load the image
img = imread('cameraman.tif');

% Convert the image to double precision
img = double(img);

% Initialize an empty array for the transformed image
img_transformed = zeros(size(img));

% Apply the Hilbert-Huang Transform to each row of the image
for i = 1:size(img, 1)
    % Get the current row
    row = img(i, :);
    
    % Decompose the row into intrinsic mode functions (IMFs) using EMD
    imfs = emd(row);
    
    % Apply the Hilbert transform to each IMF
    for j = 1:size(imfs, 1)
        imfs(j, :) = hilbert(imfs(j, :));
    end
    
    % Sum the IMFs to get the transformed row
    transformed_row = sum(imfs, 1);
    
    % Pad the transformed row with zeros if necessary
    if length(transformed_row) < size(img, 2)
        transformed_row = [transformed_row, zeros(1, size(img, 2) - length(transformed_row))];
    end
    
    % Assign the transformed row to the transformed image
    img_transformed(i, :) = transformed_row;
end

% Display the original and transformed images
figure(1);clf
subplot(1, 2, 1);
imagesc(img);colorbar
title('Original Image');

subplot(1, 2, 2);
imagesc(log(1+abs(img_transformed)));
title('Hilbert-Huang Transformed Image');colorbar
