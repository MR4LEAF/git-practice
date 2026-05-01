clc
clear

numrows= 100;
numcolums= 100; 

% uniformly distributed random numbers between 0 and 1.
A1= rand(numrows,numcolums);
A2= rand(numrows,numcolums);

disp(['coherence of matrix A =',num2str(calc_MatrixCoherence(A1,A2))])


% normally distributed random numbers (with mean 0 and variance 1).
A1= randn(numrows,numcolums);
A2= randn(numrows,numcolums);
disp(['coherence of matrix A =',num2str(calc_MatrixCoherence(A1,A2))])


% uniformly distributed random integers in a specified range
A1= randi(1e3,numrows,numcolums);
A2= randi(1e3,numrows,numcolums);
disp(['coherence of matrix A =',num2str(calc_MatrixCoherence(A1,A2))])


% a random permutation of integers
P1 = randperm(numrows*numcolums);
P2 = randperm(numrows*numcolums);
A1 = reshape(P1, [numrows,numcolums]);
A2 = reshape(P2, [numrows,numcolums]);
disp(['coherence of matrix A =',num2str(calc_MatrixCoherence(A1,A2))])


