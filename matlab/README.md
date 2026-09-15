# MATLAB Analysis Scripts

This folder contains the MATLAB scripts used for processing and analyzing the smartphone accelerometer data collected from vibrating guitar strings.

The scripts perform data processing, FFT-based frequency analysis, repeatability analysis, harmonic analysis, and visualization.

## Analysis Workflow

The main analysis follows this general workflow:

1. Import acceleration data from Excel files.
2. Estimate the sampling frequency.
3. Remove the DC component from the signal.
4. Detect the beginning of the main vibration.
5. Select a fixed analysis segment.
6. Apply a Hann window.
7. Calculate the Fast Fourier Transform (FFT).
8. Extract the dominant fundamental frequency.
9. Calculate frequency errors.
10. Evaluate repeatability using standard deviation and coefficient of variation.
11. Analyze harmonic components for the E2 string.
12. Generate figures and summary tables.

## Main Scripts

### `main_analysis.m`

Main script for running the fundamental-frequency analysis for the four analyzed strings:

- E2
- A2
- D3
- G3

It calls `analyze_string.m` for each string.

### `analyze_string.m`

Performs the main signal-processing and FFT analysis for five repeated measurements of a guitar string.

It:

- Reads the acceleration data
- Calculates the sampling frequency
- Removes the DC component
- Detects vibration onset
- Selects a 4-second segment
- Applies a Hann window
- Calculates the FFT
- Identifies the fundamental frequency
- Calculates absolute and relative errors
- Calculates repeatability statistics

### `create_summary.m`

Combines the results from the four guitar strings into a summary table containing:

- Theoretical frequency
- Mean measured frequency
- Standard deviation
- Coefficient of variation
- Mean absolute error
- Mean relative error

### `plot_frequency_comparison.m`

Creates a comparison between theoretical and measured fundamental frequencies.

### `plot_frequency_error.m`

Plots the relative frequency error for the analyzed strings.

### `plot_repeatability.m`

Visualizes the repeated frequency measurements for each guitar string.

### `plot_cv_comparison.m`

Compares the coefficient of variation (CV) between the four strings.

### `plot_fft_spectrum.m`

Generates an FFT spectrum for an individual measurement to visualize the frequency components of the vibration signal.

### `plot_fft_all_strings.m`

Displays the frequency-domain spectra of the four analyzed guitar strings.

### `analyze_harmonics.m`

Performs harmonic analysis for an E2 measurement and identifies the fundamental and second-harmonic components.

### `analyze_e2_harmonics.m`

Performs harmonic analysis for all five E2 measurements and compares the fundamental and second-harmonic frequencies and amplitudes.

### `check_harmonic_peaks.m`

Evaluates the reliability of the detected second-harmonic peak by comparing its amplitude with the surrounding spectral background.

### `harmonic_reliability_summary.m`

Calculates summary statistics for the second-harmonic peak-to-background ratios.

### `plot_harmonic_reliability.m`

Creates a plot showing the peak-to-background ratio of the second harmonic across the five E2 measurements.

## Input Data

The MATLAB scripts expect Excel files containing the accelerometer measurements.

The expected naming format is:

```text
E2(1).xlsx
E2(2).xlsx
...
E2(5).xlsx
