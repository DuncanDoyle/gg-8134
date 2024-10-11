#!/bin/sh

pushd ..

# Deploy the Gateways

# Gloo Edge API
kubectl apply -f gateways/gateway-proxy.yaml
#K8S Gateway API
kubectl create namespace ingress-gw --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f gateways/gw.yaml

# Create namespaces if they do not yet exist
# kubectl create namespace ingress-gw --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace httpbin --dry-run=client -o yaml | kubectl apply -f -

# Label the default namespace, so the gateway will accept the HTTPRoute from that namespace.
printf "\nLabel default namespace ...\n"
kubectl label namespaces default --overwrite shared-gateway-access="true"

# Deploy the HTTPBin application
printf "\nDeploy HTTPBin application ...\n"
kubectl apply -f apis/httpbin.yaml

# Reference Grants
printf "\nDeploy Reference Grants ...\n"
kubectl apply -f referencegrants/httpbin-ns/default-ns-httproute-service-rg.yaml

# HTTPRoute
printf "\nDeploy HTTPRoutes ...\n"
kubectl apply -f routes/httpbin-httproute.yaml
kubectl apply -f routes/foo-example-com-root-httproute.yaml
kubectl apply -f routes/bar-example-com-root-httproute.yaml

popd