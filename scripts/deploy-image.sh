#!/bin/bash

STAGE=$1
AWS_PROFILE=$2

if [ -z "$STAGE" ] || [ -z "$AWS_PROFILE" ]; then
  echo "Usage: $0 stage aws_profile"
  exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --profile $AWS_PROFILE --query Account --output text)
REGION="us-east-1"
REPO_NAME="serverless-app-runner-$STAGE"

existing_repos=$(aws ecr describe-repositories --profile "$AWS_PROFILE" --region "$REGION" --query "repositories[*].repositoryName" --output text)
if echo "$existing_repos" | grep -w "$REPO_NAME" > /dev/null; then
  echo "Repository $REPO_NAME already exists."
else
  echo "Repository $REPO_NAME not found. Creating it..."
  if aws ecr create-repository --repository-name "$REPO_NAME" --profile "$AWS_PROFILE" --region "$REGION"  >/dev/null 2>&1; then
    echo "Repository $REPO_NAME created successfully."
  else
    echo "Failed to create repository $REPO_NAME."
    exit 1
  fi
fi

aws ecr get-login-password --profile $AWS_PROFILE --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

docker build --platform linux/amd64 -t $REPO_NAME .
docker tag $REPO_NAME:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest

docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest
