%% imagesc testing

A = [1, 2, 3; 4, 5, 6; 7, 8, 9]; % Replace this with your 3x3 matrix

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
