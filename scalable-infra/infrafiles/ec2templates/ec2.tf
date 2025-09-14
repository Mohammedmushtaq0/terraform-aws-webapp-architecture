#EC2_Instance template
resource "aws_launch_template" "web_template" {
  name_prefix   = "web-server-"
  description   = "Launch template for web servers"
  image_id      = "ami-02d26659fd82cf299" # Amazon Linux 2 (example)
  instance_type = "t2.micro"

  key_name = "my-key-pair" # Replace with your key pair name

    network_interfaces {
        associate_public_ip_address = false
        subnet_id                   = aws_subnet.product_v1_subnet_1a_public.id # Fixed: removed array brackets
        security_groups             = [aws_security_group.product_v1_sg.id] # Replace with your security group ID
    }
  # Example: User Data (install nginx)
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Hello from EC2 via Launch Template</h1>" > /usr/share/nginx/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-template-instance"
    }
  }
}


