%% Repeatability Analysis
% Shows the measured frequency for each repeated
% measurement of the four guitar strings.

clear;
clc;
close all;

%% Theoretical frequencies

theoretical_frequency = [
    82.41
    110.00
    146.83
    196.00
];

%% Analyze each string

E2_results = analyze_string('E2', theoretical_frequency(1));
A2_results = analyze_string('A2', theoretical_frequency(2));
D3_results = analyze_string('D3', theoretical_frequency(3));
G3_results = analyze_string('G3', theoretical_frequency(4));

%% Combine measured frequencies

measured_frequencies = [
    E2_results.MeasuredFrequency_Hz
    A2_results.MeasuredFrequency_Hz
    D3_results.MeasuredFrequency_Hz
    G3_results.MeasuredFrequency_Hz
];

%% Create string labels

string_labels = [
    repmat("E2", 5, 1)
    repmat("A2", 5, 1)
    repmat("D3", 5, 1)
    repmat("G3", 5, 1)
];

string_labels = categorical(string_labels);

%% Create repeat numbers

repeat_number = repmat((1:5)', 4, 1);

%% Create figure

figure;

hold on;

%% Plot individual measurements

scatter(string_labels, measured_frequencies, ...
    60, 'filled');

%% Plot theoretical frequencies

plot(categorical(["E2", "A2", "D3", "G3"]), ...
    theoretical_frequency, ...
    'LineStyle', '--', ...
    'Marker', 'o', ...
    'LineWidth', 1.5);

%% Labels

xlabel('Guitar String');
ylabel('Measured Frequency (Hz)');

title('Repeatability of Fundamental Frequency Measurements');

legend('Individual Measurements', ...
       'Theoretical Frequency', ...
       'Location', 'best');

grid on;
box on;

hold off;

%% Save figure

if ~exist('results/figures', 'dir')
    mkdir('results/figures');
end

exportgraphics(gcf, ...
    'results/figures/repeatability.png', ...
    'Resolution', 300);
