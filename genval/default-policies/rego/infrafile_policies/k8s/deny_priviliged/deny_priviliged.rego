package validate_k8s

import rego.v1

deny_priviliged_pod contains msg if {
	input.kind == "Deployment"
	not input.spec.template.spec.securityContext
    msg:= "Deployment does not use priviliged pod"
}