variable "region" {
  default = "us-west-2"
}

variable "bucket_statefile" {
  type        = string
  description = "Name of created S3 bucket for statefile"
  default     = "terraform-infra-staging"
}


variable "region_cloudfront" {
  default = "us-east-1"
}

variable "bucket_network" {
  type        = string
  description = "Name of created S3 bucket for network"
  default     = "network-staging-projectxyz"
}

variable "domain_name" {
  type        = string
  description = "Name of domain"
  default     = "ladifa.xyz"
}


variable "zone_id" {
  type        = string
  description = "The zone id for the domain"
  default     = ""
}

variable "route53_name" {
  type        = string
  description = "Record name for cloudfront"
  default     = "cloudfront.staging.ladifa.xyz"
}

variable "route53_record_type" {
  type        = string
  description = "Record type for cloudfront"
  default     = "A"
}

variable "codestar_connector_credentials" {
  type        = string
  description = "Connect AWS codepipeline and github for integration"
  default     = ""
}

