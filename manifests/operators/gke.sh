#!/bin/bash

# node_ips=$(kubectl get nodes -o json | jq -r ".items[].status.addresses | .[] | select(.type == \"ExternalIP\") | .address")
# node_ips=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}')

domain=${node_ip:?required}.nip.io

cat <<-EOS
- type: replace
  path: /kube/storage_class
  value:
    persistent: standard
    shared: standard
- type: replace
  path: /kube/external_ips
  value: ${node_ips:?required}
- type: replace
  path: /eirini/kube/external_ips
  value: ${node_ips:?required}
- type: replace
  path: /eirini/env/DOMAIN
  value: ${domain}
- type: replace
  path: /env/DOMAIN
  value: ${domain}
- type: replace
  path: /env/UAA_HOST
  value: uaa.${domain}
EOS