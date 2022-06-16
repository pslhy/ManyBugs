#! /bin/bash
manifest=`cat /experiment/manifest.txt`
loc=`dirname $manifest`
fname=`basename $manifest`
root_loc=/experiment

if [ $loc != "." ] 
then
	# set preprocess
	cp $root_loc/preprocessed/$loc/$fname $root_loc/src/$loc/
else 
        # set preprocess
        cp $root_loc/preprocessed/$fname $root_loc/src/$loc/
fi
echo "set preprocessed file complete"