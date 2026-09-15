%% Frequency Comparison Plot
% Compares measured and theoretical frequencies
% for the four guitar strings.
%
% The data are obtained automatically from the analysis results.

clear;
clc;
close all;

%% Run string analyses

E2_results = analyze_string('E2', 82.41);
A2_results = analyze_string('A2', 110.00);
D3_results = analyze_string('D3', 146.83);
G3_results = analyze_string('G3', 196.00);

%% Create summary data

strings = ["E2"; "A2"; "D3"; "G3"];

theoretical_frequency = [
    82.41
    110.00
    146.83
    196.00
];

mean_frequency = [
    mean(E2_results.MeasuredFrequency_Hz)
    mean(A2_results.MeasuredFrequency_Hz)
    mean(D3_results.MeasuredFrequency_Hz)
    mean(G3_results.MeasuredFrequency_Hz)
];

standard_deviation = [
    std(E2_results.MeasuredFrequency_Hz)
    std(A2_results.MeasuredFrequency_Hz)
    std(D3_results.MeasuredFrequency_Hz)
    std(G3_results.MeasuredFrequency_Hz)
];

%% Convert strings to categorical

strings = categorical(strings);

%% Create figure

figure;

hold on;

%% Plot theoretical frequencies

plot(strings, theoretical_frequency, ...
    'LineStyle', '--', ...
    'Marker', 'o', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 7);

%% Plot measured frequencies with standard deviation

errorbar(strings, mean_frequency, standard_deviation, ...
    'LineStyle', 'none', ...
    'Marker', 'o', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 7);

%% Labels and formatting

xlabel('Guitar String');
ylabel('Frequency (Hz)');

title('Measured vs. Theoretical Fundamental Frequencies');

legend('Theoretical Frequency', ...
       'Measured Frequency \pm SD', ...
       'Location', 'northwest');

grid on;
box on;

%% Save figure

if ~exist('results/figures', 'dir')
    mkdir('results/figures');
end

exportgraphics(gcf, ...
    'results/figures/frequency_comparison.png', ...
    'Resolution', 300);
hold off;