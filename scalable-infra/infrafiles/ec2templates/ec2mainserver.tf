#main ec2 server created using the launch template
resource "aws_instance" "web_instance" {
    count         = 2
    ami           = "ami-02d26659fd82cf299" # Amazon Linux 2 (example)
    instance_type = "t2.micro"
    subnet_id     = element([aws_subnet.product_v1_subnet_1a_public.id, aws_subnet.product_v1_subnet_1b_public.id], count.index)
    key_name      = "my-key-pair" # Replace with your key pair name
    security_groups = [aws_security_group.product_v1_sg.id] # Replace with your security group ID
    
    tags = {
        Name = "web-instance-${count.index + 1}"
    }
    
    user_data = base64encode(<<-EOF
                #!/bin/bash
                yum update -y
                yum install -y nginx
                systemctl enable nginx
                systemctl start nginx
                echo "<h1>Hello from EC2 Instance ${count.index + 1}</h1>" > /usr/share/nginx/html/index.html
                EOF
    )
    }
