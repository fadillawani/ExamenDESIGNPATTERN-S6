package com.exam.payment_service.Data;


import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Facture {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String reference;
    private String walletCode;
    private String serviceName;
    private String unite;
    private BigDecimal amount;
    private LocalDate dueDate;
    private boolean paid;
}