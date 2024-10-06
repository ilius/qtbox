#!/bin/bash

set -ev

go install -v -tags=no_env github.com/ilius/qt/cmd/...

OPWD=$PWD
export QT_FAT=true

#TODO: fix QT_FAT for wine
cmd="echo 'REGEDIT4

[HKEY_CURRENT_USER\Environment]
\"QT_FAT\"=\"true\"' > env.reg && regedit env.reg && wineserver -w && qtdeploy -tags=http_interop build windows /media/sf_GOPATH0/src/github.com/ilius/box/full"
docker run --rm -v $(go env GOPATH):/media/sf_GOPATH0 -e GOPATH=/home/user/work:/media/sf_GOPATH0 -i ilius/qt:windows_64_shared_wine bash -c "$cmd" && docker rmi ilius/qt:windows_64_shared_wine
cd $OPWD/full/deploy && zip -9qrXy windows_amd64_513_full_http.zip windows && cd $OPWD && rm -rf $OPWD/full/deploy/windows

$(go env GOPATH)/bin/qtdeploy -docker -tags=http_interop build linux_static full && docker rmi ilius/qt:linux_static
cd $OPWD/full/deploy/linux && zip -9qrXy ../linux_amd64_513_full_http.zip * && cd $OPWD && rm -rf $OPWD/full/deploy/linux

cmd="GOPATH=/home/user/work /home/user/work/bin/qtsetup generate darwin && qtdeploy -tags=http_interop build darwin /media/sf_GOPATH0/src/github.com/ilius/box/full"
cd $(go env GOPATH)/src/github.com/ilius/qt/internal/docker/darwin && ./build_static.sh && cd $OPWD
docker run --rm -v $(go env GOPATH):/media/sf_GOPATH0 -e QT_FAT=true -e GOPATH=/home/user/work:/media/sf_GOPATH0 -i ilius/qt:darwin_static bash -c "$cmd" && docker rmi ilius/qt:darwin_static
cd $OPWD/full/deploy/darwin/full.app/Contents/MacOS && zip -9qrXy ../../../../darwin_amd64_513_full_http.zip * && cd $OPWD && rm -rf $OPWD/full/deploy/darwin

cd ./demo && ./deploy.sh