#!/bin/bash

STAGE=$1
AWS_PROFILE=$2

if [ -z "$STAGE" ] || [ -z "$AWS_PROFILE" ]; then
  echo "Usage: $0 stage aws_profile"
  exit 1
fi


REGION='us-east-1'
REPO_NAME="serverless-app-runner-$STAGE"

aws ecr delete-repository --repository-name $REPO_NAME --profile $AWS_PROFILE --region $REGION --force