FROM ubuntu:20.04

# Set environment variables
ENV TZ=Asia/Jerusalem
ENV DEBIAN_FRONTEND=noninteractive
ENV NOTVISIBLE "in users profile"

# Add required repositories and install packages
RUN apt-get update \
    && apt-get install -y software-properties-common build-essential \
    && apt-get install -y sudo \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3.10 \
        python3.10-dev \
        python3.10-distutils \
        python3-pip \
        curl \
        wget \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && add-apt-repository -r  ppa:deadsnakes/ppa

# Python configuration
RUN ln -s /usr/bin/python3.10 /usr/bin/python
RUN ln -sf /usr/bin/python3.10 /usr/bin/python3

# Clean the package cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Update package lists
RUN apt-get update

# Install unixodbc-dev and fix broken dependencies
RUN apt-get install -y -f unixodbc-dev

# Add Microsoft repository and install msodbcsql18
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y -f msodbcsql18

WORKDIR /app
COPY requirements.txt .
# most of the ubuntu have outdated version of pip
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10
RUN pip install -r requirements.txt