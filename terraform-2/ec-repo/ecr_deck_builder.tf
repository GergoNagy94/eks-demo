resource "aws_ecr_repository" "deck_builder_server" {
  name = "deck_builder_server"
}

resource "aws_ecr_repository" "deck_builder_client" {
  name = "deck_builder_client"
}

resource "terraform_data" "ecr_login_server" {
  depends_on = [ aws.terraform_data.push_image_client ]
  
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${local.region} | \
      docker login --username AWS --password-stdin ${aws_ecr_repository.deck_builder_server.repository_url}
    EOT
  }
}

resource "terraform_data" "push_image_server" {
  depends_on = [terraform_data.ecr_login_server]

  provisioner "local-exec" {
    command = <<EOT
      docker tag deck_builder_server:v1 ${aws_ecr_repository.deck_builder_server.repository_url}:v1
      docker push ${aws_ecr_repository.deck_builder_server.repository_url}:v1
    EOT
  }
}

resource "terraform_data" "ecr_login_client" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${local.region} | \
      docker login --username AWS --password-stdin ${aws_ecr_repository.deck_builder_client.repository_url}
    EOT
  }
}

resource "terraform_data" "push_image_client" {
  depends_on = [terraform_data.ecr_login_client]

  provisioner "local-exec" {
    command = <<EOT
      docker tag deck_builder_client:v1 ${aws_ecr_repository.deck_builder_client.repository_url}:v1
      docker push ${aws_ecr_repository.deck_builder_client.repository_url}:v1
    EOT
  }
}

