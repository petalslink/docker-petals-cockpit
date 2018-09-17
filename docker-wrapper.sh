#!/bin/sh

# Migrate DB
java -jar lib/petals-cockpit-*-capsule.jar db migrate conf/config.yml

# Get user from default and/or arguments and add it to DB
cp_user="admin"
cp_name="admin"
cp_pass="admin"

[ ! -z "${COCKPIT_USERNAME+x}" ] && cp_user="$COCKPIT_USERNAME"
[ ! -z "${COCKPIT_NAME+x}" ] && cp_name="$COCKPIT_NAME"
[ ! -z "${COCKPIT_PASS+x}" ] && cp_pass="$COCKPIT_PASS"

if [ ! -z "${COCKPIT_WORKSPACE+x}" ]
then
  java -jar lib/petals-cockpit-*-capsule.jar add-user -u $cp_user -n $cp_name -p $cp_pass -w $COCKPIT_WORKSPACE -a conf/config.yml
else 
  java -jar lib/petals-cockpit-*-capsule.jar add-user -u $cp_user -n $cp_name -p $cp_pass -a conf/config.yml
fi

# Launch Petals-cockpit
/opt/petals-cockpit/petals-cockpit.sh
