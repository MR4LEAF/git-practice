% demo 1-d fft vs 3-d fft

clc; close all

I_tensor= rand(201,201,582);

% 3-d FFT of 3-d tensor 
I_tensor_fft= fftshift(fftn(ifftshift(I_tensor)));

% apply 1-d fft along different dimensions
temp3= fftshift(fft(ifftshift(I_tensor),[],3));
temp2= fftshift(fft(ifftshift(temp3),[],2));
I_tensor_1dfft= fftshift(fft(ifftshift(temp2),[],1));


norm(I_tensor_fft - I_tensor_1dfft,'fro')/norm(I_tensor_fft,'fro')


%% the 3D FFT is essentially a decomposition of the tensor into 
%% its frequency components along the three dimensions, achieved by
%% applying 1D FFTs successively along each dimension.



