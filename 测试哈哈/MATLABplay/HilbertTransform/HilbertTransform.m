% demo of Hilbert transform
clear;clc;close all
% Define the input signal, for example, a sinusoidal signal
Fs = 1000;            % Sampling frequency (Hz)
T = 1/Fs;             % Sampling period (s)
L = 1000;             % Length of the signal
t = (0:L-1)*T;        % Time vector
f = 5;                % Frequency of the sinusoid (Hz)
input_signal = sin(2*pi*f*t);

% Calculate the Fast Fourier Transform (FFT) of the input signal
N = length(input_signal);    % Length of the input signal
fft_signal = fft(input_signal);

% Calculate the Hilbert Transform using the built-in "hilbert" function
built_in_hilbert_transform = hilbert(input_signal);


% Plot the results
figure;
plot(t, input_signal,'b-');hold on;grid on
plot(t, real(built_in_hilbert_transform),'r--');
plot(t, imag(built_in_hilbert_transform),'m:');
legend('Original Signal (Sine)','Built-in Hilbert Transform - Real Part (Cosine)','Built-in Hilbert Transform - Imaginary Part (Cosine)');
xlabel('Time (s)');
ylabel('Amplitude');


%% Hilbert kernel
x= -10:0.1:10;
temp= x; temp(temp==0)= eps;
kernel= 1./temp;kernel(x==0)= 0;
kernel_fft= FFTOperations.ft(kernel);

figure(2);clc
subplot(3,1,1)
plot(x,kernel)
subplot(3,1,2)
plot(abs(kernel_fft))
subplot(3,1,3)
plot(angle(kernel_fft))
