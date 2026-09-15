%% Create Summary Table
% Collects the results of all analyzed guitar strings
% and creates a final summary table.

clear;
clc;

%% Theoretical frequencies
theoretical = [82.41; 110.00; 146.83; 196.00];

%% Run analysis for each string
E2_results = analyze_string('E2', theoretical(1));
A2_results = analyze_string('A2', theoretical(2));
D3_results = analyze_string('D3', theoretical(3));
G3_results = analyze_string('G3', theoretical(4));

%% Calculate summary statistics

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

coefficient_of_variation = [
    std(E2_results.MeasuredFrequency_Hz) / mean(E2_results.MeasuredFrequency_Hz) * 100
    std(A2_results.MeasuredFrequency_Hz) / mean(A2_results.MeasuredFrequency_Hz) * 100
    std(D3_results.MeasuredFrequency_Hz) / mean(D3_results.MeasuredFrequency_Hz) * 100
    std(G3_results.MeasuredFrequency_Hz) / mean(G3_results.MeasuredFrequency_Hz) * 100
];

mean_absolute_error = [
    mean(E2_results.AbsoluteError_Hz)
    mean(A2_results.AbsoluteError_Hz)
    mean(D3_results.AbsoluteError_Hz)
    mean(G3_results.AbsoluteError_Hz)
];

mean_relative_error = [
    mean(E2_results.RelativeError_percent)
    mean(A2_results.RelativeError_percent)
    mean(D3_results.RelativeError_percent)
    mean(G3_results.RelativeError_percent)
];

%% Create final summary table

String = ["E2"; "A2"; "D3"; "G3"];

summary_table = table( ...
    String, ...
    theoretical, ...
    mean_frequency, ...
    standard_deviation, ...
    coefficient_of_variation, ...
    mean_absolute_error, ...
    mean_relative_error, ...
    'VariableNames', { ...
    'String', ...
    'TheoreticalFrequency_Hz', ...
    'MeanMeasuredFrequency_Hz', ...
    'StandardDeviation_Hz', ...
    'CV_percent', ...
    'MeanAbsoluteError_Hz', ...
    'MeanRelativeError_percent'});

%% Display summary

disp(' ');
disp('========== FINAL SUMMARY ==========');
disp(summary_table);
%% Save summary table

if ~exist('results/tables', 'dir')
    mkdir('results/tables');
end

writetable(summary_table, ...
    'results/tables/summary_results.csv');