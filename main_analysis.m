%% Guitar String Vibration Analysis
% Main analysis script
%
% This project analyzes guitar-string vibrations using
% smartphone accelerometer data and FFT.

clear;
clc;
close all;


%% E2 string

E2_results = analyze_string( ...
    'E2', ...
    82.41);


%% A2 string

A2_results = analyze_string( ...
    'A2', ...
    110.00);
%% D3 string

D3_results = analyze_string( ...
    'D3', ...
    146.83);


%% G3 string

G3_results = analyze_string( ...
    'G3', ...
    196.00);