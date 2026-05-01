% demo Kronecker tensor product 

clear;clc

F= dftmtx(100);
A= [F,F;F,F];

I= ones(2,2);

B= kron(I,F);

errNorm= norm(A-B,'fro')


cond(A)

