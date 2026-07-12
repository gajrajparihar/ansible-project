
# Security Group For ALB
resource "aws_security_group" "server_ssh" {
  name   = "server_ssh"
  vpc_id = data.aws_vpc.prod-vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  } 

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  } 

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
          Name = "server_ssh"
        } 
  )
}

resource "aws_security_group" "alb_http" {
  name   = "alb_http"
  vpc_id = data.aws_vpc.prod-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "alb_http"
  })
}

resource "aws_security_group" "ecs_tasks" {
  name   = "ecs_tasks"
  vpc_id = data.aws_vpc.prod-vpc.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_http.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "ecs_tasks"
  })
}
