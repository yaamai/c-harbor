#!/bin/bash

make compile
make build_base_docker
make build

docker images
