% 
t= -10:0.1:10;
s= cos(2*pi*t+pi/12) + cos(2*pi*3*t+pi/12);
s=s';
% fs= fftshift(fft(ifftshift(s)));
fs= fft(s);

Fn= zeros(numel(s));
[m,n]= size(Fn);
for i=1:m
    for j=1:n
        Fn(i,j)= exp(-sqrt(-1)*2*pi*(i-1)*(j-1)/sqrt(m*n));
    end
end

%%
Fs_matrix= Fn*s;

norm(Fs_matrix-fs,2)


figure(1);clf
subplot(3,1,1)
plot(t,s);hold on
subplot(3,1,2)
plot(t,ifftshift(s),'r--');grid on
subplot(3,1,3)
s_ifftshift= [s(101:end);s(1:100)];
plot(t,s_ifftshift,'m:');grid on
norm(s_ifftshift-ifftshift(s),2)

norm(Fn-transpose(Fn),'fro')


