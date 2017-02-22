#!/bin/bash

##
#
# Runtime execution that needs to run after container launch.
# We basically setup the db for the first time, create our user, and 
#
##
## Collect Variables
DB_LOCATION=${DB_LOCATION:-/persistent/dev.db}

#export DJANGO_SETTINGS_MODULE="readthedocs.settings.sqlite"  # Which settings file should Django use

#export PYTHONPATH=$(pwd):$PYTHONPATH

## We check if this is a fresh install and act appropriately.

NEW_INSTALL=${NEW_INSTALL:-no}
TEST_DATA=${TEST_DATA:-no}


setupdb() {
    # deploy the database
    python ./manage.py migrate

    # create superuser
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python ./manage.py shell

    if [ "$TEST_DATA" == "yes" ]; then
        python ./manage.py loaddata test_data
    fi

}

if [ ! -f "$DB_LOCATION" ]; then
    setupdb
fi

if [ "$NEW_INSTALL" == "yes" ]; then
    rm -rf "$DB_LOCATION"
    setupdb
fi

# collect static (this is always necessary since we never bind mount rtd

echo "yes" | python ./manage.py collectstatic


#exec "gunicorn" "$@"
exec python ./manage.py "$@"
