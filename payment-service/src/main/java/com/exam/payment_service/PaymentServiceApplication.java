package com.exam.payment_service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.exam.payment_service.Repository.FactureRepository;
import com.exam.payment_service.Data.Facture;


import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;

import java.math.BigDecimal;
import java.time.LocalDate;

@SpringBootApplication
public class PaymentServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(PaymentServiceApplication.class, args);
    }

    @Bean
    CommandLineRunner seedFactures(FactureRepository factureRepository) {
        return args -> {
            if (factureRepository.count() == 0) {
                for (int i = 1; i <= 10; i++) {
                    String walletCode = String.format("WLT-%07d", i);

                    factureRepository.save(Facture.builder()
                            .reference("FAC-ISM-" + i + "-1")
                            .walletCode(walletCode)
                            .serviceName("ISM")
                            .unite("ISM")
                            .amount(BigDecimal.valueOf(5000))
                            .dueDate(LocalDate.of(2026, 6, 10))
                            .paid(false)
                            .build());

                    factureRepository.save(Facture.builder()
                            .reference("FAC-ISM-" + i + "-3")
                            .walletCode(walletCode)
                            .serviceName("WOYAFAL")
                            .unite("WOYAFAL")
                            .amount(BigDecimal.valueOf(3000))
                            .dueDate(LocalDate.of(2026, 6, 20))
                            .paid(false)
                            .build());
                }
            }
        };
    }
}
