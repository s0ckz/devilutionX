#!/bin/sh
echo $0 $*
progdir=/mnt/SDCARD/Apps/DevilutionX

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$progdir

DEVILUTION_X_DIR=/mnt/SDCARD/Apps/DevilutionX
cd $DEVILUTION_X_DIR/

HOME=$DEVILUTION_X_DIR/ $DEVILUTION_X_DIR/devilutionx
