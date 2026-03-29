#!/bin/bash
#
# Run layout GDS generation on sg13cmos5l_caravel_openframe
# Run this script from the magic/ directory
#
# This is a compositor designed to do the following:
# (1) Read the project wrapper GDS in "readonly" mode
# (2) Read the seal ring
# (3) Read the padframe
# (4) Place the user project wrapper
# (5) Write final GDS with no hierarchical processing
#
# Not done (yet)---Set the user ID
# Not done (yet)---Complain if the openframe top level already exists.
#
echo ${PDK_ROOT:=/home/tim/gits} > /dev/null
echo ${PDK:=ihp-sg13cmos5l} > /dev/null

echo "Generating GDS for sg13cmos5l_caravel_openframe"

magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
drc off
crashbackups stop
locking disable

gds readonly true
gds rescale false
gds read ../gds/openframe_project_wrapper.gds.gz

units microns
snap internal

addpath sealring
load sg13cmos5l_caravel_openframe -silent
box values 0 0 0 0
getcell sealring_complete
box move ne 16.1
getcell sg13cmos5l_padframe
box values 0 0 0 0
box move ne 295.1
getcell openframe_project_wrapper

cif *hier write disable
gds compress 9
gds write sg13cmos5l_caravel_openframe
quit -noprompt
EOF
mv sg13cmos5l_caravel_openframe.gds.gz ../gds/
echo "Done!"
exit 0
