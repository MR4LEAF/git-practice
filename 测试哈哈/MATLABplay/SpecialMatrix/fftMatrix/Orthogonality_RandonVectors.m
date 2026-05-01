%% High-dimensional random vectors are almost always nearly orthogonal to each other
clc;clear;close all;
%%
numrows= 128;
numcolums= 256;
%%
% A= randn(numrows,numcolums);
% A=  sqrt(1/2)*randn(numrows,numcolums)+ 1j*sqrt(1/2)*randn(numrows,numcolums);
A=  randi(2,numrows,numcolums)-1;
%%
res=[];
%%
for i=1:size(A,2)
   a1= A(:,i);
   for j=i+1:size(A,2)
       a2= A(:,j);
       inner_product= transpose(a1)*a2/(norm(a1)*norm(a2));
       abs_inner_product= abs(inner_product);
       res=[res,abs_inner_product];
   end
end
%%
figure(1);clf
plot(res,'*')
mean_res= mean(res)
std_res= std(res)