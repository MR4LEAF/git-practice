function example()

%%
dims= [128,128];
image= randn(dims);
image= image.*exp(1j*image);

%% fft2
ampl_fft= fft2(image)/sqrt(numel(image));

image_true= sqrt(numel(image))*ifft2(ampl_fft);

e1= norm(image- image_true,'fro');

%% iteration
Afun= @(x) getfft(x,dims);

sol=cgs(@(x) Afun(x),ampl_fft(:),1e-3,30,[],[], image(:) + 0.01*randn(numel(image),1));
x0= sol;
%% 
e2= norm(x0-image(:),2);

%
figure(1);clf
plot(e1,'b*');hold on;grid on
plot(e2,'rs')

x= ctranspose(image(:))*Afun(image(:))




function y= getfft(x,dims)
x_matrix= reshape(x,dims);
y_matrix= fft2(x_matrix)/sqrt(dims(1)*dims(2));
y= y_matrix(:);
end

end
