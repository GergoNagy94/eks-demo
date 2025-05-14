resource "kubernetes_cluster_role" "viewer" {
  metadata {
    name = "viewer"
  }

  rule {
    api_groups = ["*"]
    resources = ["deployments", "configmaps", "pods", "secrets", "services"]
    verbs = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "gergo_admin_binding" {
  metadata {
    name = "gergo_admin_binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster_admin"
  }

  subject {
    kind = "Group"
    name = "gergo_admin"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "gergo_viewer_binding" {
  metadata {
    name = "gergo_viewer_binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "viewer"
  }

  subject {
    kind = "Group"
    name = "gergo_viewer"
    api_group = "rbac.authorization.k8s.io"
  }
}