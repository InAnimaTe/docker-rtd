This repo should contain most of what you need in order to get a local
ReadTheDocs instance up and running.

### Getting up and Running
 - You'll need to install [Docker](https://docs.docker.com/engine/installation/)
   and [Docker Compose](https://docs.docker.com/compose/install/).
 - Clone this repository
 - Inside of the repository folder, create a `key` folder, and inside place a
   private key (`id_rsa`, NOT `id_rsa.pub`) that your Docker instance will use
   to access your private repositories. You may want to set up a new github
   account, or at, at the minimum, create a new private key for this.
   Alternatively, you can also bind-mount in your key to `/root/.ssh/id_rsa`
   and pull the image `docker pull inanimate/rtd` instead of bulding yourself.
 - Setup the local_settings.py file. You're welcome to copy the example file
   and just bind-mount it inside the container!
   There are a ton knobs that can you tune, so you may want to take a moment to
   familiarize yourself with them.
 - Edit the docker-compose file. The only value that requires changing is the
   `RTD_PRODUCTION_DOMAIN` environment variable. It should match the domain that
   you're hosting RTD on. e.g. if you're hosting your docs at 
   http://docs.my-app.net, then you should set it to `docs.my-app.net`. It is 
   recommended to leave `TEST_DATA=yes` on first run as it will set things up
   for you, and populate your install with some test projects you can use to
   verify the validity of the installation.
 - From this directory, launch RTD using docker-compose: `docker-compose up -d`.
   `up` reads the docker-compose file and will build the necessary images. 
   `-d` starts the instance in detached mode (so you don't need to leave the tty
   open).

And that's it! Docker will automatically restart the service should it crash or
if the machine goes reboots.
