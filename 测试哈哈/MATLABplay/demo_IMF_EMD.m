% demo Intrinsic Mode Function (IMF) Decomposition 
% Empirical Mode Decomposition (EMD)


% Assume 'signal' is the signal you want to decompose
signal = [1, 2, 3, 4, 3, 2, 1, 2, 3, 4, 3, 2, 1];  % Example signal
x= -10:0.1:10;
signal= sin(2*pi*x/5) + 0.2*sin(2*pi*x/3) + 0.1*rand(size(x));

% Initialize the residue to the original signal
residue = signal;

% Initialize an empty cell array to hold the IMFs
imfs = {};

% Repeat until the residue becomes a monotonic function
while true
    % Identify the local maxima and minima
    maxima = find(residue > [residue(2:end), NaN] & residue > [NaN, residue(1:end-1)]);
    minima = find(residue < [residue(2:end), NaN] & residue < [NaN, residue(1:end-1)]);
    
    % Break if the residue is monotonic (less than 2 extrema)
    if length(maxima) + length(minima) < 2
        break;
    end
    
    % Initialize the current IMF to the residue
    imf = residue;
    
    % Interpolate the maxima and minima to create the upper and lower envelopes
    upper_envelope = spline([1, maxima, length(imf)], [0, residue(maxima), 0], 1:length(imf));
    lower_envelope = spline([1, minima, length(imf)], [0, residue(minima), 0], 1:length(imf));
    
    % Calculate the mean of the upper and lower envelopes
    mean_envelope = (upper_envelope + lower_envelope) / 2;
    
    % Subtract the mean envelope from the current IMF
    imf = imf - mean_envelope;
    
    % Add the current IMF to the list of IMFs
    imfs{end+1} = imf;
    
    % Subtract the current IMF from the residue
    residue = residue - imf;
end

% Add the final residue to the list of IMFs
imfs{end+1} = residue;

% Sum up all the IMFs and the residual to reconstruct the original signal
reconstructed_signal = sum(cell2mat(imfs), 1);

% Display the original signal, the reconstructed signal, and the IMFs
subplot(length(imfs)+2, 1, 1);
plot(signal);
title('Original Signal');

subplot(length(imfs)+2, 1, 2);
plot(reconstructed_signal);
title('Reconstructed Signal');

for i = 1:length(imfs)
    subplot(length(imfs)+2, 1, i+2);
    plot(imfs{i});
    title(['IMF ', num2str(i)]);
end
