resource "aws_instance" "bastion_host" {
    ami = "ami-0ef32de3e8ab0640e"
    instance_type = "t2.micro"
    subnet_id = module.vpc.public_subnets[0]
    key_name = var.key_name

    security_groups = [aws_security_group.bastion_sg.id]
    associate_public_ip_address = true

    user_data = file("scripts/setup-bastion.sh")

    tags = {
        Name = "BastionHost"
    }

    iam_instance_profile = aws_iam_instance_profile.bastion_profile.name
}

resource "aws_iam_role" "bastion_role" {
  name               = "bastion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
        Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bastion_eks_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.bastion_role.name
}

resource "aws_iam_instance_profile" "bastion_profile" {
    name = "bastion-profile"
    role = aws_iam_role.bastion_role.name
}