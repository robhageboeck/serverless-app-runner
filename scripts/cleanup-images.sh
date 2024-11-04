#!/bin/bash

#!/bin/bash

STAGE=$1
AWS_PROFILE=$2

if [ -z "$STAGE" ] || [ -z "$AWS_PROFILE" ]; then
  echo "Usage: $0 stage aws_profile"
  exit 1
fi

REGION="us-east-1"
REPO_NAME="serverless-app-runner-$STAGE"

images_to_delete=$(aws ecr list-images --repository-name $REPO_NAME --profile $AWS_PROFILE --region $REGION --query 'imageIds[?imageTag!=`latest`].imageDigest' --output text)

if [ ! -z "$images_to_delete" ]; then
  echo "Deleting old images: $images_to_delete"
  aws ecr batch-delete-image --repository-name $REPO_NAME --image-ids $(echo $images_to_delete | awk '{for(i=1;i<=NF;i++) print "{\"imageDigest\":\""$i"\"}"}') --profile $AWS_PROFILE --region $REGION
else
  echo "No old images to delete."
fi
