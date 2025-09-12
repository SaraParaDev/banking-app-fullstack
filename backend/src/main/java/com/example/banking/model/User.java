package com.example.banking.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String address;
    @Column(name = "account_number", unique = true)
    private String accountNumber;
    @Column(name = "credit_limit")
    private BigDecimal creditLimit;
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @PrePersist
    public void prePersist() {
        if (accountNumber == null || accountNumber.isEmpty()) {
            accountNumber = generateRandomAccountNumber();
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }
    public BigDecimal getCreditLimit() { return creditLimit; }
    public void setCreditLimit(BigDecimal creditLimit) { this.creditLimit = creditLimit; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    /** Generates a random account number. */
    private String generateRandomAccountNumber() {
        StringBuilder sb = new StringBuilder();
        sb.append("ACC"); // Prefix for better readability
        for (int i = 0; i < 6; i++) {
            sb.append((int)(Math.random() * 10));
        }
        return sb.toString();
    }
}
