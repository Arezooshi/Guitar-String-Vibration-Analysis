%% FFT Spectrum of a Guitar String
% Shows the frequency spectrum of one guitar-string measurement
% and identifies the fundamental frequency.

clear;
clc;
close all;

%% Settings

filename = 'E2(1).xlsx';
theoretical_frequency = 82.41;

segment_duration = 4.0;

%% Read raw data

data = readtable(filename, ...
    'Sheet', 'Raw data', ...
    'VariableNamingRule', 'preserve');

t = data{:,1};
acceleration_x = data{:,2};

%% Calculate sampling frequency

fs = 1 / mean(diff(t));

%% Remove DC component

acceleration_centered = acceleration_x - mean(acceleration_x);

%% Detect vibration onset

window_samples = round(0.2 * fs);

rms_signal = sqrt( ...
    movmean(acceleration_centered.^2, window_samples));

threshold = 0.20 * max(rms_signal);

idx_start = find(rms_signal > threshold, 1, 'first');

if isempty(idx_start)
    warning('Vibration onset not detected.');
    idx_start = 1;
end

t_start = t(idx_start);

%% Select analysis segment

idx_segment = ...
    (t >= t_start) & ...
    (t <= t_start + segment_duration);

acceleration_segment = ...
    acceleration_centered(idx_segment);

%% Apply Hann window

N = length(acceleration_segment);

window = hann(N);

windowed_signal = ...
    acceleration_segment .* window;

%% FFT

Y = fft(windowed_signal);

%% One-sided amplitude spectrum

P2 = abs(Y / N);

P1 = P2(1:floor(N/2)+1);

if length(P1) > 2
    P1(2:end-1) = 2 * P1(2:end-1);
end

%% Frequency axis

f = fs * (0:floor(N/2)) / N;

%% Find fundamental frequency

frequency_range = ...
    [theoretical_frequency - 15, ...
     theoretical_frequency + 15];

idx_frequency = ...
    (f >= frequency_range(1)) & ...
    (f <= frequency_range(2));

[~, idx_local] = ...
    max(P1(idx_frequency));

frequency_values = f(idx_frequency);

measured_frequency = ...
    frequency_values(idx_local);

%% Plot spectrum

figure;

plot(f, P1, 'LineWidth', 1.2);

hold on;

%% Mark measured fundamental

plot(measured_frequency, ...
     P1(find(f == measured_frequency, 1)), ...
     'o', ...
     'MarkerSize', 8, ...
     'LineWidth', 1.5);

%% Mark theoretical frequency

xline(theoretical_frequency, ...
      '--', ...
      'LineWidth', 1.5);

%% Limit frequency axis

xlim([0 150]);

xlabel('Frequency (Hz)');
ylabel('Amplitude');

title('FFT Spectrum of E2 String — Measurement 1');

legend('FFT Spectrum', ...
       'Measured Fundamental', ...
       'Theoretical Frequency', ...
       'Location', 'northeast');

grid on;
box on;

hold off;

%% Display result

fprintf('\n');
fprintf('File: %s\n', filename);
fprintf('Sampling frequency: %.2f Hz\n', fs);
fprintf('Measured fundamental: %.4f Hz\n', ...
        measured_frequency);
fprintf('Theoretical frequency: %.2f Hz\n', ...
        theoretical_frequency);
