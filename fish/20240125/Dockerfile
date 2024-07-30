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
    sqlite3 \
    vim \
    bash \
    tar \
    gzip \
    gnupg \
    gcc \
    g++ \
    make \
    libffi-dev \
    libssl-dev \
    openssl-dev \
    musl-dev \
    linux-headers \
    mongodb-tools

# Install PostgreSQL client tools
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

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

# Install MongoDB CLI tools (mongodump, mongorestore, etc.)
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list && \
    apt-get update && \
    apt-get install -y mongodb-org-tools && \
    rm -rf /var/lib/apt/lists/*

# SSH configuration
RUN mkdir -p /run/sshd && \
    echo 'root:root' | chpasswd && \
    mkdir /root/.ssh && \
    sed -i '/^PrintMotd/d' /etc/ssh/sshd_config && \
    echo "PrintMotd yes" >> /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitUserEnvironment.*/PermitUserEnvironment yes/' /etc/ssh/sshd_config

# Install OpenShift CLI
RUN curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz && \
    tar -xvzf oc.tar.gz && \
    mv oc /usr/local/bin/oc && \
    rm -f oc.tar.gz

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
