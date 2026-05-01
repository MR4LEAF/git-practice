% demo Kronecker tensor product 

clear;clc

F= dftmtx(2);
A= [F,zeros(size(F));zeros(size(F)),F];

I= eye(2,2);

B= kron(I,F);

errNorm= norm(A-B,'fro')


cond(A)

A