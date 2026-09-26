resource "aws_sqs_queue" "image_processing" {
  name                       = var.sqs_queue_name
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 300

  tags = {
    Name = "${var.project_name}-image-processing-queue"
  }
}

