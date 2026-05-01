%
% This source code is freely distributed from the "colormonogenic" website:
% http://xlim-sic.labo.univ-poitiers.fr/projets/colormonogenic/
% published in 2018,
% which presents the main research results by 
% Raphaël Soulard & Philippe Carré,
% from the XLIM Laboratory (UMR CNRS 7252),
% University of Poitiers, France.
%
% Author: R. Soulard.
%

% No dependency

% ----------------------------------------------------------------- %
% Script to illustrate the Riesz transform
% ----------------------------------------------------------------- %

im = double(imread('cameraman.tif'))/255; im=im(:,:,1);

[M,N] = size(im);

% Frequency coordinates:
[W1,W2] = ndgrid(  (-floor(M/2):ceil(M/2)-1)/M  ,...
                   (-floor(N/2):ceil(N/2)-1)/N  );

% ----------------------------------------------------------------- %
% Isotropic linear-phase band-pass 2d filter in the FFT domain.
% ----------------------------------------------------------------- %

% Define 4 frequency bounds:
tmp = 2*pi/min(M,N); % amount of radians for one Fourier discrete coordinate
a1 =  1*tmp;  % Gain=0 in freqs [0;a1]
a2 =  8.8*tmp;  % Gain rises from freqs   a1 to a2
a3 = 16.8*tmp;   % Gain=1 from frequencies a2 to a3
a4 = 32*tmp;   % Gain falls from 1 to 0 in freqs [a3;a4]
% The frequency response is 0 in [0;a1], rises in [a1,a2] up to 1 in [a2;a3]
%                                 and falls in [a3;a4] down to 0 in [a4;Inf]
% Radial frequency coordinate (in radians):
RHO  = ifftshift(  2*pi*sqrt( W1.^2 + W2.^2 )  );
mask = RHO; % init frequency response
mask(RHO<=a1) = 0;
idx = RHO>a1 & RHO<a2;
mask(idx) = 0.5 + 0.5*sin(  -(pi/2) + pi*(RHO(idx)-a1)/(a2-a1)  );
mask(RHO>=a2 & RHO<=a3) = 1;
idx = RHO>a3 & RHO<a4;
mask(idx) = sin(  (pi/2)*(  1  -  (RHO(idx)-a3)/(a4-a3)  )  );
mask(RHO>=a4) = 0;

% ----------------------------------------------------------------- %
% Perform Riesz transform on the input image.
% ----------------------------------------------------------------- %

% Numerical approximation of the Riesz transform in the FFT domain:
RZ = ifftshift(  -1i * exp(  1i*atan2(W2,W1)  )    ); 

SP = fft2(im); % input image FFT
prim = real(ifft2( SP .* mask )); % bandpass filtering
riz = ifft2( SP .* mask .* RZ ); % Riesz transform

riz1 = real(riz);  % Riesz x-component
riz2 = imag(riz);  % Riesz y-component
rizN = abs(riz);   % Riesz norm
rizA = angle(riz); % Riesz direction

% ----------------------------------------------------------------- %
% Generate illustrations of the result.
% ----------------------------------------------------------------- %

figure;
imshow( [ im , 0.5+0.5*[prim,riz1,riz2] ] );
title('band-pass filtering, Riesz x-component, Riesz y-component');

figure;
imshow(  1-rizN/max(rizN(:))  );
title('Riesz norm (high values in black)');

figure;
hsvmat = ones(M,N,3);
hsvmat(:,:,1) = abs(rizA)/pi; % Riesz direction as hue
hsvmat(:,:,2) = rizN/max(rizN(:)); % Riesz norm as saturation (whiten angles tied to small norms)
imshow(hsv2rgb(hsvmat));
title('Riesz direction (angle as hue)');

% imwrite(0.5+0.5*prim          ,'rz1.png');
% imwrite(0.5+0.5*riz1          ,'rzx.png');
% imwrite(0.5+0.5*riz2          ,'rzy.png');
% imwrite(  1-rizN/max(rizN(:)) ,'rzn.png');
% imwrite(  hsv2rgb(hsvmat)     ,'rzd.png');
