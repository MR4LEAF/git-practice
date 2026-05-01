clear; clc

im= imread('cameraman.tif');
im= im2double(im);
im= imcrop(im,[3,5,124,220]);
[Nx,Ny]= size(im);

% spatial domain
E_spatial= norm(im,'fro').^2

% spatial frequency domain
im_fft= fft2(im)/sqrt(Nx.*Ny);

E_spatialfrequency= norm(im_fft,'fro').^2


