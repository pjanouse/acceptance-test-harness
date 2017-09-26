#!/bin/bash

set -x

USER="admin"
PASS="changeme"

if [ -z "$1" ] ; then
  FOREMAN_URL="http://localhost:32768/api/v2"
else
  FOREMAN_URL="$1"
fi

if [ -z "$2" ] ; then
  HOSTNAME="localhost"
else
  HOSTNAME="$2"
fi

if [ -z "$3" ] ; then
  HOSTIP="127.0.0.1"
else
  HOSTIP="$3"
fi

if [ -z "$4" ] ; then
  LABEL="label1 aix"
else
  LABEL="$4"
fi

if [ -z "$5" ] ; then
  HOST_ID=1
else
  HOST_ID="$5"
fi

hostCreateString="{ \"host\": { \"name\": \"$HOSTNAME\", \"managed\": false } }"
hostUpdateString="{ \"host\": { \"name\": \"$HOSTNAME\", \"host_parameters_attributes\": [ { \"name\": \"RESERVED\", \"value\": \"false\" } , { \"name\": \"JENKINS_LABEL\", \"value\": \"LABEL\" }, { \"name\": \"JENKINS_SLAVE_REMOTEFS_ROOT\", \"value\": \"/tmp/remoteFSRoot\" }] } }"

echo ""
echo "** Creating host $HOSTNAME"
curl -g -H "Content-Type: application/json" \
    -X POST -d "$hostCreateString" \
    -k -u $USER:$PASS \
    $FOREMAN_URL/hosts

echo ""
echo "** Updating host $HOSTNAME"
curl -g -H "Content-Type: application/json" \
    -X PUT -d "$hostUpdateString" \
    -k -u $USER:$PASS \
    $FOREMAN_URL/hosts/$HOSTNAME

echo ""
echo "** Done"
echo ""
