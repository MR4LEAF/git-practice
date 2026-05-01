% demo a low-rank inverse  ( also Pseduo inverse )

% Define the matrix A
A = [1 2 3; 4 5 6; 7 8 9];

% Compute the SVD of A
[U, S, V] = svd(A);

% Set the tolerance for low-rank approximation
tolerance = 1e-6;

% Calculate the rank of A
rank_A = sum(diag(S) > tolerance);

% Construct the low-rank inverse using the SVD and pseudo-inverse
A_lowrank_inv = V(:, 1:rank_A) * pinv(S(1:rank_A, 1:rank_A)) * U(:, 1:rank_A)';

% Display the original matrix A and its low-rank inverse
disp("Matrix A:");
disp(A);

disp("inv(A):");
disp(inv(A))

disp("pinv(A):");
disp(pinv(A))


disp("Low-rank Inverse of A:");
disp(A_lowrank_inv);


norm(pinv(A)-A_lowrank_inv,'fro')



%  see SVD & low-rank approximation PDF file
%  In "DiffuserSpec: spectroscopy with Scotch tape", 
%  there is something called " low-rank inverse", what 
% I think is " pseduo inverse". 