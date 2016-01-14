## 0.3.1

- Backporting updates to be compatible with Spout 0.11.0.beta1

## 0.3.0 (July 10, 2015)

### Changes
- Adds in demographic, anthropormorphic, medical history data from other visits
- The CSV datasets generated from the SAS export is located here:
  - `\\rfa01\bwh-sleepepi-sof\nsrr-prep\_releases\0.3.0\`
    - `sof-eeg-band-summary-dataset-0.3.0.csv`
    - `sof-eeg-spectral-summary-dataset-0.3.0.csv`
    - `sof-psg-visit-8-dataset-0.3.0.csv`

## 0.2.0 (February 13, 2015)

### Changes
- Spectral analysis variables have been added back into the data dictionary
  - Gender has been re-added to the spectral datasets
- 'Signal' has been added as a stratification factor for graphs, where appropriate
- The CSV datasets generated from the SAS export is located here:
  - `\\rfa01\bwh-sleepepi-sof\nsrr-prep\_releases\0.2.0\`
    - `sof-eeg-band-summary-dataset-0.2.0.csv`
    - `sof-eeg-spectral-summary-dataset-0.2.0.csv`
    - `sof-psg-visit-8-dataset-0.2.0.csv`

## 0.1.0 (January 5, 2015)

### Changes
- Dataset was overhauled to only include the full polysomnography dataset, per agreement with SOF Coordinating Center
- Sex has been added to each dataset
- The CSV datasets generated from the SAS export is located here:
  - `\\rfa01\bwh-sleepepi-sof\nsrr-prep\_releases\0.1.0\`
    - `sof-psg-visit-8-dataset-0.1.0.csv`
- **Gem Changes**
  - Updated to spout 0.10.2
  - Use of Ruby 2.1.4 is now recommended
