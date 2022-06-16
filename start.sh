#! /bin/bash
# $1 : manifest. buggy file  ex) mpn/generic/powm.c

manifest=`cat /experiment/manifest.txt`
loc=`dirname $manifest`
fname=`basename $manifest`
root_loc=/experiment

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

# run_test.sh
if [ -e run_test.sh ]; then
        echo "File run_test.sh already exists!"
else
        cat > run_test.sh <<EOF
#! /bin/bash
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