#!/bin/bash
set -euo pipefail

: "${AWS_ACCOUNT_ID:?set AWS_ACCOUNT_ID}"
AWS_REGION="${AWS_REGION:-us-east-1}"
AWS_PROFILE="${AWS_PROFILE:-default}"
REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "Authenticating to ECR..."
aws ecr --profile "$AWS_PROFILE" get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$REGISTRY"

cd "$(dirname "$0")/../backend"
echo "Building backend..."
docker build --platform=linux/amd64 -t mdcc-nuvem-backend .

echo "Pushing backend..."
docker tag mdcc-nuvem-backend:latest "$REGISTRY/mdcc-nuvem-backend:latest"
docker push "$REGISTRY/mdcc-nuvem-backend:latest"

echo "Pushing worker (same image, different entrypoint)..."
docker tag mdcc-nuvem-backend:latest "$REGISTRY/mdcc-nuvem-worker:latest"
docker push "$REGISTRY/mdcc-nuvem-worker:latest"
