#!/usr/bin/env bash
pass vault/root > secrets/token
pass farm/certificate > secrets/cert.pem
pass vault/aws-access-key > secrets/aws-access-key
pass vault/aws-secret-key > secrets/aws-secret-key
