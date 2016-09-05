#!/bin/bash

if [ -z "$GCE_JSON" ]; then
    echo "You need to set the environment variable GCE_JSON."
    exit 1;
fi

if [ -z "$GKE_CLUSTER_NAME" ]; then
    echo "You need to set the environment variable GKE_CLUSTER_NAME."
    exit 1;
fi

if [ -z "$POD_NAME_SEARCH" ]; then
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

echo $GCE_JSON > /gce.json

echo "Preparing GCE credentials..."
gcloud auth activate-service-account --key-file=/gce.json --project=unicorn-985
gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone europe-west1-c
export GOOGLE_APPLICATION_CREDENTIALS=/gce.json

echo "Retrieving pod name containing: $POD_NAME_SEARCH"
podName=$(kubectl get pods | grep $POD_NAME_SEARCH | cut -d " " -f1 | xargs)
echo "Found: $podName"
echo "Forwading port $REMOTE_PORT from $podName to localhost:$LOCAL_PORT"

kubectl port-forward $podName $LOCAL_PORT:$REMOTE_PORT
