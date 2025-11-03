#!/bin/bash

sudo mkdir /nauos
sudo mv ./parse.lua /nauos/
sudo apt install luajit
sudo touch /usr/bin/rebuild

sudo chmod +x /usr/bin/rebuild

sudo echo "luajit /nauos/parse.lua" > /usr/bin/rebuild

sudo chmod +x /usr/bin/rebuild
