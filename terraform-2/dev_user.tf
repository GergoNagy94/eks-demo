resource "aws_iam_user" "dev" {
  name = "dev"
}

resource "aws_iam_policy" "dev_eks" {
  name = "AmazonEKSDeveloperPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17"
    "Statement": [
        {
            "Effect": "Allow"
            "Actions": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "dev_eks" {
    user = aws_iam_user.dev.name
    policy_arn = aws_iam_policy.dev_eks.arn
}

resource "aws_eks_access_entry" "dev" {
  cluster_name = aws_eks_cluster.eks.name
  principal_arn = aws_iam_user.dev.arn
  kubernetes_groups = [ "gergo-viewer" ]
}