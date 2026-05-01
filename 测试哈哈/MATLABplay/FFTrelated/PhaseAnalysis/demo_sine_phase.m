%% demo fft of sine 

addpath(genpath('E:\MATLAB_codes\CSI\3-D virtualCSI\CSI_src'));
addpath(genpath('G:\MATLAB_codes\CSI\3-D virtualCSI\CSI_src'));

%%
dx= 0.3906;
N= 2^8;
vx= make_axis_spatial(N,dx,'101');
phi= randn*pi;
f= 0.1;
y= sin(2*pi*f*vx + phi) ;  % sin(2*pi*f*vx + pi/2 + phi-pi/2)

y= y+ 0.05*rand(size(y));

figure(1);clf
plot(vx,y);grid on

%%
y_fft= FT3d(y,'fft');
vkx= make_axis_freq(N,dx,'101');

tol = 1e-6;
y_fft(abs(y_fft) < tol*max(abs(y_fft))) = 0;

y_fft_abs= abs(y_fft);



% theta = angle(z) returns the phase angle in the interval [-π,π] for each 
% element of a complex array z. The angles in theta are such that 
% z = abs(z).*exp(i*theta).
y_fft_angle= angle(y_fft);   
%%
figure(2);clf
subplot(211)
plot(vkx,y_fft_abs);grid on
xlim([0.05 0.15])

subplot(212)
plot(vkx,y_fft_angle);hold on;grid on
plot([0.1 0.1],[-pi,pi],'r--');
xlim([0.05 0.15])

%%
angle_temp= interp1(vkx,y_fft_angle,f) 

true_angle= phi -pi/2

err= (angle_temp-true_angle)/(2*pi)
