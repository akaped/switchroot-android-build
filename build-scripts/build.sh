#!/bin/bash

JOBS=$(($(nproc) + 1))

echo lineage_$ROM_NAME-userdebug

cd ${BUILDBASE}/android/lineage
source build/envsetup.sh
export USE_CCACHE=1
export CCACHE_EXEC=$(which ccache)
export WITHOUT_CHECK_API=true
ccache -M 50G
lunch lineage_$ROM_NAME-userdebug

if [[ ! -z "$CUSTOM_BUILD" ]]; then
  nice $CUSTOM_BUILD
elif [[ "$ROM_TYPE" == "zip" ]]; then
  nice make -j${JOBS} bacon
else
  nice make -j${JOBS} bootimage && nice make -j${JOBS} vendorimage && nice make -j${JOBS} systemimage
fi
