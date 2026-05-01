% demo Hadamard

clear; close all


N = 32; % Size of the matrices (should be a power of 2)

% Generate the original Hadamard matrix
H = hadamard(N);

%% Generate the H+ matrix
Hplus = H;
Hplus(Hplus == -1) = 0;

%% Generate the H- matrix
Hminus = H;
Hminus(Hminus == 1) = 0;
Hminus(Hminus == -1) = 1;

%
figure(1);clf
imagesc(H)
title('Hadamard')

%
figure(2);clf
imagesc(Hplus)
title('Hadamard+')

%
figure(3);clf
imagesc(Hminus)
title('Hadamard-')


%
err= H -(Hplus-Hminus);

norm(err,'fro')