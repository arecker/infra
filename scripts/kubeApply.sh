#!/usr/bin/env sh
kubectl apply -f kubernetes/ingress.yml
kubectl apply -f kubernetes/vault.yml
kubectl apply -f kubernetes/hub.yml
kubectl apply -f kubernetes/chorebot.yml
