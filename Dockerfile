FROM ubuntu:18.04

MAINTAINER Audris Mockus <audris@mockus.org>

USER root


RUN apt-get update && apt install -y  gnupg apt-transport-https


RUN apt-get update && \
    apt-get install -y \
    locales \
	 libzmq3-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libopenblas-base \
    openssh-server \
    lsof sudo \
    fonts-dejavu \
    vim \
    git \
	 curl lsb-release \
    vim-runtime tmux  zsh zip build-essential \
	 r-base-core \
    r-recommended \
    r-base-dev \
	 r-cran-car \
	 r-cran-rcolorbrewer \
	 r-cran-fastcluster 
	 
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen


RUN pip3 install --upgrade pip
RUN pip3 install requests gensim 

RUN echo "install.packages(c('RecordLinkage','devtools'), repos='https://mirror.las.iastate.edu/CRAN')" | R --vanilla
RUN echo 'devtools::install_github("igraph/rigraph")' | R --vanilla 



ENV LC_ALL=C


ENV NB_USER alfaa
ENV NB_UID 1000
ENV HOME /home/$NB_USER
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && mkdir $HOME/.ssh && chown -R $NB_USER:users $HOME 

