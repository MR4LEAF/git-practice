%  Fourier transforms of periodic repetitions are themselves repetitions.

clear;clc;
AddPath();
%%

Nx= 501; Ny= 501; Nz= 582;

w= rand(Nx,Ny);
w_3D= repmat(w,[1,1,Nz]);

%%
w_fft= FT3d(w,'fft');
w_fft_3D= repmat(w_fft,[1,1,Nz]);

w_3D_fft= FT3d(w_3D,'fft');


err= norm(w_fft_3D - w_3D_fft , 'fro')


disp(['The statement "Fourier transforms of periodic repetitions...' ...
    ' are themselves repetitions" is not correct in general.'])
