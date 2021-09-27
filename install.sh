#!/bin/bash

# if there is a env file, source it
if [ -f "./.env" ]; then
   source ./.env
else
   source ./.env.example
fi

docker run --rm --privileged -it \
-e AWS_S3_URL=${AWS_S3_URL} \
-e AWS_S3_REGION=${AWS_S3_REGION} \
-e AWS_S3_BUCKET_NAME=${AWS_S3_BUCKET_NAME} \
-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
-p 1935:1935 \
-p 8080:80 \
ghcr.io/codions/docker-stream-server/docker-stream-server:latest