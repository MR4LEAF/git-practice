% Demo of Hilbert transform

% Define the input signal, for example, a sinusoidal signal
Fs = 1000;            % Define the sampling frequency in Hz
T = 1/Fs;             % Define the sampling period in seconds
L = 1000;             % Define the length of the signal
t = (0:L-1)*T;        % Create a time vector
f = 5;                % Define the frequency of the sinusoid in Hz
input_signal = sin(2*pi*f*t); % Create a sinusoidal signal

% Calculate the Hilbert Transform using the built-in "hilbert" function
built_in_hilbert_transform = hilbert(input_signal);  % a= f(x)+ i H{f(x)} 

% Plot the original signal and the real and imaginary parts of the Hilbert Transform
figure(1);
subplot(3,1,1);
plot(t, input_signal);
title('Original Signal (Sine)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, real(built_in_hilbert_transform));
title('Built-in Hilbert Transform - Real Part');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, imag(built_in_hilbert_transform));
title('Built-in Hilbert Transform - Imaginary Part');
xlabel('Time (s)');
ylabel('Amplitude');

%% calculate phase with Hilbert Transform
phi=unwrap_phase(atan2(imag(built_in_hilbert_transform),real(built_in_hilbert_transform)));
z= phi-2*pi*f*t; % difference between input phase and out put phase
figure(2)
plot(t, z);
title('phase');
xlabel('Time (s)');
ylabel('Phase');

% Calculate the Fast Fourier Transform (FFT) of the input signal
N = length(input_signal);    % Determine the length of the input signal
fft_signal = fftshift(fft(ifftshift(input_signal))); % Apply FFT after and before shifting the input signal

% Create a frequency-domain filter for the Hilbert Transform
hilbert_filter(1:ceil(N/2)) = 1i;  % Multiply positive frequencies by 1i
hilbert_filter(ceil(N/2)+1) = 0;
hilbert_filter(ceil(N/2)+2:N) = -1i; % Multiply negative frequencies by -1i

% Plot the Hilbert filter in the Fourier domain
figure(3);clf
plot(hilbert_filter/1i)
title('Hilbert filter in Fourier domain')

% Apply the filter to the FFT signal
filtered_fft_signal = fft_signal .* hilbert_filter;

% Calculate the inverse FFT to obtain the Hilbert Transform
custom_hilbert_transform = fftshift(ifft(ifftshift(filtered_fft_signal)));
custom_hilbert_transform= real(custom_hilbert_transform); % it should be a real-valued function

% Compare the results of the built-in and custom Hilbert Transforms
comparison_error = norm(custom_hilbert_transform - imag(built_in_hilbert_transform))/norm(imag(built_in_hilbert_transform));
disp(['Comparison error: ', num2str(comparison_error)]);

% Plot the results
figure(3);
subplot(2,1,1);
plot(t, input_signal);
title('Original Signal (Sine)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t,imag(built_in_hilbert_transform),'b-');hold on;grid on
plot(t, custom_hilbert_transform,'r--');
legend('Built-in Hilbert Transform - Imaginary Part','Custom Hilbert Transform ');
xlabel('Time (s)');
ylabel('Amplitude');


%%  
theta= atan(custom_hilbert_transform./input_signal);

theta_unwrap= unwrap(theta,pi);

figure(3);clf
subplot(2,1,1)
plot(t,theta,'b-')
subplot(2,1,2)
plot(t,theta_unwrap,'b-')