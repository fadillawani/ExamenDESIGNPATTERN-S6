package com.exam.badwallet_api.DTO;

import java.util.List;

public record PaySpecificFacturesProxyRequest(
        List<String> factureReferences
) {
}