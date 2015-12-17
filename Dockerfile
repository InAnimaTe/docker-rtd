FROM python:2.7-onbuild

# 1) COPY requirements.txt
# 2) Run pip install on ^
# 3) COPY . /usr/src/app

ENV GUNICORN_VERSION 19.3.0

## Install our dependencies

RUN apt-get update && \
    apt-get -y install libxml2-dev libxslt1-dev zlib1g-dev build-essential && \
    pip install gunicorn==${GUNICORN_VERSION} && \
    apt-get -y autoremove && \
    apt-get clean

## Apply our own overrides
#COPY local_settings.py /usr/src/app/readthedocs.org/readthedocs/settings/local_settings.py

RUN cp ./local_settings.py readthedocs.org/readthedocs/settings/local_settings.py

## Import our private key for cloning private repos
#RUN mkdir /root/.ssh
#RUN chmod 700 /root/.ssh
#COPY key/id_rsa /root/.ssh/id_rsa


## This is a volume for our database
VOLUME ["/persistent"]

ENTRYPOINT ["./entrypoint.sh"]
## Some defaults to pass to gunicorn/entrypoint
CMD ["-b", "0.0.0.0:80", "-w", "2", "readthedocs.wsgi:application"]
