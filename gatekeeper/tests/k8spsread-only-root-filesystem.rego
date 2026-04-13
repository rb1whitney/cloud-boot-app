package k8spsreadonlyrootfilesystem

violation contains {"msg": msg, "details": {}} if {
    c := input_containers[_]
    not c.securityContext.readOnlyRootFilesystem
    msg := sprintf("Only read-only root filesystem is allowed: %v", [c.name])
}

input_containers contains c if {
    c := input.review.object.spec.template.spec.containers[_]
}
