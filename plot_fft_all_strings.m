%% FFT Spectra of Four Guitar Strings
% Shows representative FFT spectra for E2, A2, D3, and G3.

clear;
clc;
close all;

%% Settings

strings = ["E2", "A2", "D3", "G3"];

theoretical_frequency = [
    82.41
    110.00
    146.83
    196.00
];

filenames = [
    "E2(1).xlsx"
    "A2(1).xlsx"
    "D3(1).xlsx"
    "G3(1).xlsx"
];

segment_duration = 4.0;

%% Create figure

figure;

hold on;

%% Analyze each string

for k = 1:4

    %% Read data

    data = readtable(filenames(k), ...
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

    %% Find fundamental

    frequency_range = [
        theoretical_frequency(k) - 15, ...
        theoretical_frequency(k) + 15
    ];

    idx_frequency = ...
        (f >= frequency_range(1)) & ...
        (f <= frequency_range(2));

    [~, idx_local] = ...
        max(P1(idx_frequency));

    frequency_values = f(idx_frequency);

    measured_frequency = ...
        frequency_values(idx_local);

    %% Plot spectrum

    plot(f, P1, ...
        'LineWidth', 1.2);

    %% Mark theoretical frequency

    xline(theoretical_frequency(k), ...
        '--', ...
        'LineWidth', 1.0);

    %% Display result

    fprintf('%s: measured = %.4f Hz\n', ...
        strings(k), measured_frequency);

end

%% Plot settings

xlim([0 220]);

xlabel('Frequency (Hz)');
ylabel('Amplitude');

title('FFT Spectra of Guitar String Vibrations');

legend( ...
    'E2', 'E2 theoretical', ...
    'A2', 'A2 theoretical', ...
    'D3', 'D3 theoretical', ...
    'G3', 'G3 theoretical', ...
    'Location', 'northeast');

grid on;
box on;

hold off;

%% Save figure

if ~exist('results/figures', 'dir')
    mkdir('results/figures');
end

exportgraphics(gcf, ...
    'results/figures/fft_all_strings.png', ...
    'Resolution', 300);