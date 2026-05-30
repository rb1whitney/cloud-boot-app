package regionalsovereignty

test_unauthorized_region_denied if {
    mock_input := {
        "review": {
            "object": {
                "metadata": {
                    "annotations": {
                        "cloud-boot-app.io/region": "us-west-2"
                    }
                }
            }
        },
        "parameters": {
            "allowed_regions": ["us-east-1"]
        }
    }
    results := violation with input as mock_input
    count(results) == 1
}

test_authorized_region_allowed if {
    mock_input := {
        "review": {
            "object": {
                "metadata": {
                    "annotations": {
                        "cloud-boot-app.io/region": "us-east-1"
                    }
                }
            }
        },
        "parameters": {
            "allowed_regions": ["us-east-1"]
        }
    }
    results := violation with input as mock_input
    count(results) == 0
}
