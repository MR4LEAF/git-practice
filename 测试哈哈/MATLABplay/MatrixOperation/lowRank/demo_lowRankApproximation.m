% demo  low-rank matrix approximation

% Define a 5x5 matrix A
A = [1 2 3 4 5;
     2 4 6 8 10;
     3 6 9 12 15;
     4 8 12 16 20;
     5 10 15 20 25];
 
% Perform singular value decomposition
[U, S, V] = svd(A);

% Check rank of A
rank_A = rank(A);
fprintf('Rank of A: %d\n', rank_A);

% Let's approximate A using only the first two singular values
k = 2;

U_k = U(:, 1:k);
S_k = S(1:k, 1:k);
V_k = V(:, 1:k);

% Reconstruct the low-rank approximation of A
A_k = U_k * S_k * V_k';

% Display the low-rank approximation
disp('Low-rank approximation of A:');
disp(A_k);


%  see SVD & low-rank approximation PDF file
%  In "DiffuserSpec: spectroscopy with Scotch tape", 
%  there is something called " low-rank inverse"   