package terraform.tagging

import future.keywords.if
import future.keywords.contains

import input as tfplan

# List of resources that should have tags
resource_types := [
    "aws_instance",
    "aws_elb",
    "aws_security_group",
    "aws_autoscaling_group"
]

deny contains msg if {
    resource := tfplan.resource_changes[_]
    resource.mode == "managed"
    resource.type == resource_types[_]
    
    # Check for Cost-Center tag
    not has_tag(resource, "Cost-Center")
    msg := sprintf("Resource %v is missing the mandatory 'Cost-Center' tag", [resource.address])
}

deny contains msg if {
    resource := tfplan.resource_changes[_]
    resource.mode == "managed"
    resource.type == resource_types[_]
    
    # Check for Environment tag
    not has_tag(resource, "Environment")
    msg := sprintf("Resource %v is missing the mandatory 'Environment' tag", [resource.address])
}

has_tag(resource, tag_name) if {
    # For most resources
    resource.change.after.tags[tag_name]
}

has_tag(resource, tag_name) if {
    # For ASG which uses a list of tag blocks
    resource.type == "aws_autoscaling_group"
    tag := resource.change.after.tag[_]
    tag.key == tag_name
}
