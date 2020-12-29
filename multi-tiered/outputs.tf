output "db_password" {
  value = module.database.db_config.password
}

output "db_host" {
  value = module.database.db_config.hostname
}

output "lb_dns_name" {
  value = module.autoscaling.lb_dns_name
}