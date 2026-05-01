figure;

% First subplot with custom position
subplot('Position', [0.1, 0.1, 0.3, 0.3]);
plot(rand(10, 1), rand(10, 1), 'o');
xlabel('x');
ylabel('y');
axis equal;

% Second subplot with custom position
subplot('Position', [0.5, 0.1, 0.4, 0.3]);
plot(rand(10, 1), rand(10, 1), 'o');
xlabel('x');
ylabel('y');
axis equal;

% Third subplot with custom position
subplot('Position', [0.1, 0.5, 0.3, 0.4]);
plot(rand(10, 1), rand(10, 1), 'o');
xlabel('x');
ylabel('y');
axis equal;
