locals {
  status = kubernetes_service.app.status
}

output "service_endpoint" {
  value = try( # try returns the first argument that doesn't produce any errors
    "http://${local.status[0]["load_balancer"][0]["ingress"][0]["hostname"]}",
    "error parsing hostname from status"
  )
  description = "The k8s Service endpoint"
}
