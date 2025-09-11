package com.example.banking.controller;

import com.example.banking.model.Audit;
import com.example.banking.repository.AuditRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/audit")
public class AuditController {
    @Autowired
    private AuditRepository auditRepository;

    @GetMapping
    public List<Audit> getAllAudits() {
        return auditRepository.findAll();
    }
}
