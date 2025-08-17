#!/usr/bin/bash

docker builder du
docker image prune -a -f
docker builder prune -a -f
docker builder du

cd github-readme-stats
docker build --tag github-readme-stats -f ../dockerfile .
cd ..
