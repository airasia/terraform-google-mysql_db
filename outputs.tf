output "usage_IAM_roles" {
  description = "Basic IAM role(s) that are generally necessary for using the resources in this module. See https://cloud.google.com/iam/docs/understanding-roles."
  value = [
    "roles/cloudsql.client",
  ]
}

// Master
output "instance_name" {
  value       = module.google_mysql_db.instance_name
  description = "The instance name for the master instance"
}

output "instance_ip_address" {
  value       = module.google_mysql_db.instance_ip_address
  description = "The IPv4 address assigned for the master instance"
}

output "private_address" {
  value       = module.google_mysql_db.private_address
  description = "The private IP address assigned for the master instance"
}

output "instance_first_ip_address" {
  value       = module.google_mysql_db.instance_first_ip_address
  description = "The first IPv4 address of the addresses assigned for the master instance."
}

output "instance_connection_name" {
  value       = module.google_mysql_db.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "instance_self_link" {
  value       = module.google_mysql_db.instance_self_link
  description = "The URI of the master instance"
}

output "instance_server_ca_cert" {
  value       = module.google_mysql_db.instance_server_ca_cert
  description = "The CA certificate information used to connect to the SQL instance via SSL"
}

output "instance_service_account_email_address" {
  value       = module.google_mysql_db.instance_service_account_email_address
  description = "The service account email address assigned to the master instance"
}

// Replicas
output "replicas_instance_first_ip_addresses" {
  value       = module.google_mysql_db.replicas_instance_first_ip_addresses
  description = "The first IPv4 addresses of the addresses assigned for the replica instances"
}

output "replicas_instance_connection_names" {
  value       = module.google_mysql_db.replicas_instance_connection_names
  description = "The connection names of the replica instances to be used in connection strings"
}

output "replicas_instance_self_links" {
  value       = module.google_mysql_db.replicas_instance_self_links
  description = "The URIs of the replica instances"
}

output "replicas_instance_server_ca_certs" {
  value       = module.google_mysql_db.replicas_instance_server_ca_certs
  description = "The CA certificates information used to connect to the replica instances via SSL"
}

output "replicas_instance_service_account_email_addresses" {
  value       = module.google_mysql_db.replicas_instance_service_account_email_addresses
  description = "The service account email addresses assigned to the replica instances"
}

output "read_replica_instance_names" {
  value       = module.google_mysql_db.read_replica_instance_names
  description = "The instance names for the read replica instances"
}

output "root_user_name" {
  description = "The name of the root user"
  value       = var.root_user_name
}

output "root_user_password" {
  description = "The password of the root user (auto-generated if var.root_user_password was not provided)"
  value       = var.root_user_password != "" ? var.root_user_password : module.google_mysql_db.generated_user_password
  sensitive   = true
}

output "root_user_host" {
  description = "The host of the root user"
  value       = var.root_user_host
}

output "additional_users" {
  description = "The additional_users that were passed into this module."
  value       = var.additional_users
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  value       = module.google_mysql_db.public_ip_address
}

output "private_ip_address" {
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance"
  value       = module.google_mysql_db.private_ip_address
}

output "instance_psc_attachment" {
  description = "The PSC service attachment URI created for the master instance. Use this to create PSC consumer endpoints in other projects."
  value       = module.google_mysql_db.instance_psc_attachment
}
