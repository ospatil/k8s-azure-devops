output "client_certificate" {
  value     = module.k8s.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = module.k8s.kube_config
  sensitive = true
}
