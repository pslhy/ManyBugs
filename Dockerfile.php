FROM ubuntu:14.04

# Create docker user
RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo && \
    useradd -ms /bin/bash docker && \
    echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    adduser docker sudo && \
    apt-get clean && \
    mkdir -p /home/docker && \
    sudo chown -R docker /home/docker && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER docker

# reclaim ownership of /usr/local/bin
RUN sudo chown -R docker /usr/local/bin

# install basic packages
RUN sudo apt-get update && \
    sudo apt-get install  --no-install-recommends -y \
                          build-essential \
                          gcc \
                          patch \
                          curl \
                          libcap-dev \
                          git \
                          cmake \
                          vim \
                          jq \
                          tar \
                          psmisc \
                          moreutils \
                          wget \
                          zip \
                          unzip \
                          python3-setuptools \
                          python \
                          software-properties-common \
                          gcovr \
                          libncurses5-dev && \
    sudo apt-get autoremove -y && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Fix /bin/sh to point to /bin/bash
RUN sudo rm /bin/sh && \
    sudo ln -s /bin/bash /bin/sh

# install Bear
RUN cd /tmp \
 && wget https://github.com/rizsotto/Bear/archive/2.3.13.tar.gz \
 && tar -xf 2.3.13.tar.gz \
 && cd Bear-2.3.13 \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && sudo make install \
 && rm -rf /tmp/*

# Create the experiment directory and set it as the work dir
RUN sudo mkdir -p /experiment && sudo chown -R docker /experiment
WORKDIR /experiment

# install Euphony
RUN git clone https://github.com/wslee/euphony.git \
 && cd euphony \
 && ./build \
 && . bin/setenv \
 && cd ..

# install inv_repair
RUN mkdir invrepair
COPY invrepair.zip /experiment/invrepair.zip
RUN unzip /experiment/invrepair.zip -d /experiment/invrepair && \
    rm /experiment/invrepair.zip && \
    rm -rf /experiment/invrepair/__MACOSX
RUN sudo chmod +x /experiment/invrepair/*.sh

# add some shell files
COPY start.sh /experiment/start.sh
COPY set_preprocess.sh /experiment/set_preprocess.sh
COPY auto_ptest.sh /experiment/auto_ptest.sh

# add generic preprocessing script
COPY base/preprocess /experiment/preprocess

COPY compile.sh /experiment/compile.sh
RUN sudo chown -R docker /experiment && \
    sudo chmod +x compile.sh
