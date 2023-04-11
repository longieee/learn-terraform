output "service_endpoint" {
  value       = module.simple_webapp.service_endpoint
  description = "The k8s service endpoint"
}
