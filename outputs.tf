output "public_id" {
  description = "public ip of the created instance(webserver)"
  value = "http://${aws_instance.web.public_id}"
}
