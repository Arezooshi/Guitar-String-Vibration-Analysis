%% Harmonic Peak Reliability
% Shows the peak-to-background ratio of the second harmonic
% for five repeated E2 measurements.

clear;
clc;
close all;

%% Peak-to-background ratios

repeat_number = (1:5)';

peak_to_background = [
    63.065
    200.78
    78.28
    20.67
    6.1664
];

%% Calculate median

median_ratio = median(peak_to_background);

%% Create figure

figure;

bar(repeat_number, peak_to_background);

hold on;

%% Median line

yline(median_ratio, ...
    '--', ...
    'LineWidth', 1.5);

%% Labels

xlabel('Measurement');
ylabel('Peak / Background Ratio');

title('Reliability of the E2 Second Harmonic');

legend( ...
    'Peak-to-background ratio', ...
    'Median', ...
    'Location', 'northeast');

xticks(1:5);

grid on;
box on;

hold off;

%% Save figure

if ~exist('results/figures', 'dir')
    mkdir('results/figures');
end

exportgraphics(gcf, ...
    'results/figures/e2_harmonic_reliability.png', ...
    'Resolution', 300);

fprintf('\nFigure saved to:\n');
fprintf('results/figures/e2_harmonic_reliability.png\n');