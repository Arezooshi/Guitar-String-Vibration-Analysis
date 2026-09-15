%% Harmonic Reliability Summary
% Calculates summary statistics for the second-harmonic
% peak-to-background ratio in five E2 measurements.

clear;
clc;
close all;

%% Peak-to-background ratios
% Values obtained from the five E2 measurements.

peak_to_background = [
    63.065
    200.78
    78.28
    20.67
    6.1664
];

%% Calculate statistics

mean_ratio = mean(peak_to_background);

standard_deviation = std(peak_to_background);

median_ratio = median(peak_to_background);

minimum_ratio = min(peak_to_background);

maximum_ratio = max(peak_to_background);

%% Display results

fprintf('\n');
fprintf('========== HARMONIC RELIABILITY SUMMARY ==========\n');

fprintf('Mean Peak/Background = %.2f\n', ...
    mean_ratio);

fprintf('Standard deviation = %.2f\n', ...
    standard_deviation);

fprintf('Median Peak/Background = %.2f\n', ...
    median_ratio);

fprintf('Minimum Peak/Background = %.2f\n', ...
    minimum_ratio);

fprintf('Maximum Peak/Background = %.2f\n', ...
    maximum_ratio);
