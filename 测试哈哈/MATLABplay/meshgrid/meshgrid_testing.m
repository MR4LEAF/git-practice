%% meshgrid testing
x= 1:3;
y= 1:2;
[X,Y]= meshgrid(x,y);  % Replace this with your 3x3 matrix

A= X'; 
% Plot the matrix using imagesc
figure(1);clf; set(gcf, 'color', 'w');
imagesc(A);
xlabel('x')
ylabel('y')
colormap('jet');
colorbar;
axis equal;
axis tight;

% Add text annotations with the exact values and indices
[rows, cols] = size(A);
for r = 1:rows
    for c = 1:cols
        text(c, r, sprintf('(%d,%d) = %d', r, c, A(r, c)), 'HorizontalAlignment', 'center', 'Color', 'k', 'FontWeight', 'bold');
    end
end
