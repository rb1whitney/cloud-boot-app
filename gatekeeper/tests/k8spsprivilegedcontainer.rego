package k8spsprivilegedcontainer

violation contains {"msg": msg, "details": {}} if {
    c := input_containers[_]
    c.securityContext.privileged
    msg := sprintf("Privileged container is not allowed: %v, securityContext: %v", [c.name, c.securityContext])
}

input_containers contains c if {
    c := input.review.object.spec.template.spec.containers[_]
}
input_containers contains c if {
    c := input.review.object.spec.template.spec.initContainers[_]
}
input_containers contains c if {
    c := input.review.object.spec.template.spec.ephemeralContainers[_]
}
