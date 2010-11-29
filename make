#!/bin/bash
#===============================================================================
#   DESCRIPTION:  Makes the creamsn0w package.
#        AUTHOR:  Sorin Ionescu <sorin.ionescu@gmail.com>
#       VERSION:  1.0.10
#===============================================================================
export PATH=/usr/libexec/:$PATH
cd $( dirname $0 )
version=`git tag | sort -t. -k1,2 -n -k3 | tail -n 1`
ios_version='ios4.1'
bundle_name='creamsn0w'
bundle="${bundle_name}.bundle"
package_name="${bundle_name}_${ios_version}_${version}"
package="${package_name}.zip"
dir_root=$( pwd )
src="$dir_root/src"

rm -rf build
mkdir -p build
cd build

# Start clean.
rm -rf *.zip 
mkdir -p tmp/$bundle
mkdir -p tmp/addons

cp $src/Info.plist tmp/$bundle/
cp -R $src/bin tmp/$bundle/
cp -R $src/files tmp/$bundle/
cp -R $src/patches tmp/$bundle/
cp -R $src/scripts tmp/$bundle/
cp -R $src/installer/* tmp
cp -R $dir_root/*.txt tmp

cd tmp
find . -type f -name '.DS_Store' -delete;
PlistBuddy -c "Add :GetInfoString string '${version}, Copyright 2010 Sorin Ionescu.'" $bundle/Info.plist
PlistBuddy -c "Add :ShortVersionString string ${version}" $bundle/Info.plist
zip -qq -r -y $bundle.zip $bundle
rm -rf $bundle
echo "Making package $package."
zip -qq -r -y $package *
mv $package ..
cd ..

# Cleanup
rm -rf tmp
