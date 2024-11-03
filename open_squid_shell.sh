# Set the namespace variable
namespace="nroc"

# Get the pod name running the squid container in the nroc namespace
pod_name=$(kubectl get pods -n $namespace | grep squid | awk '{print $1}')

# Check if the pod name was found
if [ -z "$pod_name" ]; then
  echo "No pod found running the squid container in the $namespace namespace."
  exit 1
fi

# Open a shell into the pod
kubectl exec -it $pod_name -n $namespace -- /bin/bash
