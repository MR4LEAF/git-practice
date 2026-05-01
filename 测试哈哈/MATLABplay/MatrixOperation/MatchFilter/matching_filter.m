% Generate the reference signal
Fs = 1000; % sampling frequency
t = 0:1/Fs:1-1/Fs; % time vector
f0 = 50; % frequency of the reference signal
reference_signal = sin(2*pi*f0*t); % sine wave reference signal

% Generate the received signal with noise
received_signal = reference_signal + 0.5*randn(size(reference_signal)); % add Gaussian noise

% Design the matched filter
matched_filter = fliplr(reference_signal); % time-reverse the reference signal
matched_filter = matched_filter / norm(matched_filter); % normalize the filter

% Perform the matched filtering
matched_output = conv(received_signal, matched_filter, 'same'); % use 'same' option to output the same size as the input

% Threshold the matched output
threshold = 0.5; % set the threshold
detection = matched_output > threshold; % generate binary detection signal

% Plot the results
figure;clf
subplot(3,1,1);
plot(t, reference_signal);
title('Reference signal');
subplot(3,1,2);
plot(t, received_signal);
title('Received signal with noise');
subplot(3,1,3);
plot(t, matched_output);
hold on;
plot(t, threshold*ones(size(matched_output)), 'r--');
plot(t, detection, 'g--');
title('Matched filter output and detection');
legend('Matched output', 'Threshold', 'Detection');
