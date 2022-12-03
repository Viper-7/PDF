# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive
ENV TZ=Australia/Sydney
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
run apt-get update
RUN apt-get install -y tzdata keyboard-configuration

# Install Python, pip, and the necessary packages to build Python packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    libffi-dev \
    libssl-dev \
    wget \
    xvfb \
    xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic \
    wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/*

# Install the latest versions of Selenium, Flask, Gunicorn, and PhantomJS using pip
RUN pip3 install selenium==3.8.0 flask gunicorn 


COPY ./app/ /app

WORKDIR /app

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]

