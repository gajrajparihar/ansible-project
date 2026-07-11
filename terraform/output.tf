resource "local_file" "ansible_inventory" {
	filename = "${path.module}/../ansible/inventory.yml"
	content = <<-EOT
all:
  children:
    app:
      hosts:
        webserver1:
          ansible_host: ${aws_instance.web_server[0].public_ip}

        webserver2:
          ansible_host: ${aws_instance.web_server[1].public_ip}
EOT
}

output "web_server_public_ips" {
	value = aws_instance.web_server[*].public_ip
}

output "ansible_inventory_file" {
	value = local_file.ansible_inventory.filename
}
