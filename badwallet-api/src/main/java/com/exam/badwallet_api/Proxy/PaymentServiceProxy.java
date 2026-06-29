package com.exam.badwallet_api.Proxy;

import lombok.RequiredArgsConstructor;

import java.math.BigDecimal;

import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import com.exam.badwallet_api.DTO.PaySpecificFacturesProxyRequest;
import com.exam.badwallet_api.DTO.PayCurrentFactureProxyRequest;
import java.util.List;


@Component
@RequiredArgsConstructor
public class PaymentServiceProxy {

    private final RestTemplate restTemplate;

    private static final String PAYMENT_SERVICE_URL = "http://localhost:8081/api/factures";

    public Object payCurrentFacture(String walletCode, String serviceName, BigDecimal amount) {
    String url = PAYMENT_SERVICE_URL + "/pay-current";

    PayCurrentFactureProxyRequest request =
            new PayCurrentFactureProxyRequest(walletCode, serviceName, amount);

    return restTemplate.postForObject(url, request, Object.class);
    }
    public Object paySpecificFactures(List<String> factureReferences) {
        String url = PAYMENT_SERVICE_URL + "/pay-specific";

        PaySpecificFacturesProxyRequest request =
                new PaySpecificFacturesProxyRequest(factureReferences);

        return restTemplate.postForObject(url, request, Object.class);
    }
}