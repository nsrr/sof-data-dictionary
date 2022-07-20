## 0.7.0

- Add initial set of harmonized variables (nsrr_*)
- Add BP variables from V8 sleep visit
- **Gem Changes**
  - Updated to Ruby 3.0.2

## 0.6.1 (September 22, 2020)

- Remove extraneous labels causing certain variables to not display correctly

## 0.6.0 (November 18, 2019)

- Remove EEG spectral summary variables
- The CSV datasets generated from the SAS export are located here:
  - `\\rfawin\bwh-sleepepi-sof\nsrr-prep\_releases\0.6.0\`
- **Gem Changes**
  - Updated to Ruby 2.6.1
  - Updated to spout 1.0.0

## 0.5.0 (June 7, 2018)

- Clean up .sas import script
- Make time variables output as hh:mm:ss format
- Remove certain duplicate sleep architecture variables
- Remove references to 'pdrid' with 'sofid' variable for primary identifier
- The CSV datasets generated from the SAS export are located here:
  - `\\rfawin\bwh-sleepepi-sof\nsrr-prep\_releases\0.5.0\`

## 0.4.2 (March 8, 2018)

- Add abbreviations to folder names
- Remove duplicate domain
- Update many variable unit abbreviations
- Update variable display names to remove unnecessary capitilizations

## 0.4.1 (February 26, 2018)

- Minor updates to domains
- Update variable display names and units
- **Gem Changes**
  - Updated to spout 0.12.1

## 0.4.0 (April 19, 2016)

- Changed variable type for `pdrid`
- Update `age_category` variable with less categories
- Recoded age values greater than 89
- Removed `sex` variable (kept `gender`)
- Add ICSD3 equivalent AHI variables, e.g. `ahi_a0h3`
- The CSV datasets generated from the SAS export is located here:
  - `\\rfa01\bwh-sleepepi-sof\nsrr-prep\_releases\0.4.0\`
    - `sof-visit-8-dataset-0.4.0.csv`
    - `sof-visit-8-eeg-band-summary-dataset-0.4.0.csv`
    - `sof-visit-8-eeg-spectral-summary-dataset-0.4.0.csv`
- **Gem Changes**
  - Updated to spout 0.11.1

## 0.3.1 (January 19, 2016)

- Fixed domains for `v1hyten` and `v1diabcl`

- **Gem Changes**
  - Updated to ruby 2.3.0
  - Updated to spout 0.11.0

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
