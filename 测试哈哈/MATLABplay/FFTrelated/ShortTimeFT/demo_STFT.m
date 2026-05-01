% demo  short-time Fourier transform

clear;clc;close all


% Define the time vector
Fs = 1000;                  % Sampling frequency
t = 0:1/Fs:1-1/Fs;          % Time vector

% Create signal
f1 = 10;                    % Frequency of the first sine wave
f2 = 30;                    % Frequency of the second sine wave
f3 = 60;                    % Frequency of the third sine wave

% Create the continuous sine waves
sine1 = sin(2*pi*f1*t);
sine2 = sin(2*pi*f2*t);
sine3 = sin(2*pi*f3*t);

% Create time masks
mask1 = [ones(1,round(length(t)/3)), zeros(1,length(t)-round(length(t)/3))];
mask2 = [zeros(1,round(length(t)/3)), ones(1,round(length(t)/3)+1), zeros(1,round(length(t)/3))];
mask3 = [zeros(1,2*round(length(t)/3)), ones(1,length(t)-2*round(length(t)/3))];

% Apply the masks to the sine waves
signal1 = sine1.*mask1;
signal2 = sine2.*mask2;
signal3 = sine3.*mask3;

% Combine the signals
signal = signal1 + signal2 + signal3;

%%
figure(1);clf
plot(t,signal)
xlabel('Time (s)');
ylabel('signal');

% Compute the short-time Fourier transform
windowSize = 128;           % Size of the window function for STFT
overlap = round(windowSize/2);   % Overlap of the window function
nfft = 1024;                % Number of points in the FFT

[s, f, t] = spectrogram(signal, windowSize, overlap, nfft, Fs);

%% Visualize the results
figure(10);clf
imagesc(t, f, 10*log10(abs(s)));   % Convert to decibel scale
axis xy;                          % Flip the axis so lower frequencies are at the bottom
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;                         % Show color scale
title('Spectrogram of the Signal');


%% Set the maximum frequency for the data clipping
maxFreq = 100; % Set your maximum frequency here

% Find the index of the maximum frequency
maxFreqIdx = find(f <= maxFreq, 1, 'last');

% Create new figure
figure(20);clf

% Display the clipped spectrogram
imagesc(t, f(1:maxFreqIdx), 10*log10(abs(s(1:maxFreqIdx,:))));

% Set the axis and labels
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;
title('Spectrogram of the Signal (clipped)');
