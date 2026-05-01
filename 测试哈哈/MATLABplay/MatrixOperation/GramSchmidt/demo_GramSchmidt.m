% Assume we have 3 base signals
base1 = [1, 2, 3, 4, 5,6,7];
base2 = [2, 3, 4, 5, 6,7,8];
base3 = [3, 4, 5, 6, 7,8,9];

% And our signal y
y = [4, 7, 10, 13, 16,18,21];

% Combine the base signals into a matrix
A = [base1; base2; base3]';

% Perform Gram-Schmidt orthogonalization
[Q,R] = qr(A,0);

% Now Q contains the orthogonal base signals
% Solve for the coefficients for orthogonal base signals
coefficients_ortho = Q \ y';

%% Get the coefficients for the original base signals
coefficients = R \ coefficients_ortho;

y_est= coefficients(1)*base1 + coefficients(2)*base2 + coefficients(3)*base3

norm(y_est-y,"fro")
%% Solve for the coefficients
coefficients = A \ y';

y_est= coefficients(1)*base1 + coefficients(2)*base2 + coefficients(3)*base3
norm(y_est-y,"fro")
