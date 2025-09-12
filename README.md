# 🏦 Banking Application - Full Stack Cloud-Native Solution

A comprehensive full-stack banking application demonstrating modern cloud-native architecture with microservices, containerization, and serverless deployment on Google Cloud Platform.

## 🌟 Live Production Deployment

- **🚀 Backend API**: [https://banking-backend-63839693512.us-central1.run.app](https://banking-backend-63839693512.us-central1.run.app)
- **📖 API Documentation**: [Swagger UI](https://banking-backend-63839693512.us-central1.run.app/swagger-ui/index.html)
- **🔍 Health Check**: [API Health](https://banking-backend-63839693512.us-central1.run.app/actuator/health)

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│                 │    │                 │    │                 │
│   React.js      │────│   Node.js       │────│   Spring Boot   │
│   Frontend      │    │   Proxy Server  │    │   Backend API   │
│   (Port 3000)   │    │   (Port 3001)   │    │   (Cloud Run)   │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│                 │    │                 │    │                 │
│   User          │    │   Development   │    │   PostgreSQL    │
│   Interface     │    │   & Testing     │    │   Cloud SQL     │
│   (Browser)     │    │   Layer         │    │   Database      │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🎯 Technology Stack

### Frontend Layer
- **React 18.2.0** - Modern UI framework
- **TypeScript** - Type-safe development
- **Material-UI (MUI)** - Professional UI components
- **Axios** - HTTP client for API communication

### Backend Layer
- **Spring Boot 3.2.5** - Enterprise Java framework
- **Java 17** - Modern JDK with performance optimizations
- **Spring Data JPA** - Database abstraction layer
- **Swagger/OpenAPI** - API documentation
- **Spring Boot Actuator** - Production monitoring

### Database Layer
- **PostgreSQL 15** - Production-grade relational database
- **Google Cloud SQL** - Managed database service
- **HikariCP** - High-performance connection pooling
- **JSONB** - JSON data type for audit logs

### Infrastructure Layer
- **Google Cloud Run** - Serverless container platform
- **Docker** - Containerization
- **Google Cloud Build** - CI/CD pipeline
- **Google Artifact Registry** - Container registry

### Development Tools
- **Node.js/Express** - Development proxy server
- **Maven** - Java build tool
- **npm** - Node.js package manager
- **PowerShell** - Automation scripts

## 📋 Module Breakdown

### 🎨 Frontend Module (`/frontend`)
**Purpose**: User interface for banking operations  
**Technology**: React + TypeScript + Material-UI  
**Port**: 3000

```
┌─────────────────────────────────────────┐
│            React Frontend               │
├─────────────────────────────────────────┤
│  • User Registration & Management      │
│  • Account Balance Display             │
│  • Transaction History                 │
│  • Responsive Material-UI Design       │
│  • TypeScript for Type Safety          │
└─────────────────────────────────────────┘
```

**Key Components**:
- `UserForm.tsx` - User creation and editing forms
- `UserList.tsx` - Display and manage user accounts
- `App.tsx` - Main application routing and layout
- `userApi.ts` - API integration service

**Features**:
- ✅ Create new bank accounts
- ✅ View account details and balances
- ✅ Update account information
- ✅ Delete accounts with confirmation
- ✅ Real-time data validation
- ✅ Responsive design for mobile/desktop

---

### 🔧 Server Module (`/server`)
**Purpose**: Development proxy and API testing layer  
**Technology**: Node.js + Express  
**Port**: 3001

```
┌─────────────────────────────────────────┐
│           Node.js Proxy Server          │
├─────────────────────────────────────────┤
│  • Development API Proxy               │
│  • CORS Configuration                  │
│  • Error Handling & Logging            │
│  • Cloud Run API Integration           │
│  • Request/Response Monitoring         │
└─────────────────────────────────────────┘
```

**Key Features**:
- 🔄 Proxies requests to Spring Boot backend
- 🌐 CORS handling for frontend integration
- 📊 Detailed request/response logging
- ⚡ Connects to both local and cloud APIs
- 🛡️ Error handling and timeout management

**Configuration**:
```javascript
// Connects to Cloud Run production API
target: 'https://banking-backend-63839693512.us-central1.run.app'
```

---

### ⚙️ Backend Module (`/backend`)
**Purpose**: Core banking API and business logic  
**Technology**: Spring Boot + Java 17  
**Deployment**: Google Cloud Run

```
┌─────────────────────────────────────────┐
│         Spring Boot Backend API        │
├─────────────────────────────────────────┤
│  • RESTful API Endpoints               │
│  • Database Integration (JPA)          │
│  • Audit Trail System                  │
│  • Swagger API Documentation           │
│  • Cloud SQL Integration               │
│  • Health Monitoring                   │
└─────────────────────────────────────────┘
```

**API Endpoints**:
- `GET /api/users` - Retrieve all users
- `POST /api/users` - Create new user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user
- `GET /actuator/health` - Health check

**Database Schema**:
```sql
-- Users table for account management
users: id, name, address, account_number, credit_limit, created_at

-- Audit table for transaction logging
audit: id, user_id, operation, old_data, new_data, timestamp
```

---

### 🗄️ Database Module (Cloud SQL)
**Purpose**: Data persistence and audit logging  
**Technology**: PostgreSQL 15 on Google Cloud SQL  
**Instance**: `banking-app-fullstack:us-central1:banking-db`

```
┌─────────────────────────────────────────┐
│        PostgreSQL Cloud SQL            │
├─────────────────────────────────────────┤
│  • User Account Data Storage           │
│  • JSONB Audit Trail                   │
│  • Connection Pooling (HikariCP)       │
│  • Automated Backups                   │
│  • High Availability                   │
└─────────────────────────────────────────┘
```

**Features**:
- 💾 Persistent user account data
- 📝 Complete audit trail with JSONB
- 🔄 Automatic backups and point-in-time recovery
- 🛡️ SSL/TLS encryption
- ⚡ Connection pooling for performance

## 🌊 Data Flow Architecture

```
🌐 Frontend (React)          🔧 Proxy (Node.js)         ⚙️ Backend (Spring Boot)       🗄️ Database (PostgreSQL)
       │                            │                            │                            │
    Port 3000                   Port 3001                   Cloud Run                    Cloud SQL
       │                            │                            │                            │
       ▼                            ▼                            ▼                            ▼
┌─────────────┐    HTTP     ┌─────────────┐    HTTPS    ┌─────────────┐    JDBC     ┌─────────────┐
│   Browser   │────────────▶│   Express   │────────────▶│ Spring Boot │────────────▶│ PostgreSQL  │
│   React UI  │◀────────────│   Proxy     │◀────────────│     API     │◀────────────│  Database   │
└─────────────┘   JSON      └─────────────┘   JSON      └─────────────┘    SQL      └─────────────┘
       ▲                            ▲                            ▲                            ▲
       │                            │                            │                            │
   User Actions              CORS & Logging              Business Logic              Data Persistence
   UI Updates               Error Handling               Validation                 Audit Logging
   State Management         Request Proxying             Authentication             Transactions
```

## 🔄 Request Flow Sequence

```
👤 User clicks "Create Account" in React UI
           ↓
📡 React sends POST /api/users to Node.js proxy (localhost:3001)
           ↓
🔄 Express proxy forwards request to Cloud Run API
           ↓
☁️ Spring Boot receives request at Cloud Run endpoint
           ↓
🔍 Spring Boot validates request data
           ↓
💾 JPA/Hibernate saves user to PostgreSQL Cloud SQL
           ↓
📊 Automatic audit log entry created (JSONB)
           ↓
✅ Success response travels back through chain
           ↓
⚛️ React updates UI with new user data
```

## 🚀 Deployment Architecture

```
                           ☁️ Google Cloud Platform
    ┌─────────────────────────────────────────────────────────────────┐
    │                                                                 │
    │   🏗️ Cloud Build          📦 Artifact Registry                 │
    │   ├─ Docker Build         ├─ Container Images                   │
    │   ├─ CI/CD Pipeline       └─ Version Management                 │
    │   └─ Automated Deploy                                           │
    │             │                        │                         │
    │             ▼                        ▼                         │
    │   🚀 Cloud Run             🗄️ Cloud SQL                       │
    │   ├─ Serverless            ├─ PostgreSQL 15                    │
    │   ├─ Auto-scaling          ├─ Managed Service                   │
    │   ├─ Load Balancing        ├─ Automated Backups                │
    │   └─ Global CDN            └─ High Availability                 │
    │                                                                 │
    └─────────────────────────────────────────────────────────────────┘
                                   ▲
                                   │ HTTPS API Calls
                                   │
    ┌─────────────────────────────────────────────────────────────────┐
    │                    💻 Local Development                        │
    │                                                                 │
    │   ⚛️ React Frontend        🔧 Node.js Proxy                   │
    │   ├─ localhost:3000        ├─ localhost:3001                   │
    │   ├─ Material-UI           ├─ Express Server                    │
    │   ├─ TypeScript            ├─ CORS Handling                     │
    │   └─ Hot Reload            └─ Request Logging                   │
    │                                                                 │
    └─────────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start Guide

### 🌐 Access Live Application
1. **API Documentation**: Visit [Swagger UI](https://banking-backend-63839693512.us-central1.run.app/swagger-ui/index.html)
2. **Test API Endpoints**: Use the interactive Swagger interface
3. **Health Check**: [API Health Status](https://banking-backend-63839693512.us-central1.run.app/actuator/health)

### 💻 Local Development Setup

#### Prerequisites
- Node.js 16+ and npm
- Java 17+ and Maven
- Google Cloud SDK (for deployment)

#### 1. Start the Backend (Local)
```bash
cd backend
mvn spring-boot:run
# Runs on http://localhost:8080
```

#### 2. Start the Proxy Server
```bash
cd server
npm install
npm start
# Runs on http://localhost:3001
```

#### 3. Start the Frontend
```bash
cd frontend
npm install
npm start
# Runs on http://localhost:3000
```

## 📊 Project Structure

```
banking-app-fullstack/
├── 📁 backend/                 # Spring Boot API
│   ├── 📁 src/main/java/       # Java source code
│   ├── 📁 src/main/resources/  # Configuration files
│   ├── 🐳 Dockerfile           # Container configuration
│   ├── 📄 pom.xml              # Maven dependencies
│   └── 📋 README.md            # Backend documentation
│
├── 📁 frontend/                # React application
│   ├── 📁 src/                 # React source code
│   ├── 📁 public/              # Static assets
│   ├── 📄 package.json         # npm dependencies
│   └── ⚙️ tsconfig.json        # TypeScript configuration
│
├── 📁 server/                  # Node.js proxy
│   ├── 📁 src/                 # Express server code
│   └── 📄 package.json         # npm dependencies
│
├── ☁️ Cloud Configuration Files
│   ├── 📄 cloudbuild.yaml     # Cloud Build pipeline
│   ├── 🔧 deploy-*.ps1        # Deployment scripts
│   └── 🛠️ setup-*.ps1         # Infrastructure setup
│
└── 📋 README.md                # This file
```

## 🔧 Available Scripts

### Backend Operations
```bash
# Build application
mvn clean package

# Run locally
mvn spring-boot:run

# Deploy to Cloud Run
gcloud run deploy banking-backend \
  --image us-central1-docker.pkg.dev/banking-app-fullstack/cloud-run-source-deploy/banking-backend:v1.0 \
  --region us-central1
```

### Frontend Operations
```bash
# Install dependencies
npm install

# Start development server
npm start

# Build for production
npm run build

# Run tests
npm test
```

### Server Operations
```bash
# Install dependencies
npm install

# Start proxy server
npm start

# Development with auto-restart
npm run dev
```

## 🎯 Key Features

### 🏦 Banking Operations
- ✅ **User Account Management** - Create, read, update, delete bank accounts
- ✅ **Account Information** - Store name, address, account number, credit limit
- ✅ **Audit Trail** - Complete transaction history with JSONB logging
- ✅ **Data Validation** - Client and server-side validation
- ✅ **Real-time Updates** - Immediate UI updates after operations

### 🛡️ Security & Reliability
- ✅ **Cloud-Native Security** - Google Cloud IAM and security policies
- ✅ **SSL/TLS Encryption** - End-to-end secure communication
- ✅ **Input Validation** - Protection against malicious data
- ✅ **Error Handling** - Comprehensive error management
- ✅ **Health Monitoring** - Application health checks and monitoring

### 🚀 Performance & Scalability
- ✅ **Auto-scaling** - Cloud Run automatically scales based on demand
- ✅ **Connection Pooling** - Optimized database connections
- ✅ **Caching** - Efficient data retrieval
- ✅ **CDN Integration** - Global content delivery
- ✅ **Serverless Architecture** - Pay-per-use cost model

## 📊 Monitoring & Analytics

### Production Monitoring
- **Cloud Run Metrics**: CPU, memory, request latency
- **Database Metrics**: Connection pool, query performance
- **API Analytics**: Request volume, error rates, response times

### Development Tools
- **Swagger UI**: Interactive API documentation
- **Spring Boot Actuator**: Health checks and metrics
- **Node.js Logging**: Detailed request/response logging

## 💡 Best Practices Implemented

### Code Quality
- **TypeScript** for type safety in frontend
- **Spring Boot** best practices for backend
- **RESTful API** design principles
- **Clean Code** principles throughout

### Infrastructure
- **Infrastructure as Code** with Cloud Build
- **Containerization** with Docker
- **Serverless Deployment** with Cloud Run
- **Managed Database** with Cloud SQL

### Security
- **Environment Variables** for sensitive configuration
- **Non-root Container** users
- **Cloud SQL Private IP** networking
- **IAM-based Access Control**

## 🔗 Useful Links

- **🚀 Live API**: [https://banking-backend-63839693512.us-central1.run.app](https://banking-backend-63839693512.us-central1.run.app)
- **📖 API Docs**: [Swagger UI](https://banking-backend-63839693512.us-central1.run.app/swagger-ui/index.html)
- **🔍 Health Check**: [API Health](https://banking-backend-63839693512.us-central1.run.app/actuator/health)
- **☁️ Google Cloud Console**: [Project Dashboard](https://console.cloud.google.com/home/dashboard?project=banking-app-fullstack)

---

## 📞 Support & Contributing

For questions, issues, or contributions, please refer to the individual module README files or create an issue in the repository.

**🌟 The banking application is now live and ready for use!** 🌟
