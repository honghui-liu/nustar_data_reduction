#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 4 ]; then
    echo "Usage: $0 obs_id el eh tbin"
    exit 1
fi

# Assign command line arguments to variables
id=$1
el=$2
eh=$3
tbin=$4

# Calculate PI values
pil=$(echo "($el - 1.6) * 25" | bc)
pih=$(echo "($eh - 1.6) * 25" | bc)

# Convert PI values to integers
int_pil=$(echo "$pil / 1" | bc)
int_pih=$(echo "$pih / 1" | bc)

# Print information about the light curve being generated
echo ">>> Generating light curve for obs: ${id}"
echo ">>> in the energy band ($el, $eh) keV"
echo ">>> corresponding to PI ($int_pil, $int_pih)"
echo ">>> using timebinszie $tbin s."

# Run nuproducts for FPMA and FPMB
nuproducts indir=./${id}_pipe instrument=FPMA steminputs=nu${id} phafile=NONE outdir=./${id}_lc_${el}_${eh} srcregionfile=./${id}_pipe/fpma_src.reg bkgextract=no bkglcfile=NONE imagefile=NONE runmkarf=no runmkrmf=no pilow=${int_pil} pihigh=${int_pih} binsize=$tbin
nuproducts indir=./${id}_pipe instrument=FPMB steminputs=nu${id} phafile=NONE outdir=./${id}_lc_${el}_${eh} srcregionfile=./${id}_pipe/fpmb_src.reg bkgextract=no bkglcfile=NONE imagefile=NONE runmkarf=no runmkrmf=no pilow=${int_pil} pihigh=${int_pih} binsize=$tbin

# Print the compiled commands
echo ">>> The compiled commands are listed below:"
echo "nuproducts indir=./${id}_pipe instrument=FPMA steminputs=nu${id} phafile=NONE outdir=./${id}_lc_${el}_${eh} srcregionfile=./${id}_pipe/fpma_src.reg bkgextract=no bkglcfile=NONE imagefile=NONE runmkarf=no runmkrmf=no pilow=${int_pil} pihigh=${int_pih} binsize=$tbin"
echo "nuproducts indir=./${id}_pipe instrument=FPMB steminputs=nu${id} phafile=NONE outdir=./${id}_lc_${el}_${eh} srcregionfile=./${id}_pipe/fpmb_src.reg bkgextract=no bkglcfile=NONE imagefile=NONE runmkarf=no runmkrmf=no pilow=${int_pil} pihigh=${int_pih} binsize=$tbin"
