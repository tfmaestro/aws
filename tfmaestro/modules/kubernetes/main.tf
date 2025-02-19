data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name" 
    values = ["prod-vpc"]
  }
}

data "aws_subnet" "public_subnet" {
  for_each = toset([
    "prod-public-subnet-01",
    "prod-public-subnet-02"
  ])
  filter {
    name   = "tag:Name" 
    values = [each.key]
  }
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_iam_role" "eks_role" {
  for_each = toset([for i in range(var.cluster_count) : "${var.cluster_name}-0${i + 1}"])

  name = each.key

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "eks_role_policy" {
  for_each   = aws_iam_role.eks_role
  name       = "${each.key}-policy-01"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [each.value.name]
}

resource "aws_iam_role" "nodes" {
  name = "eks-node-role-01"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_cluster" "primary" {
  for_each = aws_iam_role.eks_role
  name     = each.key
  role_arn = each.value.arn
  
  vpc_config {
    subnet_ids = [for subnet in data.aws_subnet.public_subnet : subnet.id]
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = var.trusted_ip_range
  }

  version = var.k8s_version
}

resource "aws_eks_node_group" "primary_node_group" {
  for_each = aws_eks_cluster.primary

  cluster_name    = each.value.name
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = [for subnet in data.aws_subnet.public_subnet : subnet.id]
  node_group_name = "${each.value.name}-node"

  scaling_config {
    desired_size = var.node_min_count
    min_size     = var.node_min_count
    max_size     = var.node_max_count
  }
  instance_types = ["t3.micro"]
  ami_type       = "AL2_x86_64"

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}