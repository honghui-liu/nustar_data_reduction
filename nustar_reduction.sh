#!/bin/bash

obs_id=$1

echo ">>> Working on the obs: $obs_id"

echo ">>> Runing nupipeline:"
echo "nupipeline indir=./${obs_id} outdir=./${obs_id}_pipe steminputs=nu${obs_id}"
nupipeline indir=./${obs_id} outdir=./${obs_id}_pipe steminputs=nu${obs_id} 

echo ">>> nupipeline finished."
echo ">>> Note that if the source is bright e.g., > 100 counts/s/FPM, you may want to try nupipeline with:"
echo ">>> nupipeline indir=./${obs_id} outdir=./${obs_id}_pipe_statue steminputs=nu${obs_id} statusexpr='(STATUS==b0000xxx00xxxx000)&&(SHIELD==0)' saamode=STRICT tentacle=yes"
echo ">>> For details, check: https://heasarc.gsfc.nasa.gov/docs/nustar/nustar_faq.html#:~:text=For%20bright%20sources%2C%20NuSTAR%20often,particle%20hitting%20the%20CsI%20shield."

cd ./${obs_id}_pipe

echo ">>> Draw source and background regions."

A01_cl="$(ls  *A01_cl.evt)"
B01_cl="$(ls  *B01_cl.evt)"

echo ">>> Creat the source and backgroud region with ds9"
echo ">>> Working on FPMA"
echo ">>> Regions should be saved with name fpma_src.reg and fpma_bkg.reg in physical/fk5 coordinate"

ds9 ${A01_cl} -cmap he -log

echo ">>> Creat the source and backgroud region with ds9"
echo ">>> Working on FPMB"
echo ">>> Regions should be saved with name fpmb_src.reg and fpmb_bkg.reg in physical/fk5 coordinate"

ds9 ${B01_cl} -cmap he -log

echo -e "\n"
echo ">>>Check the regions"
ds9 ${A01_cl} -cmap he -log -regions load fpma_src.reg -regions load fpma_bkg.reg ${B01_cl} -cmap he -log -regions load fpmb_src.reg -regions load fpmb_bkg.reg

cd ..

echo ">>> Run nuproduct to extract spectra and lightcurves"

nuproducts srcregionfile=${obs_id}_pipe/fpma_src.reg bkgregionfile=${obs_id}_pipe/fpma_bkg.reg indir=${obs_id}_pipe outdir=./${obs_id}_products instrument=FPMA steminputs=nu$obs_id bkgextract=yes
nuproducts srcregionfile=${obs_id}_pipe/fpmb_src.reg bkgregionfile=${obs_id}_pipe/fpmb_bkg.reg indir=${obs_id}_pipe outdir=./${obs_id}_products instrument=FPMB steminputs=nu$obs_id bkgextract=yes

echo ">>> nuproducts srcregionfile=${obs_id}_pipe/fpma_src.reg bkgregionfile=${obs_id}_pipe/fpma_bkg.reg indir=${obs_id}_pipe outdir=./${obs_id}_products instrument=FPMA steminputs=nu$obs_id bkgextract=yes"
echo ">>> nuproducts srcregionfile=${obs_id}_pipe/fpmb_src.reg bkgregionfile=${obs_id}_pipe/fpmb_bkg.reg indir=${obs_id}_pipe outdir=./${obs_id}_products instrument=FPMB steminputs=nu$obs_id bkgextract=yes"

echo ">>> Data reduction done!"

echo ">>> Group the spectra with optimal binning"

cd ${obs_id}_products

src_A="$(ls  *A*sr.pha)"
src_B="$(ls  *B*sr.pha)"

rmf_A="$(ls  *A*sr.rmf)"
rmf_B="$(ls  *B*sr.rmf)"

ftgrouppha infile=${src_A} outfile=fpma_optmin20.pha respfile=${rmf_A} grouptype=optmin groupscale=20 clobber=yes
ftgrouppha infile=${src_B} outfile=fpmb_optmin20.pha respfile=${rmf_B} grouptype=optmin groupscale=20 clobber=yes

echo ">>> ftgrouppha infile=${src_A} outfile=fpma_optmin20.pha respfile=${rmf_A} grouptype=optmin groupscale=20 clobber=yes"
echo ">>> ftgrouppha infile=${src_B} outfile=fpmb_optmin20.pha respfile=${rmf_B} grouptype=optmin groupscale=20 clobber=yes"

echo ">>> Group spectra finished."

cd ..

