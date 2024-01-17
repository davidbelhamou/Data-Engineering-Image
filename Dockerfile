FROM python:alpine3.18
LABEL author='David Belhamou'


# Add required repositories and install packages
RUN apk update \
    && apk add --no-cache sudo tshark



EXPOSE 80

WORKDIR /app

COPY requirements.txt .
# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN rm /app/requirements.txt

CMD ["tail", "-f", "/dev/null"]
