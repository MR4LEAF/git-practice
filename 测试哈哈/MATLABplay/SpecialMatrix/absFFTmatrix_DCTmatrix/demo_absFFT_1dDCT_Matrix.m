%% Demo of absFFT vs 1d DCT 
clc; clear; close all;


N = 256; 

W1 = dftmtx(N);

W2 = dctmtx(N);

norm(W1-W2,'fro')

imagesc(abs(W1))




