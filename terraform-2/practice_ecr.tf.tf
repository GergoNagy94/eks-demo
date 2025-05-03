resource "aws_ecr_repository" "flask_app" {
  name = "flask_app"
}

resource "null_resource" "ecr_login" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${local.region} | \
      docker login --username AWS --password-stdin ${aws_ecr_repository.flask_app.repository_url}
    EOT
  }
}

resource "null_resource" "push_image" {
  depends_on = [null_resource.ecr_login]

  provisioner "local-exec" {
    command = <<EOT
      docker tag my-local-image:latest ${aws_ecr_repository.flask_app.repository_url}:latest
      docker push ${aws_ecr_repository.flask_app.repository_url}:latest
    EOT
  }
}
