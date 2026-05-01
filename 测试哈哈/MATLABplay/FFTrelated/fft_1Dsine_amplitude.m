%% demo fft of sine 
dx= 0.01;
L= 30;
x=-L:dx:L;
phi= pi/3;
y= sin(2*pi*x/10 + phi);

%%
figure(1);clf
plot(x,y)

y_fft= fftshift(fft(ifftshift(y)));
plot(abs(y_fft))
n= numel(x);
kx= -((n-1)/2):1:(n-1)/2;
kx= kx*(1/dx/n);

%%
figure(2);clf
plotyy(kx,abs(y_fft),kx,angle(y_fft));grid on
grid on
xlim([-0.5 0.5])

%%
figure(3);clf
subplot(211)
plot(kx,abs(y_fft),'b-');grid on
xlim([0.05 0.15])
subplot(212)
plot(kx,angle(y_fft),'r--');grid on
xlim([0.05 0.15])

