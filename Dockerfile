#FROM registry.access.redhat.com/devtools/go-toolset-1.10-rhel7:latest
FROM centos/go-toolset-7-centos7:latest

LABEL io.k8s.description="Builder for creating grpc Rest to GRPC Gateways" \
      io.k8s.display-name="GRPC Rest Gateway" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,grpc" \
      io.openshift.s2i.scripts-url="image:///opt/s2i"

USER root

RUN yum install -y protobuf protobuf-devel protobuf-c-devel; yum clean all

RUN scl enable go-toolset-7 "go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway"
RUN scl enable go-toolset-7 "go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger"
RUN scl enable go-toolset-7 "go get -u github.com/golang/protobuf/protoc-gen-go"

COPY s2i /opt/s2i
RUN chmod -R g+rwx /opt/s2i 

USER 1001
