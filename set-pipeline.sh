#!/bin/sh
fly -t home sp -p pas-aws \
    -c `dirname $0`/pipeline.yml \
    -l `dirname $0`/credentials.yml
