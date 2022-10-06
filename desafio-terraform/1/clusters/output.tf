output "api_endpoint" {
  value = kind_cluster.cluster_k8s.endpoint
}


output "kubeconfig" {
  value = kind_cluster.cluster_k8s.kubeconfig
}


output "client_certificate" {
  value = kind_cluster.cluster_k8s.client_certificate
}


output "client_key" {
  value = kind_cluster.cluster_k8s.client_key
}


output "cluster_ca_certificate" {
  value = kind_cluster.cluster_k8s.cluster_ca_certificate
}