#!/usr/bin/env bash

git reset --hard && git clean -df
hugo -D

aws s3 sync public/ s3://thenaim.de \
            --exclude '.git/*' \
            --exclude '.gitignore' \
            --exclude '.gitmodules' \
            --exclude '.DS_Store' \
            --exclude 'deploy.sh' \
            --exclude 'terraform' 

git reset --hard && git clean -df