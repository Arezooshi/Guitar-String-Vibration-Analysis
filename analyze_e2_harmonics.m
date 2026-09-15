%% Harmonic Analysis of E2 - Five Repeated Measurements
% Analyzes the fundamental frequency and second harmonic
% for five repeated E2 guitar-string measurements.

clear;
clc;
close all;

%% Settings

number_of_repeats = 5;

theoretical_frequency = 82.41;

segment_duration = 4.0;

%% Preallocate results

fundamental_frequency = zeros(number_of_repeats,1);
second_harmonic_frequency = zeros(number_of_repeats,1);

fundamental_amplitude = zeros(number_of_repeats,1);
second_harmonic_amplitude = zeros(number_of_repeats,1);

harmonic_ratio_percent = zeros(number_of_repeats,1);

%% Analyze each measurement

for k = 1:number_of_repeats

    %% File name

    filename = sprintf('E2(%d).xlsx', k);

    fprintf('\nAnalyzing %s ...\n', filename);

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

    %% Find fundamental

    fundamental_range = [
        theoretical_frequency - 10, ...
        theoretical_frequency + 10
    ];

    idx_fundamental = ...
        (f >= fundamental_range(1)) & ...
        (f <= fundamental_range(2));

    [~, idx_local] = ...
        max(P1(idx_fundamental));

    frequency_values = ...
        f(idx_fundamental);

    fundamental_frequency(k) = ...
        frequency_values(idx_local);

    %% Fundamental amplitude

    idx_fundamental_peak = ...
        find(f == fundamental_frequency(k), 1);

    fundamental_amplitude(k) = ...
        P1(idx_fundamental_peak);

    %% Find second harmonic

    expected_second_harmonic = ...
        2 * theoretical_frequency;

    second_harmonic_range = [
        expected_second_harmonic - 10, ...
        expected_second_harmonic + 10
    ];

    idx_second_harmonic = ...
        (f >= second_harmonic_range(1)) & ...
        (f <= second_harmonic_range(2));

    [~, idx_local] = ...
        max(P1(idx_second_harmonic));

    harmonic_frequency_values = ...
        f(idx_second_harmonic);

    second_harmonic_frequency(k) = ...
        harmonic_frequency_values(idx_local);

    %% Second harmonic amplitude

    idx_second_peak = ...
        find(f == second_harmonic_frequency(k), 1);

    second_harmonic_amplitude(k) = ...
        P1(idx_second_peak);

    %% Harmonic amplitude ratio

    harmonic_ratio_percent(k) = ...
        second_harmonic_amplitude(k) / ...
        fundamental_amplitude(k) * 100;

    %% Display result

    fprintf('  Fundamental = %.4f Hz\n', ...
        fundamental_frequency(k));

    fprintf('  2nd harmonic = %.4f Hz\n', ...
        second_harmonic_frequency(k));

    fprintf('  A2/A1 = %.2f %%\n', ...
        harmonic_ratio_percent(k));

end

%% Create results table

Repeat = (1:number_of_repeats)';

results = table( ...
    Repeat, ...
    fundamental_frequency, ...
    second_harmonic_frequency, ...
    fundamental_amplitude, ...
    second_harmonic_amplitude, ...
    harmonic_ratio_percent, ...
    'VariableNames', { ...
    'Repeat', ...
    'FundamentalFrequency_Hz', ...
    'SecondHarmonicFrequency_Hz', ...
    'FundamentalAmplitude', ...
    'SecondHarmonicAmplitude', ...
    'SecondHarmonicRatio_percent'});

%% Display results

fprintf('\n');
fprintf('========== E2 HARMONIC SUMMARY ==========\n');

disp(results);

%% Calculate statistics

mean_fundamental = ...
    mean(fundamental_frequency);

std_fundamental = ...
    std(fundamental_frequency);

mean_second_harmonic = ...
    mean(second_harmonic_frequency);

std_second_harmonic = ...
    std(second_harmonic_frequency);

mean_harmonic_ratio = ...
    mean(harmonic_ratio_percent);

std_harmonic_ratio = ...
    std(harmonic_ratio_percent);

%% Display statistics

fprintf('\n');
fprintf('Mean fundamental frequency = %.4f Hz\n', ...
    mean_fundamental);

fprintf('SD fundamental frequency = %.4f Hz\n', ...
    std_fundamental);

fprintf('Mean 2nd harmonic frequency = %.4f Hz\n', ...
    mean_second_harmonic);

fprintf('SD 2nd harmonic frequency = %.4f Hz\n', ...
    std_second_harmonic);

fprintf('Mean A2/A1 ratio = %.2f %%\n', ...
    mean_harmonic_ratio);

fprintf('SD A2/A1 ratio = %.2f %%\n', ...
    std_harmonic_ratio);

%% Save results table

if ~exist('results/tables', 'dir')
    mkdir('results/tables');
end

writetable(results, ...
    'results/tables/E2_harmonic_results.csv');

fprintf('\nResults saved to:\n');
fprintf('results/tables/E2_harmonic_results.csv\n');