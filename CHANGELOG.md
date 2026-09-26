# Changelog

## 2026-09-26

- Split the AWS version into its own repository, separate from the self-hosted one.
- Added CloudWatch CPU alarms so the scale-up and scale-down policies actually fire (70% and 25% over one minute).
- Moved AWS credentials, account ID, CLI profile and Django secret key out of the code and into environment variables and Terraform variables.
- Removed the unused `products_api` app, the old `products` pages and the logs page (its endpoint only exists in the self-hosted version).
- Added `.env.example` files, README with architecture and deploy steps, and this changelog.

## 2025-11 — Elasticity

- Application Load Balancer with path routing: `/api/*` to the backend, everything else to the frontend.
- Auto Scaling Groups for frontend and backend (1 to 3 `t2.micro` instances), pulling images from ECR on boot.
- Lambda function packaged with Docker; SNS topic fanning out to SQS, which triggers the Lambda.
- Lambda converts uploads to grayscale and registers the result with the backend through a service token.

## 2025-10 — AWS services

- Django REST API with JWT auth, user profiles and posts with images.
- Next.js frontend with feed, post detail, edit and profile pages.
- Images stored in S3 (private prefix), metadata in RDS PostgreSQL.
- CRUD actions and authenticated requests logged to DynamoDB.
- Terraform for the VPC, subnets, security groups, RDS, S3, DynamoDB, SNS/SQS and IAM.
