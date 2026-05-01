clear;clc

AddPath();

% Define the first row
n= 21;
firstRow= rand(1,n);
firstCol= rand(n,1);


A= toeplitz(firstCol, firstRow);

isCirculant(A);

isToeplitz(A);

isToeplitzCirculant(A);

isBTTB(A,n);

isBCCB(A,n);