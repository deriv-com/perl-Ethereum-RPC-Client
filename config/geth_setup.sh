#!/bin/bash

export ETHEREUM_VERSION=1.8.15-89451f7c
export ETHEREUM_URL="https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-$ETHEREUM_VERSION.tar.gz"
export RUNNABLE_FILES=/usr/local
export NODE=geth

mkdir $NODE && wget -qO- $ETHEREUM_URL | tar xvz -C $NODE --strip-components 1
sudo cp $NODE/$NODE /usr/local

($RUNNABLE_FILES/$NODE --dev --datadir="/tmp/.$NODE" --targetgaslimit=7000000 js $TRAVIS_BUILD_DIR/config/geth_script.js)

nohup $($RUNNABLE_FILES/$NODE --dev --datadir="/tmp/.$NODE" --mine --rpc --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3 --targetgaslimit=7000000) &
