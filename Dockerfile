#FROM registry.access.redhat.com/devtools/go-toolset-1.10-rhel7:latest
FROM centos/go-toolset-7-centos7:latest

LABEL io.k8s.description="Builder for creating grpc Rest to GRPC Gateways" \
      io.k8s.display-name="GRPC Rest Gateway" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,grpc" \
      io.openshift.s2i.scripts-url="image:///opt/s2i" \
      io.openshift.s2i.destination="/tmp/proto"

USER root

RUN yum install -y unzip; yum clean all

RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip -O protoc.zip && \
    mkdir /opt/protoc && \
    unzip -d /opt/protoc protoc.zip && \
    chmod -R g+r /opt/protoc && \
    chmod g+x /opt/protoc/bin/protoc && \
    rm protoc.zip
    
COPY s2i /opt/s2i
RUN chmod -R g+rwx /opt/s2i 

ENV PATH=/opt/protoc/bin:/opt/app-root/src/go/bin:${PATH}
ENV IMPORT_URL=github.com/philips/grpc-gateway-example

COPY gateway/ /tmp/src/
RUN chmod -R g+rw /tmp/src

USER 1001

RUN mkdir /tmp/proto

RUN scl enable go-toolset-7 "go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway"
RUN scl enable go-toolset-7 "go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger"
RUN scl enable go-toolset-7 "go get -u github.com/golang/protobuf/protoc-gen-go"

