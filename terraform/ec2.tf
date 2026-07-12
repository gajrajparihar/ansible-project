# resource "aws_instance" "web_server" {
#   count = 2

#   ami           = var.ami_id
#   instance_type = "t3.micro"
#   key_name      = var.ec2_key_name

#   subnet_id                   = data.aws_subnet.public-subnet1.id
#   vpc_security_group_ids      = [aws_security_group.server_ssh.id]
#   associate_public_ip_address = true
#   monitoring                  = false
#   ebs_optimized               = true

#   root_block_device {
#     volume_size           = 20
#     volume_type           = "gp3"
#     delete_on_termination = true
#     encrypted             = true
#   }

#   tags = merge(local.common_tags, {
#     Name = "web-server${count.index + 1}"
#   })
# }


# resource "aws_instance" "ansible_server" {
#   ami                    = var.ami_id
#   instance_type          = "t3.small" # Free-tier eligible
#   key_name               = var.ec2_key_name

#   subnet_id                   = data.aws_subnet.public-subnet1.id
#   vpc_security_group_ids      = [aws_security_group.server_ssh.id]
#   associate_public_ip_address = true
#   monitoring                  = false
#   ebs_optimized               = true
  
#   user_data = file("${path.module}/userdata.sh")
#   root_block_device {
#     volume_size = 20              # 10 GB root disk
#     volume_type = "gp3"           # gp3 (cheaper & faster than gp2)
#     delete_on_termination = true  # auto-delete with instance
#     encrypted                   = true
#     kms_key_id            = null
#   }
#   tags = merge(local.common_tags, {
#           Name = "ansible_server"
#         } 
#   )
# }
