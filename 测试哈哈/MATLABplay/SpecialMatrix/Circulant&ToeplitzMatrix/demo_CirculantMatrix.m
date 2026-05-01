clear;clc

AddPath();

% Define the first row
n= 50;
firstRow = rand(1,n);

A= createCirculantMatrix(firstRow);


isCirculant(A);

isToeplitz(A);

isToeplitzCirculant(A);

isBTTB(A,n);

isBCCB(A,n);