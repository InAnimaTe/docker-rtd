FROM python:2.7

## Install our dependencies
RUN apt-get update \
    && apt-get -y install \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        openssh-client \
        build-essential \
        texlive-latex-base \
        texlive-latex-extra \
        texlive-latex-recommended \
        texlive-fonts-recommended \
        python3 \
    && apt-get -y autoremove \
    && apt-get clean

WORKDIR /usr/src/app/readthedocs.org

## Install the python deps
RUN pip install setuptools==19.2
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

## This is a volume for our database
VOLUME ["/persistent"]
CMD ["./entrypoint.sh", "runserver", "0.0.0.0:80"]
