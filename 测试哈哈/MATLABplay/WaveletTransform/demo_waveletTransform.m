clear

clc


original_image= imread('moon.tif');

original_image= double(original_image);

coeffs = wavedec2(original_image, 2, 'db4'); 
coeffs= coeffs(:);
p = randperm(numel(coeffs));

coeffs_random = coeffs(p);


plot(coeffs_random)
% set(gca,'yscale','log')