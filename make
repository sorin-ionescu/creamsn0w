#!/bin/bash
#===============================================================================
#   DESCRIPTION:  Makes the creamsn0w package.
#        AUTHOR:  Sorin Ionescu <sorin.ionescu@gmail.com>
#       VERSION:  1.0.11
#==============================================================================
export PATH=/usr/libexec/:$PATH
cd "$( dirname $0 )"
version=`git tag | sort -t. -k1,2 -n -k3 | tail -n 1`
ios_version='ios4.1'
bundle_name='creamsn0w'
bundle_suffix='bundle'
package_name="${bundle_name}_${ios_version}_${version}"
package="${package_name}.zip"
dir_root="$PWD"
build_dir="${dir_root}/build"
src="${dir_root}/src"

# Start clean.
rm -rf "$build_dir"
mkdir -p "${build_dir}/addons"
mkdir -p "${build_dir}/payload"
cd "$build_dir"

if (( $(ls "${src}/firmware" | wc -l) > 0 ))
then
    for firmware_dir in $(find "${src}/firmware" -depth 1 -type d)
    do
        firmware_name=$(echo "$firmware_dir" | awk 'BEGIN { FS="/" } ; {print $NF}')
        bundle="${firmware_name}_${bundle_name}.${bundle_suffix}"
        ditto "${src}/main" "$bundle"

        echo "Macking bundle ${bundle}."
        mkdir -p tmp 
        ditto "$firmware_dir" tmp 
        for plist in $(find tmp -type f -name "*.plist")
        do
            entry=$(echo "$plist" | awk 'BEGIN { FS="/" } ; {print $NF}' | sed 's/.plist//')
            PlistBuddy -c "Merge ${plist} :${entry}" "${bundle}/Info.plist"
        done
        rm -rf tmp/*.plist 
        ditto tmp "$bundle"
        rm -rf tmp
        
        PlistBuddy -c "Add :SupportedFirmware: string ${firmware_name}" "${bundle}/Info.plist"
        PlistBuddy -c "Add :GetInfoString string '${version}, Copyright 2010 Sorin Ionescu.'" "${bundle}/Info.plist"
        PlistBuddy -c "Add :ShortVersionString string ${version}" "${bundle}/Info.plist"

        find . -type f -name '.DS_Store' -delete;
        zip -qq -r -y "payload/${bundle}.zip" "${bundle}"
        rm -rf "${bundle}"
    done
fi

ditto "${src}/installer" "$build_dir"
cp "${dir_root}"/*.txt "$build_dir"
echo "Making package $package."
zip -qq -r -y "$package" *
find . ! -name "$package" -delete

