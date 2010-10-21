#!/bin/bash
#===============================================================================
#
#          FILE:  build
#
#         USAGE:  ./build
#
#   DESCRIPTION:  Makes the creamsn0w package.
#
#        AUTHOR:  Sorin Ionescu <sorin.ionescu@gmail.com>
#       VERSION:  1.0.6
#       CREATED:  2010-08-10 23:18:05-04:00
#===============================================================================
cd $( dirname $0 )
VERSION=`git tag | sort -n -k3 -t. | tail -n 1`
BUNDLE_NAME='creamsn0w'
BUNDLE="${BUNDLE_NAME}.bundle"
PACKAGE_NAME="${BUNDLE_NAME}_${VERSION}"
PACKAGE="${PACKAGE_NAME}.zip"
DIR_ROOT=$( pwd )
SRC="$DIR_ROOT/src"
DOC="$DIR_ROOT/doc"
PLISTBUDDY="$DIR_ROOT/src/bin/PlistBuddy"

mkdir -p build
cd build

# Start clean.
rm -rf *.zip 
mkdir -p tmp/$BUNDLE
mkdir -p tmp/addons

cp $SRC/Info.plist tmp/$BUNDLE/
cp -R $SRC/files  tmp/$BUNDLE/
cp -R $SRC/patches  tmp/$BUNDLE/
cp $SRC/scripts/* tmp
cp $DOC/* tmp
cp -R $SRC/bin tmp/

cd tmp
find . -type f -name '.DS_Store' -delete;
$PLISTBUDDY -c "Add :GetInfoString string '${VERSION}, Copyright 2010 Sorin Ionescu.'" $BUNDLE/Info.plist
$PLISTBUDDY -c "Add :ShortVersionString string ${VERSION}" $BUNDLE/Info.plist
zip -qq -r -y $BUNDLE.zip $BUNDLE
rm -rf $BUNDLE
echo "Making package $PACKAGE."
zip -qq -r -y $PACKAGE *
mv $PACKAGE ..
cd ..

# Cleanup
rm -rf tmp
