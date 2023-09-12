#!/bin/bash

if [ $# -eq 0 ]; then
    echo Warning: No project provided. Please provide a target project.
    exit 1
fi

# Assign the first argument to the TABLESPACE variable
TABLESPACE=$1

oc project $1

# Execute your code here using the TABLESPACE variable
# Hosted Copy  -p MINIO_CLIENT_URL="https://dl.min.io/client/mc/release/linux-amd64" \
# Local Copy  -p MINIO_CLIENT_URL="http://util02.davenet.local" \
# -p git-url="https://github.com/redhat-na-ssa/flyingthings.git" \
echo "Deploying project to $TABLESPACE"
tkn pipeline start flyingthings-images-pipeline \
  -w name=source,volumeClaimTemplateFile=code-pvc.yaml \
  -w name=shared-workspace,volumeClaimTemplateFile=work-pvc.yaml \
  -p git-url="https://github.com/davwhite/flyingthings.git" \
  -p git-revision="main" \
  -p YOLO_IMAGE="image-registry.openshift-image-registry.svc:5000/$TABLESPACE/yolo:latest" \
  -p UBI_IMAGE="image-registry.openshift-image-registry.svc:5000/$TABLESPACE/base-ubi9:latest" \
  -p MINIMAL_IMAGE="image-registry.openshift-image-registry.svc:5000/$TABLESPACE/minimal-notebook:latest" \
  -p CUSTOM_NOTEBOOK_IMAGE="image-registry.openshift-image-registry.svc:5000/$TABLESPACE/yolo-notebook:latest" \
  -p MODEL_IMAGE="image-registry.openshift-image-registry.svc:5000/$TABLESPACE/custom-model:latest" \
  -p BASE_MODEL="yolov5s.pt" \
  -p MINIMAL_BUILD_ARGS="--build-arg BASE_IMAGE=image-registry.openshift-image-registry.svc:5000/$TABLESPACE/base-ubi9:latest" \
  -p MODEL_BUILD_ARGS="--build-arg WEIGHTS=flyingthings.pt --build-arg BASE_IMAGE=image-registry.openshift-image-registry.svc:5000/$TABLESPACE/yolo:latest" \
  -p CUSTOM_BUILD_ARGS="--build-arg BASE_IMAGE=image-registry.openshift-image-registry.svc:5000/$TABLESPACE/minimal-notebook:latest" \
  -p MINIO_BUCKET="flyingthings" \
  -p PRETRAINED_BUCKET="yolo" \
  -p MINIO_ACCESSKEY="minioadmin" \
  -p MINIO_SECRETKEY="minioadmin" \
  -p MINIO_CLIENT_URL="https://dl.min.io/client/mc/release/linux-amd64" \
  -p ocp-tablespace="$TABLESPACE" \
  -p DEPLOY_LABELSTUDIO="Y" \
  --use-param-defaults --showlog

# Exit the script gracefully
exit 0
