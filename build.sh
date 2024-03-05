#!/bin/bash -eux

if [ ! -d "env" ]; then
  python3 -m venv env
  pip install --upgrade pip
  pip install -r ./requirements-dev.txt
  pip install -r ./requirements-release.txt
  pip install -r ./requirements-lintrunner.txt
fi

source env/bin/activate

INSTALL_PROTOBUF_PATH="$(pwd)/protobuf_install"

if [ ! -d "$INSTALL_PROTOBUF_PATH" ]; then
  (
    mkdir -p $INSTALL_PROTOBUF_PATH
    cd $INSTALL_PROTOBUF_PATH
    source "$(pwd)/../workflow_scripts/protobuf/build_protobuf_unix.sh" "$(nproc)" "$(pwd)" Release
  )
fi

export PATH=$INSTALL_PROTOBUF_PATH/include:$INSTALL_PROTOBUF_PATH/lib:$INSTALL_PROTOBUF_PATH/bin:$PATH

pip install -e . -vvv
