resource "aws_iam_role" "deck_builder_pod_identity" {
  name = "deck-builder-pod-identity-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "pods.eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.deck_builder_pod_identity.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_pod_identity_association" "deck_builder" {
  cluster_name     = aws_eks_cluster.eks.name
  namespace        = "deck-builder"
  service_account  = "deck-builder-sa"
  role_arn         = aws_iam_role.deck_builder_pod_identity.arn
}