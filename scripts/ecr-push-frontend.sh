#!/bin/bash
set -euo pipefail

: "${AWS_ACCOUNT_ID:?set AWS_ACCOUNT_ID}"
AWS_REGION="${AWS_REGION:-us-east-1}"
AWS_PROFILE="${AWS_PROFILE:-default}"
REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "Authenticating to ECR..."
aws ecr --profile "$AWS_PROFILE" get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$REGISTRY"

cd "$(dirname "$0")/../frontend"
echo "Building frontend..."
docker build --platform=linux/amd64 -t mdcc-nuvem-frontend .

echo "Pushing frontend..."
docker tag mdcc-nuvem-frontend:latest "$REGISTRY/mdcc-nuvem-frontend:latest"
docker push "$REGISTRY/mdcc-nuvem-frontend:latest"
