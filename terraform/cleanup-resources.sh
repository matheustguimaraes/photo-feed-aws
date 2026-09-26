#!/bin/bash


set -e

REGION="us-east-1"
PROJECT_NAME="mdcc-nuvem"
S3_BUCKET="${S3_BUCKET:?set S3_BUCKET}"

echo "Cleaning up ECR repositories..."

echo "Deleting images from ${PROJECT_NAME}-frontend..."
aws ecr batch-delete-image \
  --repository-name "${PROJECT_NAME}-frontend" \
  --region "${REGION}" \
  --image-ids "$(aws ecr list-images --repository-name "${PROJECT_NAME}-frontend" --region "${REGION}" --query 'imageIds[*]' --output json)" \
  2>/dev/null || echo "No images in frontend repository or repository doesn't exist"

echo "Deleting images from ${PROJECT_NAME}-backend..."
aws ecr batch-delete-image \
  --repository-name "${PROJECT_NAME}-backend" \
  --region "${REGION}" \
  --image-ids "$(aws ecr list-images --repository-name "${PROJECT_NAME}-backend" --region "${REGION}" --query 'imageIds[*]' --output json)" \
  2>/dev/null || echo "No images in backend repository or repository doesn't exist"

echo "Deleting images from ${PROJECT_NAME}-worker..."
aws ecr batch-delete-image \
  --repository-name "${PROJECT_NAME}-worker" \
  --region "${REGION}" \
  --image-ids "$(aws ecr list-images --repository-name "${PROJECT_NAME}-worker" --region "${REGION}" --query 'imageIds[*]' --output json)" \
  2>/dev/null || echo "No images in worker repository or repository doesn't exist"

echo ""
echo "Cleaning up S3 bucket..."

echo "Deleting all objects from ${S3_BUCKET}..."
aws s3 rm "s3://${S3_BUCKET}" --recursive --region "${REGION}" 2>/dev/null || echo "Bucket is empty or doesn't exist"

echo "Deleting all versions from ${S3_BUCKET}..."
aws s3api delete-objects \
  --bucket "${S3_BUCKET}" \
  --delete "$(aws s3api list-object-versions --bucket "${S3_BUCKET}" --region "${REGION}" --query '{Objects: Versions[].{Key:Key,VersionId:VersionId},Quiet:true}' --output json)" \
  2>/dev/null || echo "No versions to delete"

aws s3api delete-objects \
  --bucket "${S3_BUCKET}" \
  --delete "$(aws s3api list-object-versions --bucket "${S3_BUCKET}" --region "${REGION}" --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId},Quiet:true}' --output json)" \
  2>/dev/null || echo "No delete markers to remove"

echo ""
echo "Cleanup complete! You can now run 'terraform destroy'"

