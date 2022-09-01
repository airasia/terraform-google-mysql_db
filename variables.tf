# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "name_suffix" {
  description = "An arbitrary suffix that will be added to the end of the resource name(s). For example: an environment name, a business-case name, a numeric id, etc."
  type        = string
  validation {
    condition     = length(var.name_suffix) <= 14
    error_message = "A max of 14 character(s) are allowed."
  }
}

variable "private_network" {
  description = "A VPC network (self-link) that can access the MySQL instance via private IP. Can set to \"null\" if any of \"var.public_access_*\" is set to \"true\"."
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "root_user_name" {
  description = "The name of the root user."
  type        = string
  default     = "root"
}

variable "root_user_password" {
  description = "The password of the root user. If not set (recommended to keep unset), a random password will be generated and will be available in the root_user_password output attribute."
  type        = string
  default     = ""
}

variable "root_user_host" {
  description = "The host of the root user"
  type        = string
  default     = "%"
}

variable "full_name_master_instance" {
  description = "Full name of the master instance. For backward-compatibility only. Not recommended for general use."
  type        = string
  default     = ""
}

variable "name_master_instance" {
  description = "Portion of name to be generated for the \"Master\" instance. The same name of a deleted master instance cannot be reused for up to 7 days. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes."
  type        = string
  default     = "v1"
}

variable "name_read_replica" {
  description = "Portion of name to be generated for the \"ReadReplica\" instances. The same name of a deleted read-replica instance cannot be reused for up to 7 days. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes."
  type        = string
  default     = "v1"
}

variable "db_version" {
  description = "The MySQL database version to use. See https://cloud.google.com/sql/docs/mysql/db-versions."
  type        = string
  default     = "MYSQL_5_7"
}

variable "default_db_name" {
  description = "Name of the default database to be created."
  type        = string
  default     = "default"
}

variable "default_db_charset" {
  description = "The charset for the default database."
  type        = string
  default     = "utf8"
}

variable "default_db_collation" {
  description = "The collation for the default database."
  type        = string
  default     = "utf8_general_ci"
}

variable "instance_size_master_instance" {
  description = "The machine type/size of \"Master\" instance. See https://cloud.google.com/sql/pricing#2nd-gen-pricing."
  type        = string
  default     = "db-f1-micro"
}

variable "instance_size_read_replica" {
  description = "The machine type/size of \"ReadReplica\" instances. See https://cloud.google.com/sql/pricing#2nd-gen-pricing."
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size_gb_master_instance" {
  description = "Disk size for the master instance in Giga Bytes."
  type        = number
  default     = 10
}

variable "disk_size_gb_read_replica" {
  description = "Disk size for the read replica instance(s) in Giga Bytes."
  type        = number
  default     = 10
}

variable "disk_auto_resize_master_instance" {
  description = "Whether to increase disk storage size of the master instance automatically. Increased storage size is permanent. Google charges by storage size whether that storage size is utilized or not. Recommended to set to \"true\" for production workloads."
  type        = bool
  default     = false
}

variable "disk_auto_resize_read_replica" {
  description = "Whether to increase disk storage size of the read replica instance(s) automatically. Increased storage size is permanent. Google charges by storage size whether that storage size is utilized or not. Recommended to set to \"true\" for production workloads."
  type        = bool
  default     = false
}

variable "backup_enabled" {
  description = "Specify whether backups should be enabled for the MySQL instance."
  type        = bool
  default     = false
}

variable "backup_location" {
  description = "A string value representing REGIONAL or MULTI-REGIONAL location for storing backups. Defaults to the Google provider's region if nothing is specified here. See https://cloud.google.com/sql/docs/mysql/locations for REGIONAL / MULTI-REGIONAL values."
  type        = string
  default     = ""
}

variable "pit_recovery_enabled" {
  description = "Specify whether Point-In-Time recoevry should be enabled for the MySQL instance. It uses the \"binary log\" feature of CloudSQL. Value of 'true' requires 'var.backup_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "highly_available" {
  description = "Whether the MySQL instance should be highly available (REGIONAL) or single zone. Highly Available (HA) instances will automatically failover to another zone within the region if there is an outage of the primary zone. HA instances are recommended for production use-cases and increase cost. Value of 'true' requires 'var.pit_recovery_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "read_replica_count" {
  description = "Specify the number of read replicas for the MySQL instance. Value greater than 0 requires 'var.pit_recovery_enabled' to be 'true'."
  type        = number
  default     = 0
}

variable "authorized_networks_master_instance" {
  description = "External networks that can access the MySQL master instance through HTTPS."
  type = list(object({
    display_name = string
    cidr_block   = string
  }))
  default = []
}

variable "authorized_networks_read_replica" {
  description = "External networks that can access the MySQL ReadReplica instance(s) through HTTPS."
  type = list(object({
    display_name = string
    cidr_block   = string
  }))
  default = []
}

variable "region_master_instance" {
  description = "The region to launch the master instance in. Defaults to the Google provider's region if nothing is specified here. See https://cloud.google.com/compute/docs/regions-zones"
  type        = string
  default     = ""
}

variable "region_read_replica" {
  description = "The region to launch the ReadReplica instance(s) in. Defaults to the master instance's region if nothing is specified here. See https://cloud.google.com/compute/docs/regions-zones."
  type        = string
  default     = ""
}

variable "zone_master_instance" {
  description = "The zone-letter to launch the master instance in. Options are \"a\" or \"b\" or \"c\" or \"d\". See https://cloud.google.com/compute/docs/regions-zones."
  type        = string
  default     = "a"
}

variable "zone_read_replica" {
  description = "The zone-letter to launch the ReadReplica instance(s) in. Options are \"a\" or \"b\" or \"c\" or \"d\". See https://cloud.google.com/compute/docs/regions-zones."
  type        = string
  default     = "b"
}

variable "public_access_master_instance" {
  description = "Whether public IPv4 address should be assigned to the MySQL master instance. If set to 'false' then 'var.private_network' must be defined."
  type        = bool
  default     = false
}

variable "public_access_read_replica" {
  description = "Whether public IPv4 address should be assigned to the MySQL read-replica instance(s). If set to 'false' then 'var.private_network' must be defined."
  type        = bool
  default     = false
}

variable "db_flags_master_instance" {
  description = "The database flags applied to the master instance. See https://cloud.google.com/sql/docs/mysql/flags"
  type        = map(string)
  default     = {}
}

variable "db_flags_read_replica" {
  description = "The database flags applied to the read replica instances. See https://cloud.google.com/sql/docs/mysql/flags"
  type        = map(string)
  default     = {}
}

variable "labels_master_instance" {
  description = "Key/value labels for the master instance."
  type        = map(string)
  default     = {}
}

variable "labels_read_replica" {
  description = "Key/value labels for the ReadReplica instance(s)."
  type        = map(string)
  default     = {}
}

variable "db_timeout" {
  description = "How long a database operation is allowed to take before being considered a failure."
  type        = string
  default     = "30m"
}

variable "sql_proxy_user_groups" {
  description = "List of usergroup emails that maybe allowed to connect with the database using CloudSQL Proxy. Connecting via CLoudSQL proxy from remote/localhost requires \"var.public_access_*\" to be set to \"true\" (for whichever of master/replica instances you want to connect to). See https://cloud.google.com/sql/docs/mysql/sql-proxy#what_the_proxy_provides"
  type        = list(string)
  default     = []
}

variable "deletion_protection_master_instance" {
  description = "Used to prevent Terraform from deleting the master instance. Must apply with \"false\" first before attempting to delete in the next plan-apply."
  type        = bool
  default     = true
}

variable "deletion_protection_read_replica" {
  description = "Used to prevent Terraform from deleting the ReadReplica. Must apply with \"false\" first before attempting to delete in the next plan-apply."
  type        = bool
  default     = true
}

variable "additional_users" {
  description = "A list of additional users to be created in the CloudSQL instance"
  type = list(object({
    name     = string
    password = string
    host     = string
  }))
  default = []
}

variable "additional_databases" {
  description = "A list of additional databases to be created in the CloudSQL instance"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}

variable "maintenance_window" {
  description = <<-EOT
  day_utc: The day of the week (1-7) in UTC timezone - starting from Monday.
  hour_utc: The hour of the day (0-23) in UTC timezone - ignored if day is not set.
  update_track: The update track of maintenance window - can be either `canary` or `stable`.
  default: Tuesday, 3:00 AM — 4:00 AM GMT+8
  EOT
  type = object({
    day_utc      = number
    hour_utc     = number
    update_track = string
  })
  default = {
    day_utc      = 1
    hour_utc     = 19
    update_track = "stable"
  }
}

variable "insights_config" {
  description = "The insights_config settings for the database."
  type = object({
    query_string_length     = number
    record_application_tags = bool
    record_client_address   = bool
  })
  default = null
}