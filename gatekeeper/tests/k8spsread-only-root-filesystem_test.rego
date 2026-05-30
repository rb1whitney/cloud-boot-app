package k8spsreadonlyrootfilesystem

test_read_only_fs_denied if {
    mock_input := {
        "review": {
            "object": {
                "spec": {
                    "template": {
                        "spec": {
                            "containers": [{
                                "name": "bad-pod",
                                "securityContext": {"readOnlyRootFilesystem": false}
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

test_read_only_fs_allowed if {
    mock_input := {
        "review": {
            "object": {
                "spec": {
                    "template": {
                        "spec": {
                            "containers": [{
                                "name": "good-pod",
                                "securityContext": {"readOnlyRootFilesystem": true}
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
