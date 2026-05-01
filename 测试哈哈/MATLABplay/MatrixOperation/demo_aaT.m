clear;clc

n= 100;
a= rand(n,1);

A= a*a';

rank(A)

det(A)

cond(A)

issymmetric(A)