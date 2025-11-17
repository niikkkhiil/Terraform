output "web_instance_id" {
  description = "ID of the web server instance"
  value       = aws_instance.web.id
}

output "app_security_group_id" {
  description = "ID of the app security group"
  value       = aws_security_group.app.id
}