#!/bin/sh
fly -t lite sp -p pas-aws \
    -c `dirname $0`/pipeline.yml \
    -l `dirname $0`/credentials.yml
