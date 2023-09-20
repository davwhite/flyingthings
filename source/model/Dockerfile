FROM quay.io/centos/centos:stream9

WORKDIR /opt/app-root/src
ARG YOLOv5_VERSION=7.0

RUN dnf install -y git wget libGL python3-pip \
 && dnf clean all

RUN mkdir -p /usr/local/lib/python3.9/site-packages \
 && cd /usr/local/lib/python3.9/site-packages \
 && git clone --branch v${YOLOv5_VERSION} --depth 1 https://github.com/ultralytics/yolov5.git \
 && pip install --no-cache-dir \
    -r /usr/local/lib/python3.9/site-packages/yolov5/requirements.txt \
 && rm -rf /usr/local/lib/python3.9/site-packages/yolov5/.git

WORKDIR /workspace

COPY source/yolo/requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt

USER 0
WORKDIR /opt/app-root/src

ENV WEIGHTS=flyingthings.pt
ENV BUILD_VER=0.0
ENV MODEL_CLASSES=flyingthings.yaml
ENV SIMPLEVIS_DATA=/opt/app-root/src/simplevis-data
ENV BASEDIR=/opt/app-root/src
ENV MINIO_ENDPOINT=http://minio:9000
ENV MINIO_BUCKET=flyingthings
ENV MINIO_ACCESSKEY=minioadmin
ENV MINIO_SECRETKEY=minioadmin
ENV MINIO_CLIENT_URL=https://dl.min.io/client/mc/release/linux-amd64

RUN dnf install -y git wget libGL python3-pip \
 && dnf clean all

RUN mkdir -p $SIMPLEVIS_DATA \
 && chown -R 1001:1001 $SIMPLEVIS_DATA

WORKDIR /opt/app-root/src/

COPY source/model/requirements.txt ./
COPY source/model/get-model.sh ./
RUN pip install --no-cache-dir -r ./requirements.txt

COPY source/model/app/ ./

WORKDIR /opt/app-root/src

USER 1001
EXPOSE 8000

CMD ["/opt/app-root/src/get-model.sh"]
