#!/bin/bash

handler_func=`grep -o Register.*HandlerFromEndpoint *.pb.gw.go | uniq`

cat << EOF > handler-export.go
package servicepb

var RegisterHandler = ${handler_func}

EOF
