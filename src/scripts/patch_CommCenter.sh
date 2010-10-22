#!/bin/sh

cd "$( dirname $0 )"
PATH="/usr/bin:$PATH"
patch_name='CommCenter'
file_to_patch='System/Library/Frameworks/CoreTelephony.framework/Support/CommCenter'
device_info=$( ./producttype | grep 'iPhone[0-9],[0-9]:[0-9]\(\.[0-9]\)\{1,2\}' | tr -d '\r' )
device_type=$( echo $device_info | cut -d ':' -f 1 )
device_os_version=$( echo $device_info | cut -d ':' -f 2 )
patch_file="${device_type}_${device_os_version}_${patch_name}.patch"

if [ -e '$patch_file' ] && [ -e '$file_to_patch' ]
then
	./bspatch '$file_to_patch' '$file_to_patch' '$patch_file'
fi
