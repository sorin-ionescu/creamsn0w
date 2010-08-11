#!/bin/sh

DIRNAME=$(dirname $0)
FILE_TO_PATCH="System/Library/Frameworks/CoreTelephony.framework/Support/CommCenter"
DEVICE_TYPE=`${DIRNAME}/producttype | awk -F':' '/iPhone[0-9],[0-9]/ { print $1 }'`

if [ "$DEVICE_TYPE"  == "iPhone1,2" ]
then
    PATCH_FILE="${DIRNAME}/CommCenter.3G.patch"
fi	   
	         
if [ "$DEVICE_TYPE"  == "iPhone2,1" ] || [ "$DEVICE_TYPE"  == "iPhone3,1" ]
then
    PATCH_FILE="${DIRNAME}/CommCenter.3GS-4.patch"
fi

bspatch "$FILE_TO_PATCH" "$FILE_TO_PATCH" "$PATCH_FILE"