% demo 2-D plane

clear; clc 
%% inilization 
M= 201;
N= 201;
L= 145;

x= -(M-1)/2:1:(M-1)/2;
y= -(N-1)/2:1:(N-1)/2;
z= -(L-1)/2:1:(L-1)/2;

[Kx,Ky,Kz]= meshgrid(x,y,z);
%% 
load('TFs.mat');

TF= m3TF_b1;


%%
figure(1);clf
imagesc(squeeze(TF(:,(N+1)/2,:)));grid on
%%
% figure(1);clf
% TFolshow(TF);
%% Define the plane
% point = [(M+1)/2 (N+1)/2 L];
% 
% theta= 45;
% 
% normal = [cosd(theta) sind(theta) 0];
% 
% %% Extract the slice
% [slice,x,y,z] = obliqueslice(TF, point, normal,'OutputSize','limit');  % ,'Method','nearest'
% 
% % Display the slice
% figure(2);clf
% imagesc(slice);
% xlabel('x');ylabel('y')

%%  Using interpolation
point = [(M+1)/2 (N+1)/2 L];
theta= 180;
% normal = [cosd(theta) sind(theta) 0];
[X,Z]= meshgrid(x,z);
Y= tand(theta)*X;
TF_slice= interp3(Kx,Ky,Kz,TF,X,Y,Z);

figure(3);clf
imagesc(TF_slice);hold on;grid on
plot((M+1)/2,(L+1)/2,'r*')
