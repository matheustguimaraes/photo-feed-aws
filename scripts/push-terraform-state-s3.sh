#!/bin/bash

cd "$(dirname "$0")/../terraform"

BUCKET="${TF_STATE_BUCKET:-mdcc-nuvem-terraform-state}"
PROFILE="${AWS_PROFILE:-default}"

echo "Uploading Terraform state to s3://$BUCKET/"

aws --profile $PROFILE s3 cp terraform.tfstate s3://$BUCKET/terraform.tfstate

if [ -f terraform.tfstate.backup ]; then
    aws --profile $PROFILE s3 cp terraform.tfstate.backup s3://$BUCKET/terraform.tfstate.backup
else
    echo "Terraform state backup file not found, skipping..."
fi

echo "Done!"
