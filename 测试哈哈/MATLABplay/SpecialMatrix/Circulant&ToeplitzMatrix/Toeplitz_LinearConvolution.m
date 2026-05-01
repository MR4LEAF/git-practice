% Toeplitz matrix vs discrete linear convolution 

clear
clc

% Define the vector t as specified
t = [1; 1; 1; zeros(7, 1)];
% t = [zeros(4,1);1; 1; 1; zeros(3, 1)];

% Define the vector x with values from 1 to 10
% x = (1:10)';
x= rand(10,1);

% Method 1: Create the Toeplitz matrix with t as the first column
% and zeros on the other side since the upper triangular part is zeros
tnew= [t;zeros(numel(x)-1,1)];

T = toeplitz(tnew, zeros(size(tnew)));

% Ensure T is lower triangular, in case it's not done automatically
T = tril(T);

% Multiply the lower triangular Toeplitz matrix by the vector x
xnew= [x;zeros(numel(t)-1,1)];
y_matrix_method = T * xnew;

% Method 2: Compute the convolution of t and x
y_conv_function = conv(t, x);


[y_matrix_method,y_conv_function]