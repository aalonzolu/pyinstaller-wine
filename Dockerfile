FROM ubuntu:16.04

# Max 3.6.4
ARG PY_VER=3.6.4
# Max 3.3
ARG PYINSTALLER_VER=3.3

# install winehq and winetrics
RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get install -qfy --no-install-recommends \
        wget software-properties-common  apt-transport-https\
    && wget -nc https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key \
    && apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' \
    && apt-get update && apt-get install -qfy --no-install-recommends \
        winehq-staging \
    && apt-get clean \
    && wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x winetricks \
    && mv winetricks /usr/local/bin

# wine settings
ENV WINEARCH win64
ENV WINEDEBUG -all
ENV WINEPREFIX /wine

# install python3 and pyinstaller
RUN winetricks win7 \
    && wget -A msi -m -p -E -k -K -np \
        "https://www.python.org/ftp/python/${PY_VER}/amd64/" \
    && cd www.python.org/ftp/python/${PY_VER}/amd64/ \
    && ls -1 | xargs -L1 wine msiexec /qb TARGETDIR=C:/Python36 /i \
    && cd / && rm -rf www.python.org \
    && echo 'wine ${WINEPREFIX}/drive_c/Python36/Scripts/pip.exe $@' \
        > pip.sh \
    && bash pip.sh install pyinstaller==$PYINSTALLER_VER \
    && echo 'wine ${WINEPREFIX}/drive_c/Python36/Scripts/pyinstaller.exe $@' \
> pyinstaller.sh
