%%  Demo    A*transpose(A)
clc;clear;close all;
%%
A= rand(24,45);
B= transpose(A);
AB= A*B;
%%
Sum=0;
for i=1:size(A,2)
   a=A(:,i);
   aT= transpose(a);
   Sum=Sum+ a*aT;
end
%%
err= AB-Sum;
%%
figure(1)
imagesc(err);colorbar

max(err(:))-min(err(:))