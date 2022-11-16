resource "kind_cluster" "cluster_k8s" {
    name           = var.cluster_name
    wait_for_ready = true
    node_image = var.node_image
  
    kind_config {
        kind        = "Cluster"
        api_version = "kind.x-k8s.io/v1alpha4"
    
        node {
            role = "control-plane"
        }

        node {
            role = "worker"
        }
    }
}
