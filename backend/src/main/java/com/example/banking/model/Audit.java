package com.example.banking.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "audit")
public class Audit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id")
    private Long userId;
    private String operation; // UPDATE or DELETE
    @Column(columnDefinition = "TEXT")
    private String oldData;
    @Column(columnDefinition = "TEXT")
    private String newData;
    private LocalDateTime timestamp = LocalDateTime.now();

    public Audit() {}

    public Audit(Long id, Long userId, String operation, String oldData, String newData, LocalDateTime timestamp) {
        this.id = id;
        this.userId = userId;
        this.operation = operation;
        this.oldData = oldData;
        this.newData = newData;
        this.timestamp = timestamp != null ? timestamp : LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getOperation() { return operation; }
    public void setOperation(String operation) { this.operation = operation; }
    public String getOldData() { return oldData; }
    public void setOldData(String oldData) { this.oldData = oldData; }
    public String getNewData() { return newData; }
    public void setNewData(String newData) { this.newData = newData; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}
