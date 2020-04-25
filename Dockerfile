FROM ubuntu:18.04

# Set up mirrors
RUN apt-get update \
    &&  apt-get install -y \
    lsb-release \
    gnupg \
    && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) \
    main" > /etc/apt/sources.list.d/ros-latest.list' \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key \
    C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Install required packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    python3-pip \
    ros-melodic-desktop-full \
    ros-melodic-openni* \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    bluez-hcidump \
    libbluetooth-dev \
    &&  pip3 install git+https://github.com/alvaroferran/Alpha1S.git

# Set up OpenNI driver
WORKDIR /root
RUN wget -O nite.tar.bz2 \
    "https://bitbucket.org/kaorun55/openni-1.5.2.23-unstable/raw/526703f543a59daecd760fcc312fc75723b1d194/Linux_64bit/nite-bin-linux-x64-v1.5.2.21.tar.bz2" \
    &&  tar -xvjf nite.tar.bz2 \
    &&  rm nite.tar.bz2 \
    &&  cd NITE-Bin-Dev-Linux-x64-v1.5.2.21/ \
    &&  ./install.sh

# Install OpenNI tracker
RUN mkdir -p catkin_ws/src/alpha1s_kinect \
    && cd catkin_ws/src/ \
    && git clone https://github.com/ros-drivers/openni_tracker.git

# Add alpha1s_kinect package
COPY alpha1s_kinect/ /root/catkin_ws/src/alpha1s_kinect

# Build and make source persistent
WORKDIR /root/catkin_ws
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_make" \
    && echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc \
    && echo "source ~/catkin_ws/devel/setup.bash" >> /root/.bashrc
