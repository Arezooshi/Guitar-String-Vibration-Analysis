# Guitar String Vibration Analysis

A physics-based experimental project investigating guitar-string vibrations using smartphone accelerometer data and Fast Fourier Transform (FFT).

## Project Overview

This project investigates whether a smartphone accelerometer can be used to measure the fundamental frequencies of vibrating guitar strings.

Vibrations were recorded using the phyphox smartphone application. The recorded acceleration signals were processed in MATLAB, and Fast Fourier Transform (FFT) was used to transform the signals from the time domain to the frequency domain.

Four guitar strings were analyzed:

- E2 — 82.41 Hz
- A2 — 110.00 Hz
- D3 — 146.83 Hz
- G3 — 196.00 Hz

Each string was measured five times to evaluate both the accuracy and repeatability of the measurements.

## Experimental Setup

A smartphone equipped with an accelerometer was used to record the mechanical vibrations produced by the guitar strings.

The acceleration data were collected using phyphox and exported as Excel files. The analysis was performed using the X-axis acceleration signal from the `Raw data` sheet.

For each string, five independent measurements were recorded.

## Data Processing

The analysis was performed using the following workflow:

1. Read the acceleration data from the `Raw data` sheet.
2. Calculate the sampling frequency from the recorded time values.
3. Remove the DC component from the acceleration signal.
4. Automatically detect the onset of the main vibration.
5. Select a 4-second analysis segment.
6. Apply a Hann window to reduce spectral leakage.
7. Calculate the Fast Fourier Transform (FFT).
8. Construct the one-sided amplitude spectrum.
9. Identify the fundamental frequency near the theoretical value.
10. Calculate absolute and relative frequency errors.
11. Evaluate repeatability using the standard deviation and coefficient of variation (CV).

## Fundamental Frequency Results

The measured fundamental frequencies were compared with the theoretical frequencies of the four analyzed guitar strings.

![Frequency comparison](results/figures/frequency_comparison.png)

The measurements were generally close to the expected theoretical frequencies. The results demonstrate that smartphone accelerometer measurements can provide a useful estimate of guitar-string fundamental frequencies.

## Frequency Error

The relative frequency error was calculated for each string.

![Frequency error](results/figures/frequency_error.png)

The mean relative errors remained below approximately 1% for all four strings.

## Repeatability

Five repeated measurements were performed for each string.

![Repeatability](results/figures/repeatability.png)

The repeated measurements show a high degree of consistency, although the level of repeatability differs between strings.

## Statistical Summary

The main statistical results are provided in:

`results/tables/summary_results.csv`

The analysis includes:

- Mean measured frequency
- Standard deviation
- Coefficient of variation (CV)
- Mean absolute error
- Mean relative error

An important distinction is made between **accuracy** and **repeatability**.

Accuracy describes how close a measurement is to the theoretical frequency, while repeatability describes how close repeated measurements are to each other.

For example, the D3 measurements showed very high repeatability but a systematic offset from the theoretical frequency. This indicates good repeatability but lower accuracy.

## Frequency-Domain Analysis

FFT analysis was used to identify the dominant frequency components of the measured acceleration signals.

![FFT spectra](results/figures/fft_all_strings.png)

The dominant peaks are located near the expected fundamental frequencies of the analyzed strings.

## Harmonic Analysis

The E2 string was investigated further to examine its harmonic structure.

The fundamental frequency was detected near 82.5 Hz, while a second harmonic was detected near 165 Hz.

Since the second harmonic is approximately twice the fundamental frequency, this result is consistent with the expected harmonic structure of a vibrating string.

![E2 harmonic analysis](results/figures/e2_harmonic_analysis.png)

The harmonic results for the five repeated E2 measurements are available in:

`results/tables/E2_harmonic_results.csv`

## Harmonic Peak Reliability

The second harmonic was detected in all five E2 measurements.

The peak-to-background ratio was used to evaluate how clearly the second-harmonic peak could be distinguished from the surrounding spectral background.

![Harmonic reliability](results/figures/e2_harmonic_reliability.png)

The peak-to-background ratio varied considerably between measurements, but the second harmonic remained distinguishable from the local spectral background in all five measurements.

This indicates that the frequency location of the harmonic was more stable than its measured amplitude.

## Key Findings

The main findings of the project are:

- Smartphone accelerometer data can be used to estimate guitar-string fundamental frequencies.
- FFT provides a clear method for identifying the dominant frequency components.
- Repeated measurements showed good frequency repeatability.
- Measurement accuracy and repeatability are not necessarily the same.
- The D3 string showed high repeatability but a systematic frequency offset.
- The E2 measurements revealed a detectable second harmonic near twice the fundamental frequency.
- Harmonic amplitude measurements were considerably more variable than frequency measurements.
- Experimental conditions can strongly affect measured vibration amplitudes.

## Limitations

Several experimental limitations should be considered:

- The measurements were performed using a smartphone accelerometer rather than a dedicated vibration sensor.
- The sampling frequency limits the highest directly measurable frequency because of the Nyquist limit.
- The measured amplitude depends strongly on the experimental setup and sensor placement.
- Only four of the six standard guitar strings were analyzed because of the available sampling frequency.
- The harmonic amplitude ratios showed substantial variation between repeated measurements.

## Project Structure

```text
Guitar-String-Vibration-Analysis/
│
├── README.md
│
├── matlab/
│
├── results/
│   ├── figures/
│   └── tables/
│
└── report/
