#!/bin/bash
#scrpit run
#install docker 
sudo apt update
sudo apt install docker.io
sudo usermod -aG docker ${USER}
