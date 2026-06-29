package com.exam.payment_service.DTO;


import java.util.List;

public record PayFacturesRequest(
        List<String> factureReferences
) {
}