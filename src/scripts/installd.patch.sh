#!/bin/bash
dir_root="$( dirname "${0/scripts/}" )"
export PATH="$dir_root/bin:$PATH"
patch_name='installd'
mount_volume="$1"
file_to_patch="${mount_volume}/usr/libexec/installd"
device_info=$( gtimeout -k 1s 10s producttype | grep 'iPhone[0-9],[0-9]:[0-9]\(\.[0-9]\)\{1,2\}' | tr -d '\r' )
device_type=$( echo $device_info | cut -d ':' -f 1 )
device_os_version=$( echo $device_info | cut -d ':' -f 2 )
patch_file="$dir_root/patches/${device_type}_${device_os_version}_${patch_name}.patch"

if [ -e "$patch_file" ] && [ -e "$file_to_patch" ]
then
	bspatch "$file_to_patch" "$file_to_patch" "$patch_file"
fi
