clear;clc

%
Nx= 201;
Ny= 201;
N= 11;
a11= rand(Nx,Ny,N)+0.2;

m11 = spdiags(a11(:),0,Nx*Ny*N,Nx*Ny*N);

a12= rand(Nx,Ny,N)+0.2;
m12 = spdiags(a12(:),0,Nx*Ny*N,Nx*Ny*N);

a21= rand(Nx,Ny,N)+0.2;
m21 = spdiags(a21(:),0,Nx*Ny*N,Nx*Ny*N);

a22= rand(Nx,Ny,N)+0.2;
m22 = spdiags(a22(:),0,Nx*Ny*N,Nx*Ny*N);

M= [m11,m12;m21,m22];




TolN= (Nx*Ny*N)*N^2

sqrt(TolN)

fprintf('%e\n', det(m11'*m11));

%   block matrix 
% a11= rand(2,2)
% a12= rand(2,2)
% a21= rand(2,2)
% a22= rand(2,2)
% [a11,a12;a21,a22]
