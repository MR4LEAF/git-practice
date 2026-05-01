function [denoised_image, noise] = simplified_wiener2(noisy_image, filter_window)
    % Check if the input image is a 2D array
    if (ndims(noisy_image) ~= 2)
        error('Input image must be a 2D array.');
    end
    
    % Convert the input image to double data type for computation
    noisy_image = double(noisy_image);
    
    % Define the filter window size
    M = filter_window(1);
    N = filter_window(2);
    
    % Create a kernel filled with ones of size [M, N]
    kernel = ones(M, N) / (M * N);
    
    % Step 1: Estimate the local mean of the noisy image
    local_mean = filter2(kernel, noisy_image, 'same');
    
    % Step 2: Estimate the local variance of the noisy image
    local_variance = filter2(kernel, noisy_image.^2, 'same') - local_mean.^2;
    
    % Step 3: Estimate the noise variance
    noise = mean(local_variance(:));
    
    % Step 4: Compute the Wiener filter
    ratio = max(local_variance - noise, 0) ./ (local_variance + eps);
    denoised_image = local_mean + ratio .* (noisy_image - local_mean);
    
    % Convert the denoised image back to the original data type
    denoised_image = cast(denoised_image, class(noisy_image));
end
