# EKS (Elastic Kubernetes Service)

Amazon EKS simplifies building, securing, and maintaining Kubernetes clusters. It can be more cost effective at providing enough resources to meet peak demand than maintaining your own data centers. Two of the main approaches to using Amazon EKS are as follows:

**EKS standard:** AWS manages the [Kubernetes control plane](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components) when you create a cluster with EKS. Components that manage nodes, schedule workloads, integrate with the AWS cloud, and store and scale control plane information to keep your clusters up and running, are handled for you automatically.

**EKS Auto Mode:** Using the [EKS Auto Mode](https://docs.aws.amazon.com/eks/latest/userguide/automode.html) feature, EKS extends its control to manage [Nodes](https://kubernetes.io/docs/concepts/overview/components/#node-components) (Kubernetes data plane) as well. It simplifies Kubernetes management by automatically provisioning infrastructure, selecting optimal compute instances, dynamically scaling resources, continuously optimizing costs, patching operating systems, and integrating with AWS security services.

For more information, see the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html).