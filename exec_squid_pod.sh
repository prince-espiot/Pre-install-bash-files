#!/bin/bash

# Ensure the namespace is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NAMESPACE=$1

# Combine the commands
pod_name=$(kubectl get pods -n $NAMESPACE | grep squid | awk '{print $1}') && kubectl exec -it $pod_name -n $NAMESPACE -- /bin/bash
