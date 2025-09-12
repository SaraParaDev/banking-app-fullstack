# Backend Spring Boot Banking Application

This is the backend for the banking application. It provides REST APIs for user CRUD operations and audit logging.

## Features
- User CRUD (Create, Read, Update, Delete)
- Audit log for update/delete
- Swagger API documentation
- PostgreSQL integration
- Google Cloud SQL integration

## Google Cloud Platform (GCP) Connectivity

### Overview
This application is configured to connect to Google Cloud SQL PostgreSQL instance for production deployment. The setup includes automated scripts for creating and configuring the cloud database infrastructure.

### Cloud SQL Configuration

#### Database Details
- **Instance Name**: `banking-db`
- **Database Engine**: PostgreSQL 15
- **Database Name**: `banking_app`
- **Region**: `us-central1`
- **Tier**: `db-f1-micro` (suitable for development/testing)

#### Connection Details
- **Username**: `banking_user`
- **Public IP**: `34.68.6.208` (configured for external access)
- **Port**: `5432`
- **JDBC URL**: `jdbc:postgresql://34.68.6.208:5432/banking_app`

### Setup Scripts

The project includes automated PowerShell scripts for GCP setup:

#### 1. Initial Setup Script (`setup-cloudsql.ps1`)
```powershell
.\setup-cloudsql.ps1
```
This script:
- Creates the Cloud SQL PostgreSQL instance
- Enables required GCP APIs (SQL Admin API, Compute Engine API)
- Configures instance settings (backup, maintenance windows)
- Sets up networking and security

#### 2. Completion Setup Script (`complete-cloudsql-setup.ps1`)
```powershell
.\complete-cloudsql-setup.ps1
```
This script:
- Creates the application database (`banking_app`)
- Creates the database user (`banking_user`)
- Provides connection details for application configuration

### Database Schema

The application uses the following tables:

#### Users Table
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    account_number VARCHAR(20) UNIQUE NOT NULL,
    credit_limit NUMERIC(15,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Audit Table
```sql
CREATE TABLE audit (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    operation VARCHAR(10), -- UPDATE or DELETE
    old_data JSONB,
    new_data JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Application Configuration

The Spring Boot application is configured to use Cloud SQL via `application.yaml`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://34.68.6.208:5432/banking_app?connectTimeout=30&socketTimeout=30
    username: banking_user
    password: SecureBankingPassword123!
    driver-class-name: org.postgresql.Driver
    hikari:
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
      maximum-pool-size: 5
      minimum-idle: 1
```

### Security Configuration

#### Network Security
- Cloud SQL instance configured with authorized networks
- SSL/TLS encryption for data in transit
- Private IP networking available for enhanced security

#### Access Control
- Dedicated database user with limited privileges
- Strong password authentication
- IAM integration available for enhanced security

### Deployment Steps

1. **Prerequisites**
   - Google Cloud SDK installed and authenticated
   - Active GCP project with billing enabled
   - PowerShell execution policy set to allow script execution

2. **Database Setup**
   ```powershell
   # Run the setup script
   .\setup-cloudsql.ps1
   
   # Wait for completion, then run
   .\complete-cloudsql-setup.ps1
   ```

3. **Schema Deployment**
   ```bash
   # Connect to Cloud SQL
   gcloud sql connect banking-db --user=banking_user --database=banking_app
   
   # Run schema file
   \i schema.sql
   ```

4. **Application Startup**
   ```bash
   mvn spring-boot:run
   ```

### Connection Testing

Verify the connection by:
1. Starting the application (`mvn spring-boot:run`)
2. Accessing Swagger UI at `http://localhost:8080/swagger-ui.html`
3. Testing the `/api/users` endpoint

### Troubleshooting

#### Common Issues

1. **Connection Timeout**
   - Verify authorized networks configuration
   - Check firewall rules
   - Ensure Cloud SQL instance is running

2. **Authentication Failures**
   - Verify username/password
   - Check user permissions in Cloud SQL

3. **JSONB Type Issues**
   - Ensure audit table uses proper JSONB data types
   - Verify Hibernate JSONB type handling

#### Monitoring

- Cloud SQL instance metrics available in GCP Console
- Application logs show detailed connection information
- HikariCP connection pool metrics logged

### Cost Optimization

- `db-f1-micro` tier provides cost-effective development environment
- Automated backups configured for data protection
- Instance can be stopped when not in use to minimize costs

## Swagger documentation
http://localhost:8080/swagger-ui/index.html#/
