terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

locals {
  pod_labels = {
    app = var.name
  }
}

/* -------------------------------------------------------------------------- */
/*                               k8s deployments                              */
/* -------------------------------------------------------------------------- */
resource "kubernetes_deployment" "app" {
  # the Deployment Object uses metadata to identify and target that object in API calls
  metadata {
    name = var.name
  }

  spec {
    replicas = var.replicas

    template {
      metadata {
        labels = local.pod_labels
      }

      spec {
        # Specify which Docker contrainers to run in this Pod
        container {
          name  = var.name  # The name to use for the container
          image = var.image # The Docker image to run in the container

          port {
            container_port = var.container_port # The ports to expose in the container
          }

          # The env var to expose to the container
          dynamic "env" {
            for_each = var.environment_variables
            content {
              name  = env.key
              value = env.value
            }
          }
        }
      }
    }

    selector { # What to target
      # manage deployments for the Pod Template you just defined
      match_labels = local.pod_labels
    }
  }
}

/* -------------------------------------------------------------------------- */
/*                                k8s services                                */
/* -------------------------------------------------------------------------- */
resource "kubernetes_service" "app" {
  # the Service Object uses metadata to identify and target that object in API calls
  metadata {
    name = var.name
  }

  spec {
    type = "LoadBalancer"
    port {
      port        = 80                 # route traffic on port 80 (default port for HTTP)...
      target_port = var.container_port # to the port the container is listening on
      protocol    = "TCP"
    }
    selector = local.pod_labels # specify what this Service should be targeting
  }
}
