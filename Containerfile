FROM registry.access.redhat.com/ubi9/toolbox@sha256:7391628396216c011ed3a310f1fa54c6a9221e36f7fa59c94ae7796de51e7a25 AS builder

WORKDIR /tmp

RUN curl -sL https://github.com/jqlang/jq/releases/download/jq-1.6/jq-linux64 -o /tmp/jq && chmod 755 /tmp/jq && \
    curl -sL https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz -o /tmp/openshift-client-linux.tar.gz && \
    tar xvf  /tmp/openshift-client-linux.tar.gz

FROM registry.access.redhat.com/ubi9/python-311@sha256:9101b9924d06a4944649e9cb008496813479d66271ee1f2a1b6ddfc91228c97c
LABEL description="This image provides a data collection service for segment"
LABEL io.k8s.description="This image provides a data collection service for segment"
LABEL io.k8s.display-name="segment collection"
LABEL io.openshift.tags="segment,segment-collection"
LABEL summary="Provides the segment data collection service"
LABEL com.redhat.component="segment-collection"


USER 0

WORKDIR /opt/app-root/src/

COPY . .
COPY --from=builder /tmp/oc /usr/local/bin/oc
COPY --from=builder /tmp/jq /usr/local/bin/jq

RUN pip install -U pip && pip install -r /opt/app-root/src/requirements.txt --force-reinstall

USER 1001