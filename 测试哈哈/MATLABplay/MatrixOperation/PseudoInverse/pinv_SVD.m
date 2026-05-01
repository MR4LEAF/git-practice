%% demo the principle behind pinv

clear;clc;close all


A= [1    1    1    1    1
1    1    1    1    1
1    1  1.001 1    1
1    1    1    1    1
1    1    1    1    1
];

[u,s,v]= svd(A);  % A= u*s*v' 


Aplus= v*pinv(s)*(u');

norm(Aplus-pinv(A),'fro')