%% FFT Spectra of Five E2 Measurements
% Compares the frequency spectra of five repeated E2 measurements.
% The fundamental and second harmonic are highlighted.

clear;
clc;
close all;

%% Settings

number_of_repeats = 5;

theoretical_frequency = 82.41;

segment_duration = 4.0;

%% Create figure

figure;
hold on;

%% Analyze each measurement

for k = 1:number_of_repeats

    %% File name

    filename = sprintf('E2(%d).xlsx', k);

    %% Read raw data

    data = readtable(filename, ...
        'Sheet', 'Raw data', ...
        'VariableNamingRule', 'preserve');

    t = data{:,1};
    acceleration_x = data{:,2};

    %% Sampling frequency

    fs = 1 / mean(diff(t));

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

    %% Select 4-second segment

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

    %% Plot spectrum

    plot(f, P1, ...
        'LineWidth', 1.2);

end

%% Mark theoretical frequencies

xline(theoretical_frequency, ...
    '--', ...
    'LineWidth', 1.5);

xline(2 * theoretical_frequency, ...
    '--', ...
    'LineWidth', 1.5);

%% Plot settings

xlim([60 190]);

xlabel('Frequency (Hz)');
ylabel('Amplitude');

title('FFT Spectra of Five E2 Measurements');

legend( ...
    'E2(1)', ...
    'E2(2)', ...
    'E2(3)', ...
    'E2(4)', ...
    'E2(5)', ...
    'Theoretical Fundamental', ...
    'Theoretical 2nd Harmonic', ...
    'Location', 'northeast');

grid on;
box on;

hold off;
%% Display main spectral peaks

fprintf('\n');
fprintf('========== MAIN PEAK INFORMATION ==========\n');

for k = 1:number_of_repeats

    filename = sprintf('E2(%d).xlsx', k);

    data = readtable(filename, ...
        'Sheet', 'Raw data', ...
        'VariableNamingRule', 'preserve');

    t = data{:,1};
    acceleration_x = data{:,2};

    fs = 1 / mean(diff(t));

    acceleration_centered = ...
        acceleration_x - mean(acceleration_x);

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

    idx_segment = ...
        (t >= t_start) & ...
        (t <= t_start + segment_duration);

    acceleration_segment = ...
        acceleration_centered(idx_segment);

    N = length(acceleration_segment);

    window = hann(N);

    windowed_signal = ...
        acceleration_segment .* window;

    Y = fft(windowed_signal);

    P2 = abs(Y / N);

    P1 = P2(1:floor(N/2)+1);

    if length(P1) > 2
        P1(2:end-1) = ...
            2 * P1(2:end-1);
    end

    f = fs * ...
        (0:floor(N/2)) / N;

    %% Fundamental peak

    range1 = ...
        (f >= theoretical_frequency - 10) & ...
        (f <= theoretical_frequency + 10);

    [amp1, index1] = max(P1(range1));

    freq1_values = f(range1);

    freq1 = freq1_values(index1);

    %% Second harmonic peak

    expected_harmonic = ...
        2 * theoretical_frequency;

    range2 = ...
        (f >= expected_harmonic - 10) & ...
        (f <= expected_harmonic + 10);

    [amp2, index2] = max(P1(range2));

    freq2_values = f(range2);

    freq2 = freq2_values(index2);

    fprintf('\nE2(%d):\n', k);

    fprintf('  Fundamental: %.4f Hz, amplitude = %.6f\n', ...
        freq1, amp1);

    fprintf('  2nd harmonic: %.4f Hz, amplitude = %.6f\n', ...
        freq2, amp2);

    fprintf('  A2/A1 = %.2f %%\n', ...
        amp2 / amp1 * 100);

end
%% Save figure

if ~exist('results/figures', 'dir')
    mkdir('results/figures');
end

exportgraphics(gcf, ...
    'results/figures/e2_harmonics_repeats.png', ...
    'Resolution', 300);

fprintf('\nFigure saved to:\n');
fprintf('results/figures/e2_harmonics_repeats.png\n');
