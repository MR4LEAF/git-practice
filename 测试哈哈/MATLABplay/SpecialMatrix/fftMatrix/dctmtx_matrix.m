clear;clc
close all

%%
N = 8; % Example size
T0 = dctmtx(N);

T0'*T0- eye(size(T0))          %  If  T'*T is a eye(size(T)) matrix, T should be an orthogonal matrix 


%%

N = 8; % Example size
T = zeros(N);

for k = 0:N-1
    for n = 0:N-1
        if k == 0
            T(k+1,n+1) = sqrt(1/N);
        else
            T(k+1,n+1) = sqrt(2/N) * cos((pi*(2*n+1)*k)/(2*N));
        end
    end
end

T- T0

%% For example, if you have an 8x8 block of image data called 'block', you can perform the DCT as follows:
image = double(imread('cameraman.tif'));
i= randperm(size(image,1)-10)+5; i= i(1);
j= randperm(size(image,2)-10)+5; j= j(1);
block= image(i-N/2:i+N/2-1,j-N/2:j+N/2-1);

dct_block = T * block * T'
 
figure(2);clf
plot(sort(dct_block(:)),'b*');grid on
%% To perform the inverse DCT (IDCT), you can use the transpose of the DCT matrix:

idct_block = T' * dct_block * T;

err= norm(idct_block-block,'fro')
