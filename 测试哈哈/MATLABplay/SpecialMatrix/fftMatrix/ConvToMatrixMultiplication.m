clear;clc

numrows= 27;
numcolums= 32; 

% 2-D DFT matrix
W1= dftmtx(numrows);
W2= dftmtx(numcolums);
A= kron(W2,W1);     %  transpose(W)=W 

% 2-D inverse DFT matrix
W1_H= conj(dftmtx(numrows)/numrows);
W2_H= conj(dftmtx(numcolums)/numcolums);
AH= kron(W2_H,W1_H);     %  transpose(W)= W 


% conv(H,X)
X= rand(numrows,numcolums);
H= fspecial('gaussian', [numrows,numcolums], 1.5);
conv_HX= ifftn(fftn(H).*fftn(X));

% AH*A*X(:)= X(:)
norm(X(:)-AH*A*X(:),'fro') 


MeasurementMatrix= AH*diag(A*H(:))*A;
MatrixMultiplication_HX= MeasurementMatrix*X(:);


% disp(['coherence of matrix MeasurementMatrix =',num2str(calc_MatrixCoherence(MeasurementMatrix))])
% checkRIP(X(:),MeasurementMatrix*X(:))

% conv(H,X)= AH*diag(A*H(:))*A*X(:)
norm(conv_HX(:)-MatrixMultiplication_HX,2)

% Orthogonality of MatrixMultiplication
res= MeasurementMatrix*MeasurementMatrix';

imagesc(abs(res(:)))
