package cmd

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"

	"github.com/philips/grpc-gateway-example/insecure"
)

const (
	grpcport = 10000
        restport = 8080
)

var (
	demoKeyPair  *tls.Certificate
	demoCertPool *x509.CertPool
	grpcAddr     string
	restAddr     string
)

func init() {
	var err error
	pair, err := tls.X509KeyPair([]byte(insecure.Cert), []byte(insecure.Key))
	if err != nil {
		panic(err)
	}
	demoKeyPair = &pair
	demoCertPool = x509.NewCertPool()
	ok := demoCertPool.AppendCertsFromPEM([]byte(insecure.Cert))
	if !ok {
		panic("bad certs")
	}
	grpcAddr = fmt.Sprintf("localhost:%d", grpcport)
}
