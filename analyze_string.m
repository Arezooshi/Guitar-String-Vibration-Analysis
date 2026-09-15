function results = analyze_string(string_name, theoretical_frequency)

% ANALYZE_STRING
% Analyzes repeated guitar-string vibration measurements using FFT.
%
% INPUTS:
%   string_name            - String name, e.g. 'A2'
%   theoretical_frequency  - Theoretical fundamental frequency in Hz
%
% OUTPUT:
%   results                - Table containing the analysis results
%
% The data files must follow this naming format:
%   A2(1).xlsx
%   A2(2).xlsx
%   ...
%
% The measurements must be stored in the "Raw data" sheet.
%
% The first column must contain time.
% The second column must contain X-axis acceleration.

%% Settings

number_of_repeats = 5;

segment_duration = 4.0;     % seconds

frequency_range = [ ...
    theoretical_frequency - 15, ...
    theoretical_frequency + 15];


%% Preallocate result arrays

measured_frequency = zeros(number_of_repeats,1);

absolute_error = zeros(number_of_repeats,1);

relative_error = zeros(number_of_repeats,1);

sampling_frequency = zeros(number_of_repeats,1);

start_time = zeros(number_of_repeats,1);


%% Analyze each measurement

for k = 1:number_of_repeats

    % File name
    filename = sprintf('%s(%d).xlsx', string_name, k);

    fprintf('\nAnalyzing %s ...\n', filename);


    %% Read data

    data = readtable(filename, ...
    'Sheet', 'Raw data', ...
    'VariableNamingRule', 'preserve');

    % Time
    t = data{:,1};

    % X-axis acceleration
    acceleration_x = data{:,2};


    %% Sampling frequency

    fs = 1 / mean(diff(t));

    sampling_frequency(k) = fs;


    %% Remove DC component

    acceleration_centered = ...
        acceleration_x - mean(acceleration_x);


    %% Detect vibration onset

    % Moving RMS window
    window_samples = round(0.2 * fs);

    rms_signal = sqrt( ...
        movmean(acceleration_centered.^2, window_samples) );


    % Use 20% of the maximum RMS as the threshold
    threshold = 0.20 * max(rms_signal);


    % Find first point above threshold
    idx_start = find( ...
        rms_signal > threshold, ...
        1, ...
        'first');


    % Safety check
    if isempty(idx_start)

        warning('Vibration onset not detected in %s.', filename);

        idx_start = 1;

    end


    t_start = t(idx_start);

    start_time(k) = t_start;


    %% Select analysis segment

    idx_segment = ...
        (t >= t_start) & ...
        (t <= t_start + segment_duration);


    acceleration_segment = ...
        acceleration_centered(idx_segment);


    %% Check segment length

    if length(acceleration_segment) < 100

        error( ...
            'Not enough data available in %s.', ...
            filename);

    end


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


    %% Find fundamental frequency

    idx_frequency = ...
        (f >= frequency_range(1)) & ...
        (f <= frequency_range(2));


    if ~any(idx_frequency)

        error( ...
            'Frequency range not available in %s.', ...
            filename);

    end


    [~, idx_local] = ...
        max(P1(idx_frequency));


    frequency_values = f(idx_frequency);

    measured_frequency(k) = ...
        frequency_values(idx_local);


    %% Calculate errors

    absolute_error(k) = ...
        abs( ...
        measured_frequency(k) - ...
        theoretical_frequency);


    relative_error(k) = ...
        absolute_error(k) / ...
        theoretical_frequency * 100;


    %% Display result

    fprintf( ...
        '  Start time = %.3f s\n', ...
        t_start);

    fprintf( ...
        '  Sampling frequency = %.2f Hz\n', ...
        fs);

    fprintf( ...
        '  Measured frequency = %.4f Hz\n', ...
        measured_frequency(k));

    fprintf( ...
        '  Relative error = %.4f %%\n', ...
        relative_error(k));

end


%% Create results table

results = table( ...
    (1:number_of_repeats)', ...
    start_time, ...
    sampling_frequency, ...
    measured_frequency, ...
    absolute_error, ...
    relative_error, ...
    'VariableNames', { ...
    'Repeat', ...
    'StartTime_s', ...
    'SamplingFrequency_Hz', ...
    'MeasuredFrequency_Hz', ...
    'AbsoluteError_Hz', ...
    'RelativeError_percent'});


%% Repeatability statistics

mean_frequency = ...
    mean(measured_frequency);

standard_deviation = ...
    std(measured_frequency);

coefficient_of_variation = ...
    standard_deviation / ...
    mean_frequency * 100;


%% Display summary

fprintf('\n');
fprintf('========== %s SUMMARY ==========\n', ...
    string_name);

fprintf( ...
    'Theoretical frequency = %.2f Hz\n', ...
    theoretical_frequency);

fprintf( ...
    'Mean frequency = %.4f Hz\n', ...
    mean_frequency);

fprintf( ...
    'Standard deviation = %.4f Hz\n', ...
    standard_deviation);

fprintf( ...
    'Coefficient of variation = %.4f %%\n', ...
    coefficient_of_variation);

end