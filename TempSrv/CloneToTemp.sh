#!/bin/sh

# only one parameter
if [ "$1" = "" ]; then
	echo "usage: $0 <vm-to-clone>"
	exit 1
fi

VMTOCOPY=$1

CURDATE=$(date +"%y%m%d_%H%M")
OLDXMLFILE="tmp_$CURDATE.xml"

# get the xml
sudo virsh dumpxml $VMTOCOPY > $OLDXMLFILE
if [ $? -ne 0 ]; then
	echo something went wrong getting the xml
	exit 2
fi

# vars
NEWDOMAIN="$1_$CURDATE"
OLDIMG=$(cat $OLDXMLFILE | sed -ne "s#<source file='\(.*\)'/>#\1#p" | grep -v iso | sed 's/^ *//g') # find data, then skip all iso, then trim.
NEWIMG="$(dirname $OLDIMG)/$(basename $OLDIMG '.img')_$CURDATE.img"

echo "Cloning virtual machine $VMTOCOPY"
echo "- base image is $OLDIMG"
echo "- will create overlayed image $NEWIMG"
echo "- new domain is $NEWDOMAIN"


echo will run
echo ./CloneVm.sh $VMTOCOPY $NEWDOMAIN $NEWIMG

echo Cleaning up
#rm $OLDXMLFILE

# yeah! success
exit 0