#!/bin/bash

helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update istio

kubectl label namespace default istio-injection=enabled --overwrite=true
kubectl create namespace "istio-system" --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install istio-base istio/base \
  --atomic \
  --namespace istio-system

helm upgrade --install istiod istio/istiod \
  --atomic \
  --namespace istio-system

helm upgrade --install istio-ingressgateway istio/gateway \
  --atomic \
  --namespace istio-system

kubectl create namespace "istio-ingress" --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace istio-ingress istio-injection=enabled --overwrite=true
kubectl label namespace istio-ingress opa-istio-injection="enabled" --overwrite=true

kubectl apply --namespace=istio-ingress -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply --namespace=istio-ingress -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/bookinfo/networking/bookinfo-gateway.yaml

kubectl wait --namespace=istio-ingress -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl wait --namespace=istio-ingress -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/bookinfo/networking/bookinfo-gateway.yaml

INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_HOST

INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export INGRESS_PORT

export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
