terraform {
  required_providers {
    clickhouse = {
      source = "ClickHouse/clickhouse"
      version = "2.0.0"
    }
  }
}

variable "organization_id" {
  type = string
}

variable "token_key" {
  type = string
}

variable "token_secret" {
  type = string
}

variable "service_password" {
  type = string
}

variable "memory_gb" {}

provider clickhouse {
  organization_id = var.organization_id
  token_key   	= var.token_key
  token_secret	= var.token_secret
}

resource "clickhouse_service" "service" {
  name        = format("rta-benchmark-%d",var.memory_gb)
  cloud_provider = "aws"
  region     	= "us-east-2"
  idle_scaling   = false
  password  = var.service_password
  min_replica_memory_gb = var.memory_gb
  max_replica_memory_gb = var.memory_gb
  ip_access = [
    {
      source  	= "0.0.0.0/0"
      description = "Anywhere"
    }
  ]
}

output "CLICKHOUSE_HOST" {
  value = clickhouse_service.service.endpoints.0.host
}
