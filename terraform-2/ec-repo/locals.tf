locals {
  env = "staging"
  region = "eu-central-1"
  zone_1 = "eu-central-1a"
  zone_2 = "eu-central-1b"
  eks_name = "gergo-demo-4"
  eks_version = "1.29"
}

resource "null_resource" "kube_config" {
  depends_on = [aws_eks_cluster.eks]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region eu-central-1 --name staging_gergo-demo-4"
  }
}
