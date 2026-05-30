package com.dataservice.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/* Custom Exception for Spring Boot Example */

@ResponseStatus(value = HttpStatus.NOT_FOUND, reason = "Resource is not found and unable to act upon it")
public class ResourceNotFoundException extends RuntimeException {
}
