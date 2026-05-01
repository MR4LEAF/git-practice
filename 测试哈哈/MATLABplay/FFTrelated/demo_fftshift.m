% Generate a time-domain signal
t = linspace(0, 1, 1000);
x = sin(2*pi*50*t) + sin(2*pi*120*t);

% Compute the FFT
X = fft(x);

% Shift the FFT output for better visualization
X_shifted = fftshift(X);

% Plot the frequency spectrum
figure(1);clf
plot(abs(X),'b-');hold on;grid on
plot(abs(X_shifted),'r--')