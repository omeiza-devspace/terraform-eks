variable "region" {
  description = "Region of the service"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "aws_profile_name" {
  description = "AWS Account profile name for local exec"
  type        = string
}

variable "document_directory" {
  description = "Directory where all S3 upload exist"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Database table name for locking state file"
  type        = string
}

variable "enable_data_encryption" {
  description = "Option to encrypt S3 data"
  type        = bool
  default     = true
}

variable "enable_data_version" {
  description = "Option to version S3 data"
  type        = string
  default     = "Enabled"
}


 