# Deploy Banking Backend to Google Cloud Run
# This script builds and deploys the Spring Boot application to Cloud Run

param(
    [string]$ProjectId = "banking-app-fullstack",
    [string]$Region = "us-central1",
    [string]$ServiceName = "banking-backend",
    [string]$ImageName = "gcr.io/$ProjectId/$ServiceName",
    [string]$DatabasePassword = "",
    [switch]$Help
)

if ($Help) {
    Write-Host "Deploy Banking Backend to Google Cloud Run"
    Write-Host ""
    Write-Host "Usage: .\deploy-cloudrun.ps1 [options]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -ProjectId <string>        GCP Project ID (default: banking-app-fullstack)"
    Write-Host "  -Region <string>           GCP Region (default: us-central1)"
    Write-Host "  -ServiceName <string>      Cloud Run service name (default: banking-backend)"
    Write-Host "  -ImageName <string>        Docker image name (default: gcr.io/PROJECT_ID/SERVICE_NAME)"
    Write-Host "  -DatabasePassword <string> Database password for Cloud SQL"
    Write-Host "  -Help                      Show this help message"
    Write-Host ""
    Write-Host "Example:"
    Write-Host "  .\deploy-cloudrun.ps1 -DatabasePassword 'your-secure-password'"
    exit 0
}

# Colors for output
$Green = [System.Console]::ForegroundColor = 'Green'
$Red = [System.Console]::ForegroundColor = 'Red'
$Yellow = [System.Console]::ForegroundColor = 'Yellow'
$White = [System.Console]::ForegroundColor = 'White'

function Write-Step {
    param([string]$Message)
    [System.Console]::ForegroundColor = 'Cyan'
    Write-Host "🔄 $Message"
    [System.Console]::ForegroundColor = 'White'
}

function Write-Success {
    param([string]$Message)
    [System.Console]::ForegroundColor = 'Green'
    Write-Host "✅ $Message"
    [System.Console]::ForegroundColor = 'White'
}

function Write-Error {
    param([string]$Message)
    [System.Console]::ForegroundColor = 'Red'
    Write-Host "❌ $Message"
    [System.Console]::ForegroundColor = 'White'
}

function Write-Warning {
    param([string]$Message)
    [System.Console]::ForegroundColor = 'Yellow'
    Write-Host "⚠️  $Message"
    [System.Console]::ForegroundColor = 'White'
}

# Check if we're in the backend directory
if (!(Test-Path "pom.xml")) {
    Write-Error "This script must be run from the backend directory containing pom.xml"
    exit 1
}

# Prompt for database password if not provided
if ([string]::IsNullOrEmpty($DatabasePassword)) {
    $DatabasePassword = Read-Host -Prompt "Enter the database password for banking_user" -AsSecureString
    $DatabasePassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DatabasePassword))
}

Write-Host "🚀 Deploying Banking Backend to Google Cloud Run" -ForegroundColor Cyan
Write-Host "Project ID: $ProjectId"
Write-Host "Region: $Region"
Write-Host "Service Name: $ServiceName"
Write-Host "Image Name: $ImageName"
Write-Host ""

# Step 1: Set the project
Write-Step "Setting GCP project to $ProjectId"
gcloud config set project $ProjectId
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to set project. Make sure you're authenticated with gcloud."
    exit 1
}
Write-Success "Project set successfully"

# Step 2: Enable required APIs
Write-Step "Enabling required Google Cloud APIs"
$apis = @(
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "containerregistry.googleapis.com"
)

foreach ($api in $apis) {
    Write-Host "  Enabling $api..."
    gcloud services enable $api --quiet
}
Write-Success "APIs enabled successfully"

# Step 3: Build the application
Write-Step "Building Spring Boot application"
mvn clean package -DskipTests
if ($LASTEXITCODE -ne 0) {
    Write-Error "Maven build failed"
    exit 1
}
Write-Success "Application built successfully"

# Step 4: Build Docker image
Write-Step "Building Docker image: $ImageName"
docker build -t $ImageName .
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker build failed"
    exit 1
}
Write-Success "Docker image built successfully"

# Step 5: Push image to Google Container Registry
Write-Step "Pushing image to Google Container Registry"
docker push $ImageName
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker push failed. Make sure Docker is configured for GCR."
    Write-Host "Run: gcloud auth configure-docker"
    exit 1
}
Write-Success "Image pushed successfully"

# Step 6: Deploy to Cloud Run
Write-Step "Deploying to Cloud Run"

# Get Cloud SQL instance connection name
$connectionName = "$ProjectId:$Region:banking-db"

$deployCmd = @(
    "gcloud", "run", "deploy", $ServiceName,
    "--image=$ImageName",
    "--platform=managed",
    "--region=$Region",
    "--allow-unauthenticated",
    "--port=8080",
    "--memory=1Gi",
    "--cpu=1",
    "--min-instances=0",
    "--max-instances=10",
    "--timeout=300",
    "--add-cloudsql-instances=$connectionName",
    "--set-env-vars=DATABASE_URL=jdbc:postgresql:///banking_app?cloudSqlInstance=$connectionName&socketFactory=com.google.cloud.sql.postgres.SocketFactory",
    "--set-env-vars=DATABASE_USERNAME=banking_user",
    "--set-env-vars=DATABASE_PASSWORD=$DatabasePassword",
    "--set-env-vars=SPRING_PROFILES_ACTIVE=prod"
)

& $deployCmd[0] $deployCmd[1..($deployCmd.Length-1)]

if ($LASTEXITCODE -ne 0) {
    Write-Error "Cloud Run deployment failed"
    exit 1
}

Write-Success "Application deployed successfully to Cloud Run!"

# Step 7: Get the service URL
Write-Step "Getting service URL"
$serviceUrl = gcloud run services describe $ServiceName --region=$Region --format="value(status.url)"

if ($serviceUrl) {
    Write-Success "Deployment completed successfully!"
    Write-Host ""
    Write-Host "🌐 Service URL: $serviceUrl" -ForegroundColor Green
    Write-Host "🏥 Health Check: $serviceUrl/actuator/health" -ForegroundColor Green
    Write-Host "📖 API Docs: $serviceUrl/swagger-ui.html" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔧 Testing the deployment:"
    Write-Host "  curl $serviceUrl/actuator/health"
    Write-Host "  curl $serviceUrl/api/users"
} else {
    Write-Warning "Could not retrieve service URL. Check Cloud Run console."
}

Write-Host ""
Write-Host "🎉 Deployment completed!" -ForegroundColor Green