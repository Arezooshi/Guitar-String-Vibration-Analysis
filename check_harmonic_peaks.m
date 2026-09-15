%% Check the Reliability of the Second Harmonic
% Compares the second-harmonic peak with the
% surrounding spectral background for five E2 measurements.

clear;
clc;
close all;

%% Settings

number_of_repeats = 5;

theoretical_frequency = 82.41;

segment_duration = 4.0;

%% Preallocate results

harmonic_frequency = zeros(number_of_repeats,1);
harmonic_amplitude = zeros(number_of_repeats,1);
background_amplitude = zeros(number_of_repeats,1);
peak_to_background = zeros(number_of_repeats,1);

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

    %% Hann window

    N = length(acceleration_segment);

    window = hann(N);

    windowed_signal = ...
        acceleration_segment .* window;

    %% FFT

    Y = fft(windowed_signal);

    P2 = abs(Y / N);

    P1 = P2(1:floor(N/2)+1);

    if length(P1) > 2
        P1(2:end-1) = ...
            2 * P1(2:end-1);
    end

    %% Frequency axis

    f = fs * ...
        (0:floor(N/2)) / N;

    %% Expected second harmonic

    expected_harmonic = ...
        2 * theoretical_frequency;

    %% Search for harmonic peak

    search_range = [
        expected_harmonic - 10, ...
        expected_harmonic + 10
    ];

    idx_search = ...
        (f >= search_range(1)) & ...
        (f <= search_range(2));

    spectrum_search = P1(idx_search);

    frequency_search = f(idx_search);

    [peak_value, peak_index] = ...
        max(spectrum_search);

    harmonic_frequency(k) = ...
        frequency_search(peak_index);

    harmonic_amplitude(k) = ...
        peak_value;

    %% Estimate surrounding background

    background_range = ...
        (f >= expected_harmonic - 10) & ...
        (f <= expected_harmonic + 10);

    background_values = P1(background_range);

    %% Remove points close to the peak

    peak_exclusion = ...
        abs(f(background_range) - ...
        harmonic_frequency(k)) > 3;

    background_values = ...
        background_values(peak_exclusion);

    %% Median background level

    background_amplitude(k) = ...
        median(background_values);

    %% Peak-to-background ratio

    peak_to_background(k) = ...
        harmonic_amplitude(k) / ...
        background_amplitude(k);

    %% Display

    fprintf('\nE2(%d):\n', k);

    fprintf('  Harmonic frequency = %.4f Hz\n', ...
        harmonic_frequency(k));

    fprintf('  Peak amplitude = %.6f\n', ...
        harmonic_amplitude(k));

    fprintf('  Background amplitude = %.6f\n', ...
        background_amplitude(k));

    fprintf('  Peak / Background = %.2f\n', ...
        peak_to_background(k));

end

%% Create results table

Repeat = (1:number_of_repeats)';

results = table( ...
    Repeat, ...
    harmonic_frequency, ...
    harmonic_amplitude, ...
    background_amplitude, ...
    peak_to_background, ...
    'VariableNames', { ...
    'Repeat', ...
    'SecondHarmonicFrequency_Hz', ...
    'PeakAmplitude', ...
    'BackgroundAmplitude', ...
    'PeakToBackgroundRatio'});

%% Display final results

fprintf('\n');
fprintf('========== HARMONIC PEAK RELIABILITY ==========\n');

disp(results);

%% Save table

if ~exist('results/tables', 'dir')
    mkdir('results/tables');
end

writetable(results, ...
    'results/tables/E2_harmonic_peak_reliability.csv');

fprintf('\nResults saved to:\n');
fprintf('results/tables/E2_harmonic_peak_reliability.csv\n');