output "pw" {
  value = local.dbpw
}

output "db_endpoint" {
 value = aws_db_instance.GrafanaDB.endpoint
}
