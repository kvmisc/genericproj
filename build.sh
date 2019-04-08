#!/bin/bash

echo "Preparing parameters..."
WORKSPACE_NAME="GenericProj.xcworkspace"
SCHEME_NAME="GenericProj"
BUILD_ROOT="`pwd`/build"
PACKAGE_NAME="${SCHEME_NAME}-$1-`date +'%m%d%H%M'`"

if [[ $1 = "debug" ]]; then
BUILD_SETTING="DAILY_DEBUG=1"
elif [[ $1 = "release" ]]; then
BUILD_SETTING="DAILY_RELEASE=1"
else
BUILD_SETTING="DAILY_DEBUG=1"
fi


echo "Renewing build directory..."
rm -rf ${BUILD_ROOT}
mkdir ${BUILD_ROOT}

echo "Building scheme..."
xcodebuild \
  -workspace ${WORKSPACE_NAME} \
  -scheme ${SCHEME_NAME} \
  -destination generic/platform=iOS \
  -configuration Release \
  -sdk iphoneos \
  OBJROOT=${BUILD_ROOT} SYMROOT=${BUILD_ROOT} GCC_PREPROCESSOR_DEFINITIONS='${inherited}'" ${BUILD_SETTING}"
if [[ $? -ne 0 ]]; then
  printf "\n\n\n    Failed: There's something wrong while building\n\n\n"
  exit 1
fi

echo "Packaging scheme..."
cd ${BUILD_ROOT}
mkdir Payload
cp -r Release-iphoneos/${SCHEME_NAME}.app Payload
zip -rq ${PACKAGE_NAME}.ipa Payload
rm -rf Payload


printf "\n\n\n    >>> Success <<<\n\n\n"
printf '\7'
