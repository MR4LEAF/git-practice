Fs = 100;           % Sampling frequency
t = -0.5:1/Fs:0.5;  % Time vector 
L = length(t);      % Signal length

tc= -1;
X = 1/(4*sqrt(2*pi*0.01))*(exp(-(t-tc).^2/(2*0.01)));

n = 2^nextpow2(L);
Y = fft(X,n);

figure(1);clf
subplot(5,1,1)
plot(t,X);grid on
title('Gaussian Pulse in Time Domain')
xlabel('Time (t)')
ylabel('X(t)')

subplot(5,1,2)
ft= -(n/2-1)*(Fs/n):(Fs/n):(n/2)*(Fs/n);
plot(ft,fftshift(abs(Y)));grid on
xlabel('f_d')
ylabel('abs(Y)')

subplot(5,1,3)
angleY= fftshift(angle(Y));
plot(ft,angleY);grid on
xlabel('f_d')
ylabel('angle(Y)')

subplot(5,1,4)
unwrap_angleY= unwrap(angleY);
plot(ft,unwrap_angleY);grid on
xlabel('f_d')
ylabel('unwrap angle(Y)')


subplot(5,1,5)
index1= islocalmax(unwrap_angleY);
index2= islocalmin(unwrap_angleY);
[M,in1] = max(index1);
[M,in2] = max(index2);
plot(ft,index1);hold on
plot(ft,index2);grid on


xc= ft(in1+1:in2-1);
yc= unwrap_angleY(in1+1:in2-1);
p= polyfit(xc,yc,1);
slope= -p(1)/2/pi