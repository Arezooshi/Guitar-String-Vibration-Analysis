%% Harmonic Analysis of E2 String
% Examines the fundamental frequency and harmonics
% of one representative guitar-string measurement.

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

%% Sampling frequency

fs = 1 / mean(diff(t));

fprintf('Sampling frequency = %.2f Hz\n', fs);

%% Remove DC component

acceleration_centered = ...
    acceleration_x - mean(acceleration_x);

%% Detect vibration onset

window_samples = round(0.2 * fs);

rms_signal = sqrt( ...
    movmean(acceleration_centered.^2, ...
    window_samples));

threshold = 0.20 * max(rms_signal);

idx_start = find( ...
    rms_signal > threshold, 1, 'first');

if isempty(idx_start)
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
    P1(2:end-1) = ...
        2 * P1(2:end-1);
end

%% Frequency axis

f = fs * ...
    (0:floor(N/2)) / N;

%% Find fundamental

frequency_range = [
    theoretical_frequency - 10, ...
    theoretical_frequency + 10
];

idx_frequency = ...
    (f >= frequency_range(1)) & ...
    (f <= frequency_range(2));

[~, idx_local] = ...
    max(P1(idx_frequency));

frequency_values = f(idx_frequency);

fundamental_frequency = ...
    frequency_values(idx_local);

%% Find second harmonic

second_harmonic_expected = ...
    2 * fundamental_frequency;

harmonic_range = [
    second_harmonic_expected - 10, ...
    second_harmonic_expected + 10
];

idx_harmonic = ...
    (f >= harmonic_range(1)) & ...
    (f <= harmonic_range(2));

[~, idx_harmonic_local] = ...
    max(P1(idx_harmonic));

harmonic_frequency_values = ...
    f(idx_harmonic);

second_harmonic_frequency = ...
    harmonic_frequency_values(idx_harmonic_local);

%% Amplitudes

fundamental_amplitude = ...
    P1(find(f == fundamental_frequency, 1));

second_harmonic_amplitude = ...
    P1(find(f == second_harmonic_frequency, 1));

%% Harmonic amplitude ratio

harmonic_ratio = ...
    second_harmonic_amplitude / ...
    fundamental_amplitude;

harmonic_ratio_percent = ...
    harmonic_ratio * 100;

%% Display results

fprintf('\n');
fprintf('========== HARMONIC ANALYSIS ==========\n');

fprintf('Fundamental frequency = %.4f Hz\n', ...
    fundamental_frequency);

fprintf('Expected 2nd harmonic = %.4f Hz\n', ...
    second_harmonic_expected);

fprintf('Measured 2nd harmonic = %.4f Hz\n', ...
    second_harmonic_frequency);

fprintf('Fundamental amplitude = %.6f\n', ...
    fundamental_amplitude);

fprintf('2nd harmonic amplitude = %.6f\n', ...
    second_harmonic_amplitude);

fprintf('2nd harmonic / fundamental = %.2f %%\n', ...
    harmonic_ratio_percent);

%% Plot spectrum

figure;

plot(f, P1, 'LineWidth', 1.2);

hold on;

%% Mark fundamental

plot(fundamental_frequency, ...
    fundamental_amplitude, ...
    'o', ...
    'MarkerSize', 8, ...
    'LineWidth', 1.5);

%% Mark second harmonic

plot(second_harmonic_frequency, ...
    second_harmonic_amplitude, ...
    'o', ...
    'MarkerSize', 8, ...
    'LineWidth', 1.5);

%% Expected harmonic locations

xline(theoretical_frequency, ...
    '--', ...
    'LineWidth', 1.2);

xline(2 * theoretical_frequency, ...
    '--', ...
    'LineWidth', 1.2);

%% Plot range

xlim([0 235]);

xlabel('Frequency (Hz)');
ylabel('Amplitude');

title('Harmonic Analysis of E2 String');

legend( ...
    'FFT Spectrum', ...
    'Fundamental', ...
    '2nd Harmonic', ...
    'Theoretical Fundamental', ...
    'Theoretical 2nd Harmonic', ...
    'Location', 'northeast');

grid on;
box on;

hold off;

%% Save figure

if ~exist('results/figures', 'dir')
    mkdir('results/figures');
end

exportgraphics(gcf, ...
    'results/figures/e2_harmonic_analysis.png', ...
    'Resolution', 300);