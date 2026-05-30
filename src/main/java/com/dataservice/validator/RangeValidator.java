package com.dataservice.validator;

import java.util.List;
import java.util.regex.Pattern;

public class RangeValidator {

    // Simple alphanumeric sanitizer to prevent injection in this context
    private static final Pattern ALPHANUMERIC = Pattern.compile("^[a-zA-Z0-9\\s\\-_.]*$");

    public static void validate(RangeCondition condition, List<String> values) {
        if (condition == null) {
            throw new IllegalArgumentException("Condition cannot be null");
        }

        if (values == null || values.isEmpty()) {
            throw new IllegalArgumentException("Values list cannot be null or empty");
        }

        for (String value : values) {
            if (value == null || !ALPHANUMERIC.matcher(value).matches()) {
                throw new IllegalArgumentException("Invalid input value: " + value);
            }
        }

        int requiredSize = (condition == RangeCondition.BETWEEN) ? 2 : 1;

        if (values.size() != requiredSize) {
            throw new IllegalArgumentException(
                String.format("Condition %s requires exactly %d value(s), but %d provided", 
                condition, requiredSize, values.size())
            );
        }
    }
}
