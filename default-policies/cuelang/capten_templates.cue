apiVersion: "apiextensions.crossplane.io/v1"
kind:       "Composition"
metadata: {
	name: "cluster-aws"
	labels: {
		provider: "aws"
		cluster:  "eks"
	}
}
spec: {
	compositeTypeRef: {
		apiVersion: "prodready.cluster/v1alpha1"
		kind:       "CompositeCluster"
	}
	writeConnectionSecretsToNamespace: "crossplane"
	patchSets: [{
		name: "metadata"
		patches: [{
			fromFieldPath: "metadata.labels"
		}]
	}]
	resources: [{
		name: "ekscluster"
		base: {
			apiVersion: "eks.aws.crossplane.io/v1beta1"
			kind:       "Cluster"
			spec: forProvider: {
				region:  "us-east-1"
				version: "1.27"
				roleArnSelector: matchControllerRef: true
				resourcesVpcConfig: {
					endpointPrivateAccess: true
					endpointPublicAccess:  true
					subnetIdSelector: matchControllerRef: true
				}
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
		}, {
			fromFieldPath: "spec.parameters.version"
			toFieldPath:   "spec.forProvider.version"
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "spec.writeConnectionSecretToRef.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-cluster"
			}]
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "spec.forProvider.roleArnSelector.matchLabels.role"
			transforms: [{
				type: "string"
				string: fmt: "%s-controlplane"
			}]
		}, {
			type:          "ToCompositeFieldPath"
			fromFieldPath: "metadata.name"
			toFieldPath:   "status.clusterName"
		}, {
			type:          "ToCompositeFieldPath"
			fromFieldPath: "status.atProvider.status"
			toFieldPath:   "status.controlPlaneStatus"
		}, {
			fromFieldPath: "spec.writeConnectionSecretToRef.namespace"
			toFieldPath:   "spec.writeConnectionSecretToRef.namespace"
		}]
		readinessChecks: [{
			type:        "MatchString"
			fieldPath:   "status.atProvider.status"
			matchString: "ACTIVE"
		}]
		connectionDetails: [{
			fromConnectionSecretKey: "kubeconfig"
		}]
	}, {
		name: "eksnodegroup"
		base: {
			apiVersion: "eks.aws.crossplane.io/v1alpha1"
			kind:       "NodeGroup"
			spec: forProvider: {
				region: "us-east-1"
				clusterNameSelector: matchControllerRef: true
				nodeRoleSelector: matchControllerRef: true
				subnetSelector: matchLabels: access: "public"
				scalingConfig: {
					minSize:     1
					maxSize:     10
					desiredSize: 1
				}
				instanceTypes: [
					"t3.small",
				]
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
		}, {
			fromFieldPath: "spec.parameters.nodeSize"
			toFieldPath:   "spec.forProvider.instanceTypes[0]"
			transforms: [{
				type: "map"
				map: {
					small:  "t3.small"
					medium: "t3.medium"
					large:  "t3.large"
				}
			}]
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "spec.forProvider.nodeRoleSelector.matchLabels.role"
			transforms: [{
				type: "string"
				string: fmt: "%s-nodegroup"
			}]
		}, {
			fromFieldPath: "spec.parameters.minNodeCount"
			toFieldPath:   "spec.forProvider.scalingConfig.minSize"
		}, {
			fromFieldPath: "spec.parameters.minNodeCount"
			toFieldPath:   "spec.forProvider.scalingConfig.desiredSize"
		}, {
			type:          "ToCompositeFieldPath"
			fromFieldPath: "status.atProvider.status"
			toFieldPath:   "status.nodePoolStatus"
		}]
		readinessChecks: [{
			type:        "MatchString"
			fieldPath:   "status.atProvider.status"
			matchString: "ACTIVE"
		}]
	}, {
		name: "iamrole-controlplane"
		base: {
			apiVersion: "iam.aws.crossplane.io/v1beta1"
			kind:       "Role"
			spec: forProvider: assumeRolePolicyDocument: """
				{
				  "Version": "2012-10-17",
				  "Statement": [
				      {
				          "Effect": "Allow",
				          "Principal": {
				              "Service": [
				                  "eks.amazonaws.com"
				              ]
				          },
				          "Action": [
				              "sts:AssumeRole"
				          ]
				      }
				  ]
				}

				"""
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-controlplane"
			}]
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.labels.role"
			transforms: [{
				type: "string"
				string: fmt: "%s-controlplane"
			}]
		}]
	}, {
		name: "iamrole-nodegroup"
		base: {
			apiVersion: "iam.aws.crossplane.io/v1beta1"
			kind:       "Role"
			spec: forProvider: assumeRolePolicyDocument: """
				{
				  "Version": "2012-10-17",
				  "Statement": [
				      {
				          "Effect": "Allow",
				          "Principal": {
				              "Service": [
				                  "ec2.amazonaws.com"
				              ]
				          },
				          "Action": [
				              "sts:AssumeRole"
				          ]
				      }
				  ]
				}

				"""
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-nodegroup"
			}]
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.labels.role"
			transforms: [{
				type: "string"
				string: fmt: "%s-nodegroup"
			}]
		}]
	}, {
		name: "iamattachment-controlplane"
		base: {
			apiVersion: "iam.aws.crossplane.io/v1beta1"
			kind:       "RolePolicyAttachment"
			spec: forProvider: {
				policyArn: "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
				roleNameSelector: matchControllerRef: true
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-controlplane"
			}]
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "spec.forProvider.roleNameSelector.matchLabels.role"
			transforms: [{
				type: "string"
				string: fmt: "%s-controlplane"
			}]
		}]
	}, {
		name: "iamattachment-service"
		base: {
			apiVersion: "iam.aws.crossplane.io/v1beta1"
			kind:       "RolePolicyAttachment"
			spec: forProvider: {
				policyArn: "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
				roleNameSelector: matchControllerRef: true
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-service"
			}]
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "spec.forProvider.roleNameSelector.matchLabels.role"
			transforms: [{
				type: "string"
				string: fmt: "%s-controlplane"
			}]
		}]
	}, {
		name: "iamattachment-worker"
		base: {
			apiVersion: "iam.aws.crossplane.io/v1beta1"
			kind:       "RolePolicyAttachment"
			spec: forProvider: {
				policyArn: "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
				roleNameSelector: matchControllerRef: true
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-worker"
			}]
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "spec.forProvider.roleNameSelector.matchLabels.role"
			transforms: [{
				type: "string"
				string: fmt: "%s-nodegroup"
			}]
		}]
	}, {
		name: "iamattachment-cni"
		base: {
			apiVersion: "iam.aws.crossplane.io/v1beta1"
			kind:       "RolePolicyAttachment"
			spec: forProvider: {
				policyArn: "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
				roleNameSelector: matchControllerRef: true
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-cni"
			}]
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "spec.forProvider.roleNameSelector.matchLabels.role"
			transforms: [{
				type: "string"
				string: fmt: "%s-nodegroup"
			}]
		}]
	}, {
		name: "iamattachment-registry"
		base: {
			apiVersion: "iam.aws.crossplane.io/v1beta1"
			kind:       "RolePolicyAttachment"
			spec: forProvider: {
				policyArn: "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
				roleNameSelector: matchControllerRef: true
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-registry"
			}]
		}, {
			fromFieldPath: "spec.id"
			toFieldPath:   "spec.forProvider.roleNameSelector.matchLabels.role"
			transforms: [{
				type: "string"
				string: fmt: "%s-nodegroup"
			}]
		}]
	}, {
		name: "vpc-nodepool"
		base: {
			apiVersion: "ec2.aws.crossplane.io/v1beta1"
			kind:       "VPC"
			spec: forProvider: {
				region:           "us-east-1"
				cidrBlock:        "10.0.0.0/16"
				enableDnsSupport: true
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
		}]
	}, {
		name: "sg-nodepool"
		base: {
			apiVersion: "ec2.aws.crossplane.io/v1beta1"
			kind:       "SecurityGroup"
			spec: forProvider: {
				description: "Cluster communication with worker nodes"
				groupName:   "devops-catalog"
				region:      "us-east-1"
				vpcIdSelector: matchControllerRef: true
				egress: [{
					fromPort:   0
					toPort:     0
					ipProtocol: "-1"
					ipRanges: [{
						cidrIp: "0.0.0.0/0"
					}]
				}]
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
		}]
	}, {
		name: "subnet-nodepool-1a"
		base: {
			apiVersion: "ec2.aws.crossplane.io/v1beta1"
			kind:       "Subnet"
			metadata: labels: {
				zone:   "us-east-1a"
				access: "public"
			}
			spec: forProvider: {
				region:           "us-east-1"
				availabilityZone: "us-east-1a"
				cidrBlock:        "10.0.0.0/24"
				vpcIdSelector: matchControllerRef: true
				mapPublicIPOnLaunch: true
				tags: [{
					key:   "kubernetes.io/role/elb"
					value: "1"
				}]
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-1a"
			}]
		}]
	}, {
		name: "subnet-nodepool-1b"
		base: {
			apiVersion: "ec2.aws.crossplane.io/v1beta1"
			kind:       "Subnet"
			metadata: labels: {
				zone:   "us-east-1b"
				access: "public"
			}
			spec: forProvider: {
				region:           "us-east-1"
				availabilityZone: "us-east-1b"
				cidrBlock:        "10.0.1.0/24"
				vpcIdSelector: matchControllerRef: true
				mapPublicIPOnLaunch: true
				tags: [{
					key:   "kubernetes.io/role/elb"
					value: "1"
				}]
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-1b"
			}]
		}]
	}, {
		name: "subnet-nodepool-1c"
		base: {
			apiVersion: "ec2.aws.crossplane.io/v1beta1"
			kind:       "Subnet"
			metadata: labels: {
				zone:   "us-east-1c"
				access: "public"
			}
			spec: forProvider: {
				region:           "us-east-1"
				availabilityZone: "us-east-1c"
				cidrBlock:        "10.0.2.0/24"
				vpcIdSelector: matchControllerRef: true
				mapPublicIPOnLaunch: true
				tags: [{
					key:   "kubernetes.io/role/elb"
					value: "1"
				}]
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
			transforms: [{
				type: "string"
				string: fmt: "%s-1c"
			}]
		}]
	}, {
		name: "gateway"
		base: {
			apiVersion: "ec2.aws.crossplane.io/v1beta1"
			kind:       "InternetGateway"
			spec: forProvider: {
				region: "us-east-1"
				vpcIdSelector: matchControllerRef: true
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
		}]
	}, {
		name: "routetable"
		base: {
			apiVersion: "ec2.aws.crossplane.io/v1beta1"
			kind:       "RouteTable"
			spec: forProvider: {
				region: "us-east-1"
				vpcIdSelector: matchControllerRef: true
				routes: [{
					destinationCidrBlock: "0.0.0.0/0"
					gatewayIdSelector: matchControllerRef: true
				}]
				associations: [{
					subnetIdSelector: {
						matchControllerRef: true
						matchLabels: {
							zone:   "us-east-1a"
							access: "public"
						}
					}
				}, {
					subnetIdSelector: {
						matchControllerRef: true
						matchLabels: {
							zone:   "us-east-1b"
							access: "public"
						}
					}
				}, {
					subnetIdSelector: {
						matchControllerRef: true
						matchLabels: {
							zone:   "us-east-1c"
							access: "public"
						}
					}
				}]
			}
		}
		patches: [{
			fromFieldPath: "spec.id"
			toFieldPath:   "metadata.name"
		}]
	}]
}