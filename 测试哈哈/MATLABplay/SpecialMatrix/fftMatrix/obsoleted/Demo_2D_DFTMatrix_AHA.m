%%  Demo 2-D dftmatrix AHA
clc;clear;close all

addpath('E:\科研_2022\Codes\Customed_function_libraries\PR_func');
%%  DFT matrix
num_pixel= 32;
W1= dftmtx(num_pixel);
W2= dftmtx(num_pixel);
W= kron(W1,W2);
%% masks matrix for CDPs
numMasks = 2; % number of illumination patterns
masks= switch_masks(W1,numMasks,'amplitude');  % 'amplitude'  'phase'    'complex'
%% sampling matrix 
p= masks(:,:,1);
D= diag(p(:));
A= W*D;
%%  AHA
AHA= A*transpose(conj(A));
n= size(AHA,1);
%% 
figure(1);clf; set(gcf,'color','w');
subplot(1,2,1)
imagesc(abs(p));colorbar
subplot(1,2,2)
imagesc(abs(AHA)/n);colorbar

[sum(sum(abs(AHA/(num_pixel*num_pixel)))), sum(sum(abs((AHA/(num_pixel*num_pixel)).^2)))]

cond_matrix= cond(AHA)    %  数值越大，矩阵越病态
cond_matrix= cond(A)    %  数值越大，矩阵越病态

det_matrix= det(AHA)



