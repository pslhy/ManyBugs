#! /bin/bash
# $1 : manifest. buggy file  ex) mpn/generic/powm.c

manifest=`cat /experiment/manifest.txt`
loc=`dirname $manifest`
fname=`basename $manifest`
root_loc=/experiment
ptests=`cat /experiment/test.sh | grep -w "p[[:digit:]]*)" | wc -l`
ntests=`cat /experiment/test.sh | grep -w "n[[:digit:]]*)" | wc -l`

# make.sh
if [ -e make.sh ]; then
	echo "File make.sh already exists!"
else
	cat > make.sh <<EOF
#! /bin/bash
cd /experiment/src
make
cd /experiment/src/$loc
EOF
fi

# repair.sh
if [ -e repair.sh ]; then
	echo "File make.sh already exists!"
else
	cat > repair.sh <<EOF
#! /bin/bash
fid=""
sid=""
if [ "\$#" -eq 2 ]; then
	fid="-target_fid \$1"
	sid="-target_sid \$2"
fi
cd /experiment
bash ./set_preprocess.sh
cd /experiment/euphony
. bin/setenv
cd /experiment/src
make
cd /experiment/src/$loc
ln -s /experiment/invrepair/train.sh ./train.sh
ln -s /experiment/invrepair/synth_euphony.sh ./synth_euphony.sh
ln -s /experiment/make.sh ./make.sh
ln -s /experiment/run_test.sh ./run_test.sh
time /experiment/invrepair/repair.native -print_v -scheme jaccard \$sid \$fid -timeout_test 30 -timeout_sygus 180 -debug -euphony -trainer ./train.sh -sygus ./synth_euphony.sh -compile ./make.sh -pos $ptests -neg $ntests $fname ./run_test.sh
EOF
fi

# run_test.sh
if [ -e run_test.sh ]; then
        echo "File run_test.sh already exists!"
else
        cat > run_test.sh <<EOF
#! /bin/bash
cd /experiment
./test.sh \$1
r=\$?
cd /experiment/src/$loc
exit \$r
EOF
fi

chmod +x make.sh
chmod +x run_test.sh
echo "make.sh run_test.sh finish!"


# copy origin file
if [ $loc != "." ]
then
	mkdir -p $root_loc/origin_file/$loc
	cp $root_loc/src/$loc/$fname $root_loc/origin_file/$loc
else
	mkdir -p $root_loc/origin_file
        cp $root_loc/src/$fname $root_loc/origin_file/
fi
