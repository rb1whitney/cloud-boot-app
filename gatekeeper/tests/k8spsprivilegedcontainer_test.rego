package k8spsprivilegedcontainer

test_privileged_container_denied if {
    mock_input := {
        "review": {
            "object": {
                "spec": {
                    "template": {
                        "spec": {
                            "containers": [{
                                "name": "bad-pod",
                                "securityContext": {"privileged": true}
                            }]
                        }
                    }
                }
            }
        }
    }
    results := violation with input as mock_input
    count(results) == 1
}

test_standard_container_allowed if {
    mock_input := {
        "review": {
            "object": {
                "spec": {
                    "template": {
                        "spec": {
                            "containers": [{
                                "name": "good-pod",
                                "securityContext": {"privileged": false}
                            }]
                        }
                    }
                }
            }
        }
    }
    results := violation with input as mock_input
    count(results) == 0
}
