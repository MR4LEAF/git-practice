function R = riesz_transform(f)
    % Compute the Fourier transform of the input function
    F = fftshift(fft2(ifftshift(f)));

    % Create a grid of frequencies
    [ny, nx] = size(f);
    [kx, ky] = meshgrid((-nx/2):(nx/2-1), (-ny/2):(ny/2-1));

    % Compute the frequency magnitude, avoiding division by zero
    k_mag = sqrt(kx.^2 + ky.^2);
    k_mag(k_mag == 0) = 1;

    % Compute the Riesz transform in the Fourier domain
    R1 = fftshift(ifft2(ifftshift(1i * kx ./ k_mag .* F)));
    R2 = fftshift(ifft2(ifftshift(1i * ky ./ k_mag .* F)));

    % Combine the components into a vector field
    R = cat(3, real(R1), real(R2));
end
