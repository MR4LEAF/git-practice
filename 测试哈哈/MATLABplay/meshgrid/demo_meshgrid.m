%  demo of meshgrid

clear;clc;
%%
x= 1:100;
y= 1:10;

%%
[X1,Y1]= meshgrid(x,y);


%%
[Y2,X2]= meshgrid(y,x);


%%
norm(X2-X1.','fro')

norm(Y2-Y1.','fro')