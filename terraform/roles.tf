data "aws_iam_policy_document "cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifyers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster" {
  name = "eksClusterRole"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role_policy.json
}


