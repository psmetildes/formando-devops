module "cluster" {
    source = "./clusters" 
    cluster_name = "infra"
    kubernetes_version = "kindest/node:v1.21.14"
}

output "api_endpoint" {
  value = module.cluster.api_endpoint
}

output "kubeconfig" {
  value = module.cluster.kubeconfig
}

output "client_certificate" {
  value = module.cluster.client_certificate

}
output "client_key" {
  value = module.cluster.client_key
}

output "cluster_ca_certificate" {
  value = module.cluster.cluster_ca_certificate
}