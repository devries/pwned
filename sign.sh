#!/bin/sh
set -e

$(pgdecrypt -i environment.gcrypt)
gon -log-level=info ./apple_signconfig.hcl
