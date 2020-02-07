#!/bin/bash

PACKAGE="alpha1s_kinect"

# Install required packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y ros-melodic-desktop-full
# Alpha1s
sudo apt install -y python3-pip
sudo apt install -y bluez-hcidump libbluetooth-dev
pip3 install git+https://github.com/alvaroferran/Alpha1S.git
# Kinect
sudo apt install -y ros-melodic-openni* wget
wget https://bitbucket.org/kaorun55/openni-1.5.2.23-unstable/raw/526703f543a59daecd760fcc312fc75723b1d194/Linux_64bit/nite-bin-linux-x64-v1.5.2.21.tar.bz2
tar -xvjf nite-bin-linux-x64-v1.5.2.21.tar.bz2
rm nite-bin-linux-x64-v1.5.2.21.tar.bz2
mv NITE-Bin-Dev-Linux-x64-v1.5.2.21/ NITE/
cd NITE/
./install.sh
cd ../
# Clean up
sudo apt autoremove -y

# Create catkin workspace
mkdir -p catkin_ws/src
cd catkin_ws/
catkin_make

# Create package
cd src/
catkin_create_pkg "$PACKAGE" std_msgs rospy roscpp
cp -r ../../src/ "$PACKAGE"

# Get openni_tracker
git clone https://github.com/ros-drivers/openni_tracker.git
cd ../
catkin_make

# Make source persistent
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
