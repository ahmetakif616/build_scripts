#!/bin/bash

rm -rf .repo/local_manifests/

# repo init rom
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b QPR3 -g default,-mips,-darwin,-notdefault
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/Gtajisan/local_manifests -b Los-21 .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# build
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# Git cherry-pick
cd vendor/lineage
git remote add los https://github.com/LineageOS/android_vendor_lineage
git fetch los
git cherry-pick 198966577ace63573e5be49e03a2e59e32997054
cd ../..
echo "===== Cherry-picking Success ====="

# Private keys
git clone https://github.com/Gtajisan/vendor_lineage-priv_keys.git vendor/lineage-priv/keys
echo "===== cp clone done ====="

# remove face unlock 
rm -rf packages/apps/FaceUnlock

# Export
export BUILD_USERNAME=FARHAN
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
. build/envsetup.sh
lunch infinity_Mi439-ap2a-userdebug || lunch infinity_Mi439-ap1a-userdebug 

# make install
make installclean

# make bacon
mka bacon
