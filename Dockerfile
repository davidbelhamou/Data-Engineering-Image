#Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04


# Set the environment variable to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y software-properties-common build-essential \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 python3-pip curl wget\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update
RUN apt install -y unixodbc-dev

# Download and install the Microsoft ODBC Driver 18 for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18


COPY install /workspace/install
RUN bash /workspace/install/apt_installs.sh

# pip installs
RUN pip install --upgrade pip setuptools wheel
RUN pip install -U -r /workspace/install/requirements_000.txt
RUN pip install -U -r /workspace/install/requirements_001.txt
RUN pip install -U -r /workspace/install/requirements_002.txt
RUN pip install -U -r /workspace/install/requirements_003.txt

RUN bash /workspace/install/install_odbc.sh

RUN ln -s /usr/bin/python3.8 /usr/bin/python

## install hadoop
#RUN bash /workspace/install/install_hadoop.sh
## Set Hadoop environment variables
#ENV HADOOP_HOME=/usr/local/hadoop
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
#ENV PATH=$PATH:$HADOOP_HOME/bin

# set default java version
ENV JAVA_HOME /usr/lib/jvm/default-java

COPY install/custom-motd /etc/motd
RUN chmod +x /etc/motd

# config jupyter notebook
RUN bash /workspace/install/configure_jupyter.sh

RUN chmod +x /workspace/install/entrypoint.sh
ENTRYPOINT ["/workspace/install/entrypoint.sh"]
CMD ["10"]

