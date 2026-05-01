%% Demo 2D dftmatrix
clc;clear;close all;
%% Object definition
num_pixel = 64; % number of image pixels in each dimension
im= Generate_obj('cell');
im_amplitude = imresize(im,[num_pixel,num_pixel]);
% im_amplitude= 255*im_amplitude./max(im_amplitude(:));
im_phase= Generate_obj('cameraman');
im_phase = imresize(im_phase,[num_pixel,num_pixel]);
im_phase= 2*pi*rescale(im_phase);
im_complex= im_amplitude.*exp(1j*im_phase);
%% illumination  patterns
num_pattern = 3;   % number of illumination patterns
patterns= generate_patterns(im_complex,num_pattern,'Binary random + complementary');
%% forward model
for i=1:num_pattern
    probe= patterns(:,:,i);
    u_p= im_complex.*probe +eps;
    I0= (abs(fftshift(fft2(u_p)))).^2;
    Istack(:,:,i)= I0;
end
%%   2-D dftmaxtrix
W1= dftmtx(num_pixel);
W2= dftmtx(num_pixel);
W= kron(W1,W2);     %  transpose(W)=W 

for i=1:num_pattern
    probe= patterns(:,:,i);
    u_p= im_complex.*probe +eps;
    fft_u_p= reshape(W*u_p(:),[num_pixel num_pixel]);
    I0= (abs(fftshift(fft_u_p))).^2;
    Istack1(:,:,i)= I0;
end

for i=1:num_pattern
    probe= patterns(:,:,i);
    D= diag(probe(:));
    fft_u_p= reshape(W*D*im_complex(:),[num_pixel num_pixel]);
    I0= (abs(fftshift(fft_u_p))).^2;
    Istack2(:,:,i)= I0;
end
%%
err1= Istack1(:)-Istack(:);
err2= Istack2(:)-Istack(:);
%%
figure(1);clf
subplot(1,2,1)
plot(err1,'b-'); 
subplot(1,2,2)
plot(err2,'r--'); 

[mean( abs(err1)),std( abs(err1))]

[mean( abs(err2)),std( abs(err2))]

