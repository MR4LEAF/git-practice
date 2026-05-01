%% demo
clear;clc;close all

%% Add the directory and its subdirectories to the MATLAB search path
addpath(genpath('E:\MATLAB_codes\CustomedLibraries'));
addpath(genpath('G:\MATLAB_codes\CustomedLibraries'));

addpath('E:\MATLAB_codes\CSI\1-D CSI\FunctionLibrary');
addpath('G:\MATLAB_codes\CSI\1-D CSI\FunctionLibrary');

%% set parameters
[Params]= setParams();
% disp(Params)
%% backgroud
mode= '1';
switch mode
    case {'uniform','0'}
        IB= ones(size(Params.z));
    case {'baseline','1'}
        p = [0.0002 0.02 -0.2 0.5]; % Coefficients for a 2nd order polynomial
        IB= polyval(p, Params.z);
        IB= (IB-min(IB))/max(IB);
        IB = IB + 1;
        IB= IB/max(IB);
end

contrast= 0.1;
lc= 0.5; 
lam= 0.6;
Params.deltaPhi= 0.0*rand()*pi;

I= IB + contrast*IB.*exp(-((Params.z-Params.sampleHeight)/lc).^2).*cos(4*pi/lam*(Params.z-Params.sampleHeight)+Params.deltaPhi);




%%
figure(1);clf
plot(Params.z,IB,'b-');hold on;grid on
plot(Params.z,I,'r--');

%%
figure(5);clf
plot(1e-3*abs((fftshift(fft(ifftshift(IB))))),'b-');hold on;grid on
temp= (I-IB)./IB;
plot(abs((fftshift(fft(ifftshift(temp))))),'r--');

temp_fft_abs= abs((fftshift(fft(ifftshift(temp)))));
temp_fft_abs(1:numel(Params.z)/2)= 0;
[~,index_max]= max(temp_fft_abs);
%%
figure(10);clf
temp_IB= angle((fftshift(fft(ifftshift(IB)))));
temp_truth= angle((fftshift(fft(ifftshift(temp)))));
plot(temp_IB,'b-');hold on;grid on
plot(temp_truth,'r--');
plot([index_max,index_max],[-pi pi],'m:')
xlim([index_max-5, index_max+5])

%%
figure(15);clf
temp_I= angle((fftshift(fft(ifftshift(I)))));
plot(temp_truth,'b-');hold on;grid on
plot(temp_I,'r--');
plot([index_max,index_max],[min(temp_I(index_max-5:index_max+5)),max(temp_I(index_max-5:index_max+5))],'m:','Linewidth',2)

xlim([index_max-5, index_max+5])

%%
figure(20);clf
truth_clip= temp_truth(index_max-5:index_max+5);
temp_I_clip= temp_I(index_max-5:index_max+5);

plot(index_max-5:index_max+5,truth_clip,'b-');hold on;grid on
plot(index_max-5:index_max+5,temp_I_clip,'r--');grid on
plot([index_max,index_max],[min(temp_I_clip),max(temp_I_clip)],'m:','Linewidth',2)


p_truth= polyfit(index_max-5:index_max+5,truth_clip,1)

p_I= polyfit(index_max-5:index_max+5,unwrap(temp_I_clip),1)


