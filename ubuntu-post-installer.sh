#!/bin/bash

# Definición colores
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

# Instalaciones con apt
printf "${YELLOW}Instalación de paquetes apt${NC}\N" 
packages=(
	build-essential
	g++
	freeglut3-dev
	libx11-dev
	libxmu-dev
	libxi-dev
	libglu1-mesa
	libglu1-mesa-dev
	zlib1g-dev
	libcurl4-gnutls-dev
	libreadline-dev
	libfftw3-dev
	libgsl-dev
	libglm-dev
	git
	htop
	ffmpeg)
sudo apt install ${packages[@]} -y


# Instalación JAVA JDK 11 Oracle
# Hay que desgargar antes el archivo comprimido 
# desde https://www.oracle.com/mx/jaja/technologies/javase-jdk11-downloads.html
# Requiere la autenticación con una cuenta de Oracle, se debe hacer manualmente
#printf "${YELLOW}Instalación de JAVA JDK 11${NC}\N"
#sudo add-apt-repository ppa:linuxuprising/java -y
#sudo mkdir -p /var/cache/oracle-jdk11-installer-local
#sudo cp jdk-11.* /var/cache/oracle-jdk11-installer-local
#sudo apt install oracle-java11-installer-local

printf "${YELLOW}Instalación de JAVA${NC}\N"
sudo apt install -y default-jdk

# Instalación y configuración de Python
printf "${YELLOW}Instalación de PYTHON${NC}\N"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
source $HOME/miniconda3/bin/activate
conda init
conda config --add channels conda-forge
conda install matplotlib matplotlib-base mpl_sample_data

# Instalación y configuración de Julia
printf "${YELLOW}Instalación de JULIA${NC}\N"
wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.3-linux-x86_64.tar.gz
tar -xzf julia-1.* -C $HOME
mv $HOME/julia-1.* $HOME/julia
echo "#**** JULIA PATH ****"
echo "export PATH=${HOME}/julia/bin:${PATH}" >> $HOME/.bashrc

# Instalación de Miktex
# según lo mostrado en https://miktex.org/download
printf "${YELLOW}Instalación de MIKTEX${NC}\N"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889
echo "deb http://miktex.org/download/ubuntu focal universe" | sudo tee /etc/apt/sources.list.d/miktex.list
sudo apt-get update
sudo apt-get install miktex
sudo miktexsetup --shared=yes finish
sudo initexmf --admin --set-config-value [MPM]AutoInstall=1

# Instalación de Asymptote
# requiere compilación
printf "${YELLOW}Compilación e instalación de ASYMPTOTE${NC}\N"
wget https://netactuate.dl.sourceforge.net/project/asymptote/2.70/asymptote-2.70.src.tgz
tar -xzf asymptote-2.* -C $HOME
mv asymptote-2.* asymptote
cd $HOME/asymptote
./configure --prefix=/usr
make -j 8
sudo make install
cd $HOME/Descargas

# Instalación controladores NVIDIA y NVIDIA-CUDA
# REVIZAR DOCUMENTACIÓN DE PASOS A REALIZAR ANTES DE LA INSTALACIÓN
# NO REALIZAR LA INSTALACIÓN SI NO HAY ALGUNA TARJETA GRAFICA NVIDIA
# INSTALADA
# SUPONGO QUE EL SISTEMA ES UNA DISTRIBUCIÓN TIPO UBUNTU LIMPIA
printf "${YELLOW}Instalación de controladores NVIDIA y de NVIDIA-CUDA${NC}\N" 

sudo apt-get install linux-headers-$(uname -r)
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda
export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
sudo /usr/bin/nvidia-persistenced --verbose

#REALIZAR PRUEBA DE COMPILACIÓN AL REINICIAR
printf "${CYAN}Reinicie para activar los drivers y configuración de NVIDIA${NC}\N" 

# Instalación de MATLAB
# Requiere haber antes descargado al .zip de instalación
printf "${YELLOW}Instalación de MATLAB${NC}\N" 
unzip -X -K matlab_* -d matlab
cd matlab
printf "${CYAN}Siga instrucciones de instalación{NC}\N"
xhost +SI:localuser:root
sudo ./install
cd $HOME/Descargas

# Instalación de MATHEMATICA
# Requiere haber antes descargado el script .sh
printf "${YELLOW}Instalación de MATHEMATICA${NC}\N" 
sudo bash Mathematica_*

# Instalación de SPOTIFY
printf "${YELLOW}Instalación de SPOTIFY${NC}\N" 
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y

# Instalación de TELEGRAM
printf "${YELLOW}Instalación de TELEGRAM${NC}\N" 
sudo snap install telegram-desktop

# Instalación de MEGA
printf "${YELLOW}Instalación de MEGA${NC}\N" 
wget https://mega.nz/linux/MEGAsync/xUbuntu_20.04/amd64/megasync-xUbuntu_20.04_amd64.deb
sudo apt install -y ./mega* 
wget https://mega.nz/linux/MEGAsync/xUbuntu_20.04/amd64/dolphin-megasync-xUbuntu_20.04_amd64.deb
sudo apt install -y ./dolphin* 


# Instalación SOFTMAKER
printf "${YELLOW}Instalación de SOFTMAKER${NC}\N" 
wget https://www.softmaker.net/down/softmaker-office-2021_1030-01_amd64.deb
sudo apt install -f ./softmaker-office*
sudo /usr/share/office2021/add_apt_repo.sh

# Instalación de VSCODE
sudo apt install -y software-properties-common apt-transport-https
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code

# Instalación de OTRO SOFTWARE
sudo apt install gimp inkscape thunderbird-locale-es 
sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update
sudo apt-get install papirus-icon-theme





