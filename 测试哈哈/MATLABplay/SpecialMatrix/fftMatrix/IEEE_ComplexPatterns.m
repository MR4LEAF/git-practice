%% complex patterns
num_pixel= 192;
num_pattern = 2; % number of illumination patterns
b1 = [-1;1;-1i;1i];
b2 = [repmat(sqrt(0.5),4,1); sqrt(3)];
patterns = b1(randi(4,[num_pixel,num_pixel,num_pattern])) .* b2(randi(5,[num_pixel,num_pixel,num_pattern])); 
%%
figure(1)
subplot(1,2,1)
imagesc(abs(patterns(:,:,1)));colorbar
subplot(1,2,2)
imagesc(abs(patterns(:,:,2)));colorbar
probe= patterns(:,:,2);
Ed= mean(probe(:))
Ed2= mean( (probe(:)).^2)         
Ed4_Ed2= mean((abs(probe(:))).^4)-2*(mean((abs(probe(:))).^2))^2   
