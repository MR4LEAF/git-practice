% define a matrix A
A = [1 1 1; 1 0 1; 1 1 0];

% perform Gram-Schmidt orthogonalization using qr
[Q,R] = qr(A);

% Q is the orthonormal basis of the subspace spanned by A
disp(Q);

% compute the 2-norm of each column
norms = vecnorm(Q) 

% 2-norm of each row
norms = vecnorm(Q') 