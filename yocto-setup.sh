#!/bin/bash

add_layers() {
	bitbake-layers add-layer ../source/openembedded-core/meta
	bitbake-layers add-layer ../source/openembedded-core/meta-selftest
	bitbake-layers add-layer ../source/openembedded-core/meta-skeleton
	bitbake-layers add-layer ../source/meta-openembedded/meta-initramfs
	bitbake-layers add-layer ../source/meta-openembedded/meta-oe
	bitbake-layers add-layer ../source/meta-openembedded/meta-filesystems
	bitbake-layers add-layer ../source/meta-openembedded/meta-python
	bitbake-layers add-layer ../source/meta-openembedded/meta-multimedia
	bitbake-layers add-layer ../source/meta-openembedded/meta-networking
	bitbake-layers add-layer ../source/meta-openembedded/meta-gnome
	bitbake-layers add-layer ../source/meta-openembedded/meta-perl
	bitbake-layers add-layer ../source/meta-openembedded/meta-webserver
	bitbake-layers add-layer ../source/meta-openembedded/meta-xfce
	bitbake-layers add-layer ../source/meta-selinux
	bitbake-layers add-layer ../source/meta-virtualization
	bitbake-layers add-layer ../source/meta-security
	bitbake-layers add-layer ../source/meta-security/meta-hardening
	bitbake-layers add-layer ../source/meta-security/meta-integrity
	bitbake-layers add-layer ../source/meta-security/meta-tpm

	echo -e "\n\n ##### Setup #####"
	echo -e 'Build and all layers are setup, try your first "bitbake" command'
}

if [ -f ~/bin/repo ]
then
	echo "Using existing Google repo available @ ~/bin/repo!"
else
	echo "## Add Google repo using curl"
	test -d ~/bin || mkdir ~/bin
	curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	chmod a+x ~/bin/repo
	PATH=${PATH}:~/bin
fi

if [ $1 ]
then
	branch=$1
else
	branch=master
fi

echo -e '"$branch" branch is used for manifest repo.'

mkdir yocto-setup-$branch && cd yocto-setup-$branch

repo init -u https://github.com/sanjayembedded/yocto-manifest -b $branch

if [ $? != 0 ]
then
	echo -e "\n\nNetwork issue or $branch is not available in manifest repo"
	echo -e  "Please check $branch in manifest and try again"
	cd ..
	rm -rf yocto-setup-$branch && "Removed yocto-setup-$branch!!"
else
	echo "Successfull repo initialization !!"
	repo sync
	source source/openembedded-core/oe-init-build-env build
	add_layers
fi

