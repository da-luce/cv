FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    imagemagick \
    texlive-latex-base \
    texlive-latex-extra \
    git \
    awscli \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install cvlint
RUN git clone https://github.com/da-luce/cvlint.git
WORKDIR /cvlint
RUN pip install .
