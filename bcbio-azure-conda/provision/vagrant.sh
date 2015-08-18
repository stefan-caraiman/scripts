#!/bin/bash
set -e

echo "Update the system."
sudo apt-get update -y &> /dev/null
sudo apt-get upgrade -y &> /dev/null
echo "Done."

echo "Installing required packages."
sudo apt-get install -y git &> /dev/null
sudo apt-get install -y libatlas-dev libatlas-base-dev &> /dev/null
sudo apt-get install -y liblapack-dev gfortran &> /dev/null
echo "Done."

echo "Installing azure client."
sudo apt-get install -y nodejs-legacy npm &> /dev/null
sudo npm install -gq azure-cli &> /dev/null
echo "Done."

echo "Installing miniconda"
cd $HOME
wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -O miniconda.sh &> /dev/null
chmod +x miniconda.sh
bash miniconda.sh -b -p "$HOME/miniconda" &> /dev/null
PATH="$HOME/miniconda/bin:$PATH"
echo "Done."

echo "Adding miniconda in PATH"
echo 'PATH="$HOME/miniconda/bin:$PATH"' >> "$HOME/.bashrc"
echo "Done"

echo "Updating conda"
conda update --yes --quiet conda &> /dev/null
echo "Done."

echo "Installing additional conda packages."
conda install --yes --quiet jinja2 toolz binstar &> /dev/null
conda install --yes --quiet pep8 pylint	&> /dev/null
echo "Done."

echo "Adding conda channels"
conda config --add channels "$DEV_CHANNEL" &> /dev/null
conda config --add channels "$STABLE_CHANNEL" &> /dev/null
echo "Done."
