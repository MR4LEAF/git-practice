% demo of MUSIC (MUltiple SIgnal Classification)  

clear;clc;close all
AddPath();
%%  https://www.zhihu.com/question/31227189/answer/2867512909?utm_id=0

sample_freq = 5000;
t= 0:(1/sample_freq):1.0;
df= sample_freq/numel(t);
f1= 49; % Hz
f2= 51; % Hz
data = 5*sin(2*pi*f1*t) +sin(2*pi*f2*t) + 1e-2*rand(size(t));            % Take from 0.1s to 0.35s

figure(1);clf;set(gcf, 'Color', 'white', 'Position', [500 500 1200 500]);
plot(t,data,'b-');grid on

%%  MUSIC operation

sample_len = length(data);
piece_num = floor(sample_len / 2) - 1;            % Slice signal into pieces
piece_len = sample_len - piece_num + 1;
data_pieces = zeros(piece_len, piece_num);
for i = 1:piece_num
    data_pieces(:, i) = data(i:i+piece_len-1)';
end

Rx = data_pieces * data_pieces' / piece_num;    % Estimate signal correlation matrix
[u, s, v] = svd(Rx);    % SVD decomposition to find noise subspace
s = diag(s);            % Singular values

noise_dim = sum(s < 1);  % Find smallest singular values corresponding to noise space.
p_f = (30:0.05:70)';    % Probe frequency

% Construct probe signal basis
p_sig_basis = cat(3, sin(p_f * (0:1/sample_freq:(piece_len-1)/sample_freq) * 2 * pi), ...
    cos(p_f * (0:1/sample_freq:(piece_len-1)/sample_freq) * 2 * pi));

% Detect MUSIC component
p_mu = sum((p_sig_basis(:, :, 1) * u(:, end-noise_dim+1:end)).^2, 2) + ...
    sum((p_sig_basis(:, :, 2) * u(:, end-noise_dim+1:end)).^2, 2);
p_mu = 1 ./ (p_mu + 1e-8);
p_mu= 100*p_mu/max(p_mu);

%% Continue from the previous code
figure(5);clf;set(gcf, 'Color', 'white', 'Position', [500 500 1200 500]);
subplot(221)
plot(p_f, p_mu);grid on
title('MUSIC Spectrum')
xlabel('Frequency (Hz)')
ylabel('Amplitue/frequency (Hz)')
subplot(223)
plot(p_f, 10 * log10(p_mu));grid on
title('MUSIC Spectrum')
xlabel('Frequency (Hz)')
ylabel('Power/frequency (dB/Hz)')

%% FFT Spectrum
n= numel(data);
data_freq= make_axis_freq(numel(t),1/sample_freq,'01');
data_fft= FT3d(data,'fft')/numel(data);
data_fft_abs= abs(data_fft);
data_fft_abs= data_fft_abs(ceil((n+1)/2):end);
data_fft_abs= data_fft_abs(:);
data_fft_abs= 100*data_fft_abs/max(data_fft_abs);
% plot FFT
figure(5);
subplot(222)
plot(data_freq, data_fft_abs);grid on
title('FFT Amplitude Spectrum of data(t)')
xlabel('Frequency (Hz)');ylabel('Power/frequency Hz')
xlim([0 80])
subplot(224)
plot(data_freq, 10*log10(data_fft_abs));grid on
title('FFT Amplitude Spectrum of data(t)')
xlabel('Frequency (Hz)')
ylabel('Power/frequency (dB/Hz)')
xlim([0 80])
