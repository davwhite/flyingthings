#!/bin/bash
cd ../source
oc project flyingthings-standalone
oc delete -k notebook
oc delete -k minio
oc delete cm flyingthings-configmap