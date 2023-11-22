FROM ubuntu:20.04

ENV DEBIAN_FRONTED=noninteractive
ENV TZ=America/New_York

COPY install /workspace/install
RUN bash /workspace/install/apt_installs.sh

# pip installs
RUN pip install --upgrade pip setuptools wheel
RUN pip install -U -r /workspace/install/requirements.txt

RUN bash /workspace/install/install_odbc.sh

RUN ln -s /usr/bin/python3.8 /usr/bin/python

# install hadoop
RUN bash /workspace/install/install_hadoop.sh
# Set Hadoop environment variables
ENV HADOOP_HOME=/usr/local/hadoop
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
ENV PATH=$PATH:$HADOOP_HOME/bin

# set default java version
ENV JAVA_HOME /usr/lib/jvm/default-java

COPY install/custom-motd /etc/motd
RUN chmod +x /etc/motd

# config jupyter notebook
RUN bash /workspace/install/configure_jupyter.sh

RUN chmod +x /workspace/install/entrypoint.sh
ENTRYPOINT ["/workspace/install/entrypoint.sh"]
CMD ["10"]

