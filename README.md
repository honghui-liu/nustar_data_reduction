# Bash scripts for reducing NuSTAR data

## To use the scripts
After downloading the observation data from HEASARC, initializing HEASOFT and setting up CALDB, run:
```
bash nustar_reduction.sh [observation_id]
```
Replace [observation_id] in the above command with the observation ID. Then, follow the instructions printed on the screen to select source and background regions and save the region files as requested.

The output of the script are two directories: ${obsid}_pipe and ${obsid}_products. In ${obsid}_products, there are lightcurves and spectra of FPMA and FPMB. The spectra should have been grouped using `ftgrouppa` implementing the optimal binning strategy and also ensuring a minimal counts of 20 for each bin.

The `pro_lc.sh` script is to generate light curves. For example:
```
bash pro_lc.sh obsid low_energy high_energy time_resolution
```
