# FROM debian:8.3

FROM ubuntu:12.04
MAINTAINER Marco Zocca <surname dot name gmail>

RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates

# # build tools

RUN apt-get install -y wget curl bzip2

# ### compile VirtualBox from scratch, wheee !

# # virtualbox prerequisites

RUN apt-get install -y gcc g++ bcc iasl xsltproc uuid-dev zlib1g-dev libidl-dev \
                libsdl1.2-dev libxcursor-dev libasound2-dev libstdc++5 \
                libhal-dev libpulse-dev libxml2-dev libxslt1-dev \
                python-dev libqt4-dev qt4-dev-tools libcap-dev \
                libxmu-dev mesa-common-dev libglu1-mesa-dev \
                linux-kernel-headers libcurl4-openssl-dev libpam0g-dev \
                libxrandr-dev libxinerama-dev libqt4-opengl-dev makeself \
                libdevmapper-dev default-jdk \
                python3 \
                # python-central \ ## DEPRECATED FOR dh-python (python3)
                texlive-latex-base \
                texlive-latex-extra texlive-latex-recommended \
                texlive-fonts-extra texlive-fonts-recommended \ 
                lib32z1 lib32ncurses5 \
                # ia32-libs \
                libc6-dev-i386 lib32gcc1 gcc-multilib \
                lib32stdc++6 g++-multilib


# # virtualbox sources

ENV VIRTUALBOX_VER 5.0.16

RUN wget -O vb.tar.bz2 http://download.virtualbox.org/virtualbox/${VIRTUALBOX_VER}/VirtualBox-${VIRTUALBOX_VER}.tar.bz2 && tar xjvf vb.tar.bz2

RUN ls -lsA



# # BUILD VIRTUALBOX (from https://www.virtualbox.org/wiki/Linux%20build%20instructions)

# Change to the root directory of the sources and execute the configure script:
# ./configure --disable-hardening
# If it finds everything it needs, it will create a file called 'AutoConfig.kmk' containing paths to the various tools on your system. Also, it will create an environment setup script called env.sh. This step only has to be done once (if something changes in your build tool setup, you might have to repeat it but keep in mind that both output files will be overwritten).
# The switch --disable-hardening should not be used for building packages for redistribution or for production use.

# Whenever you want to build VirtualBox, you have to open a shell and source the generated environment setup script 'env.sh', i.e. do
# source ./env.sh
# To build a release package, type
# kmk all
# This produces the required binaries in out/linux.x86/release/bin/. If you want to build a debug version, type
# kmk BUILD_TYPE=debug
# In case you have more than one CPU core, kmk will automatically do a parallel build.
# Running a hardened build from the bin/ directory will not work because all hardened binaries do explicit link against libraries from /opt/VirtualBox (fixed path).
# Building VirtualBox packages for distribution
# Never disable hardening (see previous section) when creating packages for redistribution.

# To be more LSB-compliant, change the default pathes which are used by the VirtualBox binaries to find their components. Add the following build variables to LocalConfig.kmk:

# VBOX_PATH_APP_PRIVATE_ARCH := /usr/lib/virtualbox
# This is the application's private directory, architecture-dependent.
# VBOX_PATH_SHARED_LIBS := $(VBOX_PATH_APP_PRIVATE_ARCH)
# Where to put the shared libraries, usually the same directory as the private path as the VirtualBox shared libraries are normally not used by any other application.
# VBOX_WITH_ORIGIN :=
# Disable RPATH=$ORIGIN and use a fixed RUNPATH.
# VBOX_WITH_RUNPATH := $(VBOX_PATH_APP_PRIVATE_ARCH)
# Set RUNPATH to the directory where our shared libraries can be found.
# VBOX_PATH_APP_PRIVATE := /usr/share/virtualbox
# This is the applications's private directory, not architecture-dependent.
# VBOX_PATH_APP_DOCS := /usr/share/doc/virtualbox
# Set the directory containing the documentation. The file VirtualBox.chm and UserManual.pdf are searched within this directory.
# VBOX_WITH_TESTCASES :=
# Save compile time by not building the testcases.
# VBOX_WITH_TESTSUITE :=
# Save compile time by not building the testsuite.
# Running your build
# You can run VirtualBox directly from the build target directory (out/linux.x86/release/bin/) if the build was not hardened. But first of all, you must build and install the VirtualBox kernel module, whose sources will have been copied to the build target directory.

# So, issue the following:

# cd out/linux.x86/release/bin/src
# make
# sudo make install
# cd ..
# Then it should have been installed to your modules directory and you can load it using modprobe vboxdrv. Make sure you give yourself read and write access to /dev/vboxdrv.

# Finally, you can start one of the frontends, e.g.

# ./VirtualBox