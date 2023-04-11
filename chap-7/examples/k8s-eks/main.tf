/* -------------------------------------------------------------------------- */
/*                                   Backend                                  */
/* -------------------------------------------------------------------------- */


/* -------------------------------------------------------------------------- */
/*                                  Providers                                 */
/* -------------------------------------------------------------------------- */
provider "aws" {
  region = "us-east-2"
}

provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpint
  cluster_ca_certificate = base64encode(module.eks_cluster.cluster_certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

/* -------------------------------------------------------------------------- */
/*                                    Data                                    */
/* -------------------------------------------------------------------------- */
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_name
}

/* -------------------------------------------------------------------------- */
/*                                   Modules                                  */
/* -------------------------------------------------------------------------- */
module "eks_cluster" {
  source = "../../modules/services/eks-cluster"

  # Module variables
  name         = "example-eks-cluster"
  min_size     = 1
  max_size     = 2
  desired_size = 1

  # Due to the way EKS works with ENIs, t3.small is the smallest 
  # instance type that can be used for worker nodes. If you try 
  # something smaller like t2.micro, which only has 4 ENIs, 
  # they'll all be used up by system services (e.g., kube-proxy) 
  # and you won't be able to deploy your own Pods.
  instance_types = ["t3.small"]
}

module "simple_webapp" {
  source = "../../modules/services/k8s-app-local"

  name           = "simple-webapp"
  image          = "training/webapp"
  replicas       = 2
  container_port = 5000

  environment_variables = {
    PROVIDER = "Hello, from Kubernetes cluster with love."
  }

  depends_on = [
    module.eks_cluster
  ]
}