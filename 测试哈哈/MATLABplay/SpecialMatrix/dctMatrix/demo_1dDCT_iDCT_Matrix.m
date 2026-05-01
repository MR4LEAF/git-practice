% demo dct 1D matrix

clc;clear;

N= 128;

x = (1:N).'; 
% 1-D DCT
dct_x = dct(x);

W= dctmtx(N);

dct_x1 = W * x;

err = dct_x1 - dct_x;

norm(err,2)


disp(['coherence of matrix W =',num2str(calc_MatrixCoherence(W))])
%% 1-D iDCT

idct_x = idct(x);


idct_x1 = W' * x;

err = idct_x1 - idct_x;

norm(err,2)



% orthogonality

WHW= W'*W;

imagesc(WHW)

sum(WHW(:))

sum(WHW(:).^2)


disp(['coherence of matrix WHW =',num2str(calc_MatrixCoherence(WHW))])