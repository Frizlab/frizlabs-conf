#!/bin/bash

echo connect_netsoul.sh\'s pid: $$

i=0 && >input && tail -F input | nc ns-server.epita.fr 4242 | while read f; do echo ">> $f"; case $i in 0) secret=$(echo $f | cut -d ' ' -f 3); ip=$(echo $f | cut -d ' ' -f 4); port=$(echo $f | cut -d ' ' -f 5); echo "auth_ag ext_user none none" | tee -a input;; 1) echo "ext_user_log vass_t $(printf "$secret-$ip/${port}m+CqNPnt" | md5) LabMTI connect_netsoul.sh" | tee -a input;; 2) true;; *) echo "$f" | tee -a input;; esac; i=$((i+1)); done
