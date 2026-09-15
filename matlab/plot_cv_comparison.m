%% Coefficient of Variation Comparison
% Compares the repeatability of frequency measurements
% for the four guitar strings using the coefficient of variation (CV).

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

%% Calculate coefficient of variation

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

CV = standard_deviation ./ mean_frequency * 100;

%% String names

strings = categorical(["E2", "A2", "D3", "G3"]);

%% Create figure

figure;

bar(strings, CV);

xlabel('Guitar String');
ylabel('Coefficient of Variation (%)');

title('Repeatability Comparison Using Coefficient of Variation');

grid on;
box on;

%% Save figure

if ~exist('results/figures', 'dir')
    mkdir('results/figures');
end

exportgraphics(gcf, ...
    'results/figures/cv_comparison.png', ...
    'Resolution', 300);
