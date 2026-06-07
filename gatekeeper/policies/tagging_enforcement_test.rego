package terraform.tagging

import future.keywords.if

test_deny_missing_cost_center if {
    plan := {
        "resource_changes": [
            {
                "address": "aws_instance.test",
                "mode": "managed",
                "type": "aws_instance",
                "change": {
                    "after": {
                        "tags": {
                            "Environment": "prod"
                        }
                    }
                }
            }
        ]
    }
    deny["Resource aws_instance.test is missing the mandatory 'Cost-Center' tag"] with input as plan
}

test_deny_missing_environment if {
    plan := {
        "resource_changes": [
            {
                "address": "aws_instance.test",
                "mode": "managed",
                "type": "aws_instance",
                "change": {
                    "after": {
                        "tags": {
                            "Cost-Center": "12345"
                        }
                    }
                }
            }
        ]
    }
    deny["Resource aws_instance.test is missing the mandatory 'Environment' tag"] with input as plan
}

test_allow_compliant_resource if {
    plan := {
        "resource_changes": [
            {
                "address": "aws_instance.test",
                "mode": "managed",
                "type": "aws_instance",
                "change": {
                    "after": {
                        "tags": {
                            "Cost-Center": "12345",
                            "Environment": "prod"
                        }
                    }
                }
            }
        ]
    }
    count(deny) == 0 with input as plan
}

test_allow_compliant_asg if {
    plan := {
        "resource_changes": [
            {
                "address": "aws_autoscaling_group.test",
                "mode": "managed",
                "type": "aws_autoscaling_group",
                "change": {
                    "after": {
                        "tag": [
                            {"key": "Cost-Center", "value": "12345"},
                            {"key": "Environment", "value": "prod"}
                        ]
                    }
                }
            }
        ]
    }
    count(deny) == 0 with input as plan
}
