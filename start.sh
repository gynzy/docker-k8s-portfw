#!/bin/bash

if [ -z "$GCE_JSON" ]; then
    echo "You need to set the environment variable GCE_JSON."
    exit 1;
fi

if [ -z "$GKE_CLUSTER_NAME" ]; then
    echo "You need to set the environment variable GKE_CLUSTER_NAME."
    exit 1;
fi

if [ -z "$NODE_NAME_SEARCH" ]; then
    echo "You need to set the environment variable POD_NAME_SEARCH."
    exit 1;
fi

if [ -z "$LOCAL_PORT" ]; then
    echo "You need to set the environment variable LOCAL_PORT."
    exit 1;
fi

if [ -z "$REMOTE_PORT" ]; then
    echo "You need to set the environment variable REMOTE_PORT."
    exit 1;
fi

if [ -z "$GCE_ZONE" ]; then
    echo "You need to set the environment variable GCE_ZONE."
    exit 1;
fi

if [ -z "$GCE_PROJECT" ]; then
    echo "You need to set the environment variable GCE_PROJECT."
    exit 1;
fi

echo $GCE_JSON > /gce.json

echo "Preparing GCE credentials..."
gcloud auth activate-service-account --key-file=/gce.json --project=$GCE_PROJECT
gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $GCE_ZONE
export GOOGLE_APPLICATION_CREDENTIALS=/gce.json

echo "Retrieving node name containing: $NODE_NAME_SEARCH"
nodeName=$(kubectl get nodes | grep $NODE_NAME_SEARCH | head -1 | cut -d " " -f1)
echo "Found: $nodeName"
echo "Forwading port $REMOTE_PORT from $nodeName to 0.0.0.0:$LOCAL_PORT"
gcloud compute ssh --ssh-flag="-L 0.0.0.0:$LOCAL_PORT:127.0.0.1:$REMOTE_PORT" --zone $GCE_ZONE $nodeName
