FROM python:3.10-alpine
LABEL author='David Belhamou'

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NOTVISIBLE "in users profile"

# Install necessary packages and build tools
RUN apk update && apk add --no-cache \
    sudo \
    openssh-server \
    openjdk11-jdk \
    zip \
    sqlite \
    curl \
    wget \
    vim \
    bash \
    tar \
    gzip \
    gnupg \
    gcc \
    g++ \
    make \
    libffi-dev \
    openssl-dev \
    musl-dev \
    linux-headers

# Install MongoDB tools
RUN apk add --no-cache mongodb-tools

# SSH configuration
RUN mkdir -p /run/sshd && \
    echo 'root:root' | chpasswd && \
    mkdir /root/.ssh && \
    sed -i '/^PrintMotd/d' /etc/ssh/sshd_config && \
    echo "PrintMotd yes" >> /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitUserEnvironment.*/PermitUserEnvironment yes/' /etc/ssh/sshd_config

# Copy and configure MOTD
COPY custom-motd /etc/motd
RUN chmod +x /etc/motd

# Environment variable configuration
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose SSH port
EXPOSE 22

# Set the default command to run SSH
CMD ["/usr/sbin/sshd", "-D"]

# Set working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
