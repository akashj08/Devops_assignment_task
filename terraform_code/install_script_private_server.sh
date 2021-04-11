#!/bin/bash
#scrpit run
#install docker 
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker ${USER}
