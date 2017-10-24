FROM ubuntu:16.04

## Install our dependencies
RUN apt-get update \
    && apt-get -y install \
        build-essential \
        git \
        libxml2-dev \
        libxslt1-dev \
        openssh-client \
        python \
        python-pip \
        python-setuptools \
        python-virtualenv \
        python-wheel \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-virtualenv \
        python3-wheel \
        texlive-fonts-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        texlive-latex-recommended \
        zlib1g-dev \
    && apt-get -y autoremove \
    && apt-get clean

WORKDIR /usr/src/app/readthedocs.org

## Install the python deps
RUN pip install --upgrade setuptools==19.2 pip
COPY readthedocs.org/requirements.txt ./
COPY readthedocs.org/requirements/ ./requirements/
RUN pip install -r requirements.txt

## Import our private key for cloning private repos
RUN mkdir /root/.ssh
RUN chmod 700 /root/.ssh
COPY key/id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
RUN echo "    IdentityFile /root/.ssh/id_rsa" >> /etc/ssh/ssh_config

## Move over our hotfix for Version links
COPY conf.py.tmpl ./readthedocs/doc_builder/templates/doc_builder/conf.py.tmpl

## Make sure we have the right host
RUN echo "0.0.0.0 docs.planfront.net" >> /etc/hosts

## This is a volume for our database
VOLUME ["/persistent"]
CMD ["./entrypoint.sh", "runserver", "0.0.0.0:80"]

RUN echo 'app-git-hash: c6c2824ec789bdfbd5bd25fd7a2921f8f7e6f495' >> /etc/docker-metadata
