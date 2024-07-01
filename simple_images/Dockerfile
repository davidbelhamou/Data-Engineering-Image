FROM python:3.10-alpine

# Install dependencies
RUN apk update && apk add --no-cache \
    curl \
    wget \
    vim \
    bash \
    tar \
    gzip \
    mongodb-tools \
    && wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz \
    && tar -xvf openshift-client-linux.tar.gz -C /usr/local/bin/ \
    && rm openshift-client-linux.tar.gz \
    && chmod +x /usr/local/bin/oc

# Copy the current directory contents into the container
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
