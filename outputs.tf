output "public_id" {
  description = "public ip of the created instance"
  value = "http://${web.public_id}"
}