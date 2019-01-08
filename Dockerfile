FROM registry.access.redhat.com/devtools/go-toolset-1.10-rhel7:latest

LABEL io.k8s.description="Builder for creating grpc Rest to GRPC Gateways" \
      io.k8s.display-name="GRPC Rest Gateway" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,grpc" \
      io.openshift.s2i.scripts-url="image:///opt/s2i"

RUN yum install -y protobuf protobuf-devel protobuf-c-devel; yum clean all

RUN go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
RUN go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
RUN go get -u github.com/golang/protobuf/protoc-gen-go

COPY s2i /opt/s21
