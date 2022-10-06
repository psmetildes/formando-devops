resource "kind_cluster" "cluster_k8s" {
  name = var.cluster_name
  node_image = var.kubernetes_version
  wait_for_ready  = true

  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
        
    node {
      role = "control-plane" 
    }

    node {
      role = "infra"
      kubeadm_config_patches = [
        "kind: JoinConfiguration\nnodeRegistration:\n name: \"infra\" \n kubeletExtraArgs:\n    node-labels: \"role=infra\"\n"
      ]
    }

    node {
      role = "app"
      kubeadm_config_patches = [
        "kind: JoinConfiguration\nnodeRegistration:\n name: \"app\" \n kubeletExtraArgs:\n    node-labels: \"role=app\"\n"
      ]
    }
  }

  provisioner "local-exec" {
    command = "kubectl taint node infra dedicated=infra:NoSchedule && kubectl apply -f ${path.module}/metrics-server.yaml"
  }
}

