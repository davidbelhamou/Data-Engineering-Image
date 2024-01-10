FROM ubuntu:20.04
LABEL author='David Belhamou'

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
    && apt-get install -y tshark \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && add-apt-repository -r  ppa:deadsnakes/ppa


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

RUN apt-get update
RUN apt install -y openssh-server
RUN apt install -y cron
RUN apt install -y default-jdk
RUN apt install -y vim
RUN apt install -y zip
RUN apt install -y sqlite3


# set default java version
ENV JAVA_HOME /usr/lib/jvm/default-java


COPY custom-motd /etc/motd
RUN chmod +x /etc/motd


# SSH configuration
RUN mkdir -p /run/sshd
RUN echo 'root:root' | chpasswd
RUN mkdir /root/.ssh
COPY environment /etc/

# Remove any existing PrintMotd lines from the sshd_config file
RUN sed -i '/^PrintMotd/d' /etc/ssh/sshd_config
# Add a single PrintMotd yes entry to the sshd_config file
RUN echo "PrintMotd yes" >> /etc/ssh/sshd_config
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PermitUserEnvironment\s+.*/PermitUserEnvironment yes/' /etc/ssh/sshd_config
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]

# Python configuration
RUN ln -s /usr/bin/python3.10 /usr/bin/python
RUN ln -sf /usr/bin/python3.10 /usr/bin/python3

WORKDIR /app
COPY requirements.txt .

# most of the ubuntu have outdated version of pip
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10
RUN pip install -U -r ./requirements.txt
