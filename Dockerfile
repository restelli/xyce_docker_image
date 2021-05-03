FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND="noninteractive" && \
export TZ="America/New_York" && \
apt-get update -y && \
apt-get install -y apt-utils &&\
apt-get install -y sudo && \
apt-get install -y ksh && \
apt-get install -y csh && \
apt-get install -y gzip && \
apt-get install -y wget && \
apt-get install -y bzip2 && \
apt-get install -y net-tools && \
apt-get install -y iproute2 && \
echo "Installing all requirements for Trilinos and Xyce" && \
apt-get install -y git && \
apt-get install -y gcc && \
apt-get install -y g++ && \
apt-get install -y gfortran && \
apt-get install -y make && \
apt-get install -y cmake && \
apt-get install -y bison && \
apt-get install -y flex && \
apt-get install -y libfl-dev && \
apt-get install -y libfftw3-dev && \
apt-get install -y libsuitesparse-dev && \
apt-get install -y libblas-dev && \
apt-get install -y liblapack-dev && \
apt-get install -y libtool && \
apt-get install -y autoconf && \
apt-get install -y automake && \
echo "Installing all additional requirements for ADMS" && \
# apt-get install -y automake flex bison && \
apt-get install -y build-essential && \
apt-get install -y libtool gperf && \
apt-get install -y libxml2 libxml2-dev && \
apt-get install -y libxml-libxml-perl && \
apt-get install -y libgd-perl && \
echo "Getting rid of unnecessary files" && \
rm -rf /tmp/* /usr/share/doc/* /usr/share/info/* /var/tmp/*


RUN echo "Setting up a user called xyce to avoid running the container as root" && \
echo "For convenience xyce will be a passwordless sudo user on the container" && \
useradd -d /home/xyce -s /bin/bash -m xyce && \
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >>  /etc/sudoers && \
usermod -aG sudo xyce


ADD build_scripts/config_xyce /home/xyce/build_xyce/config_xyce
ADD build_scripts/config_trilinos /home/xyce/build_trilinos/config_trilinos
ADD initialize /home/xyce/.initialize

RUN cd /home/xyce && \
git clone -b Release-7.2.0 https://github.com/Xyce/Xyce.git && \
git clone -b trilinos-release-12-12-1 https://github.com/trilinos/Trilinos.git

RUN echo "First we need to build Trilinos" && \
cd /home/xyce/build_trilinos && \
chmod +x config_trilinos && \
./config_trilinos  && \
make && \
make install

RUN echo "Now we can compile Xyce" && \
cd /home/xyce/Xyce && \
./bootstrap && \
cd /home/xyce/build_xyce && \
chmod u+x config_xyce && \
./config_xyce && \
make && \
make install


RUN echo "Compiling ADMS to be able to integrate the verilog-A modules in Xyce"
cd /home/xyce && \
git clone -b release-2.3.6 https://github.com/Qucs/ADMS.git && \
cd ADMS && \
sh bootstrap.sh && \
./configure --enable-maintainer-mode && \
make install




USER xyce

ENV PATH $PATH:/home/xyce/Xyce_7.2/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib
ENV DISPLAY ':1'
ENV HOME /home/xyce
CMD /bin/bash -ci "cd;source ./.initialize"
