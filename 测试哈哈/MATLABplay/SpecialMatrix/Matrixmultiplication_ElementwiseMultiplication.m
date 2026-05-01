% matrix multiplication & element-wise multiplication

% Define two 2x2 matrices A and B
A = [1 2; 3 4];
B = [5 6; 7 8];

% element-wise multiplication
C= A.*B;

C(:)

% matrix multiplication
Bv= B(:);
Amatrix= diag(A(:));

Amatrix*Bv


