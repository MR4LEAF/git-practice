% demo 1-d fft vs 3-d fft

clear; clc; close all

% Foil & m3ft_Foil
NA= 0.55; Nx= 201; Ny= 201; Nz= 582; pxlsize= 5.86/50; Zstep= 0.55/8;
[instrumparam,ctrl,DataAttr,coord,surfparam,FDAparam]= Set_structuralParameter(NA,Nx,Ny,Nz,pxlsize,Zstep);
ctrl.switch_PhaseBlur= 0;
surfparam.type= 'Sine wave (x)';                %  'Plane'   'Step height'  'Sine wave (x)' 'Sine wave (y)' 'Sphere'      
surfparam.PV= 0.3;
surfparam.Period= 10;

[mheight] = SurfaceTopoGenerator(coord.vx,coord.vy,surfparam);
[m3Foil,m3ft_Foil] = FoilGenerator(mheight,instrumparam,surfparam,coord,ctrl);
m3Foil= permute(m3Foil,[2,3,1]);
m3ft_Foil= permute(m3ft_Foil,[2,3,1]);

% monochromatic TF 
instrumparam.z_defocus= 0;
vk0= 1/0.55;
bandNum= 1;
[vk0_band,mask,TFs]= create_bandTFs(vk0,bandNum,instrumparam,coord,'1');
TF= TFs{1};
PSF= FT3d(TF,'ifft');
RH_tensor= real(PSF);
TF_new= FT3d(RH_tensor,'fft');

% I_tensor
I_tensor= FT3d(m3ft_Foil.*TF_new,'ifft');


% 3d-FFT of I_tensor
I_tensor_1dfft= fftshift(fft(ifftshift(I_tensor),[],3));

% apply 1-d fft along different dimensions
Foil_1dfft= fftshift(fft(ifftshift(m3Foil),[],3));
RH_tensor_1dfft= fftshift(fft(ifftshift(RH_tensor),[],3));

%% 
clc

norm(I_tensor_1dfft - Foil_1dfft.*RH_tensor_1dfft,'fro')

norm(I_tensor_1dfft - ift2(ft2(Foil_1dfft).*ft2(RH_tensor_1dfft)),'fro')


%%


figure(1);clf;set(gcf, 'Color', 'white')
subplot(1,3,1)
dims= 3;
m3Foil_1dfft= fftshift(fft(ifftshift(m3Foil),[],dims));
temp= squeeze(abs(m3Foil_1dfft(:,ceil(Ny/2),:))).';
imagesc(temp)
set(gca, 'YDir', 'normal');
title('1-d FFT of Foil')

subplot(1,3,2)
RH_tensor_1dfft= fftshift(fft(ifftshift(RH_tensor),[],dims));
temp= squeeze(abs(RH_tensor_1dfft(:,ceil(Ny/2),:))).';
imagesc(temp)
set(gca, 'YDir', 'normal');
title('1-d FFT of RHtensor')

subplot(1,3,3)
I_tensor_1dfft= fftshift(fft(ifftshift(I_tensor),[],dims));
temp= squeeze(abs(I_tensor_1dfft(:,ceil(Ny/2),:))).';
imagesc(temp)
set(gca, 'YDir', 'normal');
title('1-d FFT of Itensor')


figure(2);clf;set(gcf, 'Color', 'white')
subplot(1,3,1)
m3Foil_1dfft= fftshift(fft(ifftshift(m3Foil),[],dims));
temp= squeeze(abs(m3Foil_1dfft(ceil(Nx/2),:,:))).';   
imagesc(temp)
set(gca, 'YDir', 'normal');
title('1-d FFT of Foil')

subplot(1,3,2)
RH_tensor_1dfft= fftshift(fft(ifftshift(RH_tensor),[],dims));
temp= squeeze(abs(RH_tensor_1dfft(ceil(Nx/2),:,:))).';
imagesc(temp)
set(gca, 'YDir', 'normal');
title('1-d FFT of RHtensor')

subplot(1,3,3)
I_tensor_1dfft= fftshift(fft(ifftshift(I_tensor),[],dims));
temp= squeeze(abs(I_tensor_1dfft(ceil(Nx/2),:,:))).';
imagesc(temp)
set(gca, 'YDir', 'normal');
title('1-d FFT of Itensor')
