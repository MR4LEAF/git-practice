%%  Demo 2D inverse dftmatrix
clc;clear;close all;
addpath('G:\3-学术\7-Codes\01_m codes\CustomedLibraries\PR_func');
%% Object definition
row_pixel = 128;     % number of image pixels in each dimension
column_pixel= 64;
ifft_amplitude= Generate_obj('cameraman');
ifft_amplitude = imresize(ifft_amplitude,[row_pixel,column_pixel]);
ifft_phase= Generate_obj('cameraman');
ifft_phase = imresize(ifft_phase,[row_pixel,column_pixel]);
ifft_phase = 2*pi*rescale(ifft_phase);
ifft_complex= ifft_amplitude.*exp(1j*ifft_phase);
%% inverse 2-D fft
im_complex= ifft2(ifft_complex);
%% inverse 2-D dftmatrix
W1= dftmtx(row_pixel);
W2= dftmtx(column_pixel);
W1_inverse= conj(W1/row_pixel);
W2_inverse= conj(W2/column_pixel);
W_inverse= kron(W2_inverse,W1_inverse);   % W2_inverse与W1_inverse的1顺序很重要！
%%  
im_complex1= W1_inverse*ifft_complex*W2_inverse;
%%
im_complex2= reshape(W_inverse*ifft_complex(:),[row_pixel column_pixel]);
%%
err1= abs(im_complex1 - im_complex);
err2= abs(im_complex2 - im_complex);
%%
figure(1)
subplot(1,2,1)
imagesc(err1);colorbar
subplot(1,2,2)
imagesc(err2);colorbar

err3= abs(transpose(W_inverse)*ifft_complex(:)-reshape(ifft2(ifft_complex),[row_pixel*column_pixel,1]));

plot(err3)

imagesc(abs(conj(transpose(W_inverse))*W_inverse))