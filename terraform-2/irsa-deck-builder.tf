resource "aws_iam_role" "deck_builder_irsa" {
  name = "deck_builder_irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:deck-builder:deck-builder-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "deck_builder_irsa_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.deck_builder_irsa.name
}