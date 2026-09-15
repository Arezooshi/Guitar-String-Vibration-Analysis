%% Frequency Error Analysis
% Shows the difference between the measured and
% theoretical fundamental frequencies.

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

%% Calculate mean relative error

mean_relative_error = [
    mean(E2_results.RelativeError_percent)
    mean(A2_results.RelativeError_percent)
    mean(D3_results.RelativeError_percent)
    mean(G3_results.RelativeError_percent)
];

%% String names

strings = categorical(["E2", "A2", "D3", "G3"]);

%% Create figure

figure;

bar(strings, mean_relative_error);

xlabel('Guitar String');
ylabel('Mean Relative Error (%)');

title('Mean Relative Frequency Error');

grid on;
box on;

%% Save figure

if ~exist('results/figures', 'dir')
    mkdir('results/figures');
end

exportgraphics(gcf, ...
    'results/figures/frequency_error.png', ...
    'Resolution', 300);