%% demo correlation
% correlation is matched spatial filter

clear;clc


%%
X= rand(100,100);


Y= X + 0.01*rand(size(X));

%% convolution
outputImage_convolution= FT3d(FT3d(X,'fft').*FT3d(Y,'fft'),'ifft');

outputImage_convolution= abs(outputImage_convolution);

%% correlation 

outputImage_correlation= FT3d(FT3d(X,'fft').*conj(FT3d(Y,'fft')),'ifft');

outputImage_correlation= abs(outputImage_correlation);
%% 
figure(1);clf
subplot(211)
surf(outputImage_convolution)
shading interp
subplot(212)
surf(outputImage_correlation)
shading interp


%  this is Matched Filter in CMU course 