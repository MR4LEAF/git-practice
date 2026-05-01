% Define the parameters for the sine wave
Fs = 1000; % Sampling frequency                    
T = 1/Fs; % Sampling period       
L = 1500; % Length of signal
t = (0:L-1)*T; % Time vector

% Create the sine wave
f = 50; % Frequency of the sine wave
A = 0.7; % Amplitude of the sine wave
phi = pi/4; % Phase of the sine wave
x = A*sin(2*pi*f*t + phi); 

% Compute the FFT of the signal
Y = fft(x);

% Compute the two-sided spectrum P2
P2 = abs(Y/L);

% Compute the single-sided spectrum P1 based on P2 and the even-valued signal length L
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Define the frequency domain f
f = Fs*(0:(L/2))/L;

% Compute the phase of the signal
phase = angle(Y(1:L/2+1));

% Plot the single-sided amplitude spectrum and phase
figure;
subplot(2,1,1);
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(2,1,2);
plot(f,phase)
title('Phase Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('Phase (radians)')
