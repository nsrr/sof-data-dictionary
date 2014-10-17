## 0.1.0

- Sex, race, and categorical age variables have been added to the dataset
  - Sex is `1: Female` for all subjects in SOF
- Variables that contain missing codes and numeric data have been made to be `type: numeric`
- Domain values have been updated to properly reflect exported values
  - Many domains currently do not map to variables; these will become used as further visits are released
- A SAS export script has been added to allow tracking of any modifications to the dataset
- The CSV datasets generated from the SAS export is located here:
  - `\\rfa01\bwh-sleepepi-sof\nsrr-prep\_releases\0.1.0.beta2\`
    - `sof-visit-8-dataset-0.1.0.beta2.csv`
### Changes
- **Gem Changes**
  - Updated to spout 0.9.1
  - Use of Ruby 2.1.3 is now recommended
