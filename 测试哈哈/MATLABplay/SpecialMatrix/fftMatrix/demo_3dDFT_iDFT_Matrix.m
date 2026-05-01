% 2-D inverse DFT matrix
clear;clc

numrows= 11;
numcolums= 12; 
numheights= 13;

X= rand(numrows,numcolums,numheights);

%%  3-D DFT matrix
W1= dftmtx(numrows);
W2= dftmtx(numcolums);
W3= dftmtx(numheights);

A= kron(W3,kron(W2,W1));     %  transpose(W)=W 

X_fft= fftn(X);
norm_value = norm(X_fft(:)-A*X(:),2);
disp(['Norm value between X_fft(:) and A*X(:): ', num2str(norm_value)])

%  Orthogonality of A
A0= A/sqrt(numrows*numcolums*numheights);

A0HA0= A0'*A0;
imagesc(abs(A0HA0));colorbar

sum_value1 = sum(abs(A0HA0(:))); 
disp(['Sum of absolute values of elements in A0HA0: ', num2str(sum_value1)])

sum_value2 = sum(abs(A0HA0(:)).^2); 
disp(['Sum of squares of absolute values of elements in A0HA0: ', num2str(sum_value2)])


%% 2-D inverse DFT matrix
W1_H= conj(dftmtx(numrows)/numrows);
W2_H= conj(dftmtx(numcolums)/numcolums);
W3_H= conj(dftmtx(numheights)/numheights);

AH= kron(W3_H,kron(W2_H,W1_H));     %  transpose(W)= W 

X_ifft= ifftn(X);
norm_value2 = norm(X_ifft(:)-AH*X(:),2);
disp(['Norm value between X_ifft(:) and AH*X(:): ', num2str(norm_value2)])

% AH =A'/(numrows*numcolums)
fro_norm = norm(AH-A'/(numrows*numcolums*numheights),'fro');  
disp(['Frobenius norm between AH and A conjugate transpose: ', num2str(fro_norm)])

%  Orthogonality of AH
A1= AH*sqrt(numrows*numcolums*numheights);

A1HA1= A1'*A1;
imagesc(abs(A1HA1));colorbar

sum_value3 = sum(abs(A1HA1(:))); 
disp(['Sum of absolute values of elements in A1HA1: ', num2str(sum_value3)])

sum_value4 = sum(abs(A1HA1(:)).^2); 
disp(['Sum of squares of absolute values of elements in A1HA1: ', num2str(sum_value4)])

%%
B=[A, zeros(size(A)), zeros(size(A)); zeros(size(A)),A, zeros(size(A)); zeros(size(A)), zeros(size(A)),A];

err= [X_fft(:);X_fft(:);X_fft(:)] -B*[X(:);X(:);X(:)] ;

norm(err,2)

BHB= (B'/(numrows*numcolums*numheights))*B;


imagesc(abs(BHB))

sum(abs(BHB(:)))