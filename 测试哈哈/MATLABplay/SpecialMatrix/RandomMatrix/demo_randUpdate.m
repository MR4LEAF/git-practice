clc
clear

numrows= 10000;
numcolums= 10000; 

% uniformly distributed random numbers between 0 and 1.

% normally distributed random numbers (with mean 0 and variance 1).
A1= randn(numrows,numcolums);
A2= randn(numrows,numcolums);
disp(['coherence of matrix A =',num2str(calc_MatrixCoherence(A1,A2))])


