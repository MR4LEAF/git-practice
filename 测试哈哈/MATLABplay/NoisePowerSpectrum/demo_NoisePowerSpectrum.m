% Number of samples
N = 2^15;

% Generate white Gaussian noise
noise = randn(1, N);

% Compute FFT of the noise
noise_fft = fft(noise);

% Compute the magnitude squared (power spectrum)
psd = abs(noise_fft).^2 / N;

% Plot the PSD
frequencies = linspace(0, 1, N);
plot(frequencies, 10*log10(psd));
xlabel('Normalized Frequency (x \pi rad/sample)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of White Gaussian Noise');
grid on;
