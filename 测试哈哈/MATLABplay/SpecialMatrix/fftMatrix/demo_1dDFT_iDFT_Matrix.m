%% Demo 1-D dftmtx and its Inverse
clc; clear; close all;

%% Section 1: Demo 1-D dftmtx
disp('Running Section 1: Demo 1-D dftmtx...');

N = 256; 
x = (1:N).'; 
fft_X = fft(x);

W = dftmtx(N);
fft_X1 = W * x;

err = fft_X1 - fft_X;

norm(err,2)

disp(['coherence between matrix W and W =',num2str(calc_MatrixCoherence(W,W))])
disp(['coherence between matrix I and W =',num2str(calc_MatrixCoherence(eye(size(W)),W))])
disp(['coherence between matrix W and random =',num2str(calc_MatrixCoherence(randn(size(W)),W))])

isToeplitzCirculant(W)



%%
P_ifftshift = speye(N);
P_ifftshift = P_ifftshift(ifftshift(1:N), :);
P_fftshift = speye(N);
P_fftshift = P_fftshift(fftshift(1:N), :);

W_shifted = P_fftshift * W * P_ifftshift;

fft_X= fftshift(fft(ifftshift(x)));

fft_X1= W_shifted*x;



err = fft_X1 - fft_X;

norm(err,2)












%% Section 2: Demo Inverse 1-D dftmtx
disp(' ');
disp('Running Section 2: Demo Inverse 1-D dftmtx...');

% Update N for the inverse DFT

ifft_x = ifft(x);

W = dftmtx(N);
W_inverse = conj(W / N);
ifft_x1 = W_inverse * x;

err = ifft_x1 - ifft_x;

norm(err,2)


%
imagesc(abs(W*W_inverse))