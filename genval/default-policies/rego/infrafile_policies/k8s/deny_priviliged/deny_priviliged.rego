package validate_k8s

import rego.v1

deny_priviliged_pod contains msg if {
	input.kind == "Deployment"
	podSpec := input.spec.template.spec.securityContext

	not podSpec.priviliged
    msg:= "Deployment does not use priviliged pod"
}