package validate_k8s

import rego.v1


deny_latest_tag contains msg if {
input.kind ==	"Deployment"
c:= input.spec.template.spec.containers[i].image
endswith(c, "latest")
msg:= "Image does not use 'latest' tag"
}

