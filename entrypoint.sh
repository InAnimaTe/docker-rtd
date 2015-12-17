#!/bin/bash

##
#
# Runtime execution that needs to run after container launch.
# We basically setup the db for the first time, create our user, and 
#
##

## Lets cd into the readthedocs checkout

cd readthedocs.org

## Collect Variables

RTD_PRODUCTION_DOMAIN=${RTD_PRODUCTION_DOMAIN:-localhost:80}

export DJANGO_SETTINGS_MODULE="readthedocs.settings.sqlite"  # Which settings file should Django use

export PYTHONPATH=$(pwd):$PYTHONPATH

## We check if this is a fresh install and act appropriately.

NEW_INSTALL=${NEW_INSTALL:-no}
TEST_DATA=${TEST_DATA:-no}

if [ "$NEW_INSTALL" == "yes" ]; then

	# Deploy the database
	python ./manage.py migrate

	# Create a super user
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python ./manage.py shell

	if [ "$TEST_DATA" == "yes" ]; then
		# Load test data
		python ./manage.py loaddata test_data
	fi

	# Copy static files
	#python ./manage.py collectstatic --noinput

fi

#exec "gunicorn" "$@"
exec python ./manage.py runserver 0.0.0.0:80
