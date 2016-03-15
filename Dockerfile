FROM debian:8.3
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
                libdevmapper-dev default-jdk python-central \
                texlive-latex-base \
                texlive-latex-extra texlive-latex-recommended \
                texlive-fonts-extra texlive-fonts-recommended \ 
                lib32z1 lib32ncurses5 \
                # ia32-libs \
                libc6-dev-i386 lib32gcc1 gcc-multilib \
                lib32stdc++6 g++-multilib


# # virtualbox sources

ENV VIRTUALBOX_VER 5.0.16

RUN wget http://download.virtualbox.org/virtualbox/${VIRTUALBOX_VER}/VirtualBox-${VIRTUALBOX_VER}.tar.bz2 | tar xjvf && ls -lsA

