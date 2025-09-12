# Deploy Banking Backend to Google Cloud Run using Cloud Build
# This script uses Google Cloud Build to build and deploy the application

param(
    [string]$ProjectId = "banking-app-fullstack",
    [string]$Region = "us-central1",
    [string]$ServiceName = "banking-backend",
    [string]$DatabasePassword = "",
    [switch]$Help
)

if ($Help) {
    Write-Host "Deploy Banking Backend to Google Cloud Run using Cloud Build"
    Write-Host ""
    Write-Host "Usage: .\deploy-cloudbuild.ps1 [options]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -ProjectId <string>        GCP Project ID (default: banking-app-fullstack)"
    Write-Host "  -Region <string>           GCP Region (default: us-central1)"
    Write-Host "  -ServiceName <string>      Cloud Run service name (default: banking-backend)"
    Write-Host "  -DatabasePassword <string> Database password for Cloud SQL"
    Write-Host "  -Help                      Show this help message"
    Write-Host ""
    Write-Host "Example:"
    Write-Host "  .\deploy-cloudbuild.ps1 -DatabasePassword 'your-secure-password'"
    exit 0
}

# Colors for output
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

# Check if we're in the project root directory
if (!(Test-Path "cloudbuild.yaml")) {
    Write-Error "This script must be run from the project root directory containing cloudbuild.yaml"
    exit 1
}

# Prompt for database password if not provided
if ([string]::IsNullOrEmpty($DatabasePassword)) {
    $DatabasePassword = Read-Host -Prompt "Enter the database password for banking_user" -AsSecureString
    $DatabasePassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DatabasePassword))
}

Write-Host "🚀 Deploying Banking Backend to Google Cloud Run using Cloud Build" -ForegroundColor Cyan
Write-Host "Project ID: $ProjectId"
Write-Host "Region: $Region"
Write-Host "Service Name: $ServiceName"
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
    "containerregistry.googleapis.com",
    "secretmanager.googleapis.com"
)

foreach ($api in $apis) {
    Write-Host "  Enabling $api..."
    gcloud services enable $api --quiet
}
Write-Success "APIs enabled successfully"

# Step 3: Create or update database password secret
Write-Step "Creating database password secret in Secret Manager"
$secretExists = gcloud secrets list --filter="name:database-password" --format="value(name)" 2>$null
if ($secretExists) {
    Write-Host "  Updating existing secret..."
    echo $DatabasePassword | gcloud secrets versions add database-password --data-file=-
} else {
    Write-Host "  Creating new secret..."
    echo $DatabasePassword | gcloud secrets create database-password --data-file=-
}

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create/update database password secret"
    exit 1
}
Write-Success "Database password secret configured"

# Step 4: Grant Cloud Build access to the secret
Write-Step "Granting Cloud Build access to secrets"
$projectNumber = gcloud projects describe $ProjectId --format="value(projectNumber)"
$cloudbuildSA = "$projectNumber@cloudbuild.gserviceaccount.com"

gcloud secrets add-iam-policy-binding database-password --member="serviceAccount:$cloudbuildSA" --role="roles/secretmanager.secretAccessor" --quiet
Write-Success "Cloud Build service account granted access to secrets"

# Step 5: Grant Cloud Build service account Cloud Run permissions
Write-Step "Granting Cloud Build service account Cloud Run permissions"
gcloud projects add-iam-policy-binding $ProjectId --member="serviceAccount:$cloudbuildSA" --role="roles/run.developer" --quiet
gcloud projects add-iam-policy-binding $ProjectId --member="serviceAccount:$cloudbuildSA" --role="roles/cloudsql.client" --quiet
Write-Success "Cloud Build service account permissions granted"

# Step 6: Submit build to Cloud Build
Write-Step "Submitting build to Google Cloud Build"
gcloud builds submit --config=cloudbuild.yaml .

if ($LASTEXITCODE -ne 0) {
    Write-Error "Cloud Build submission failed"
    exit 1
}

Write-Success "Build and deployment completed successfully!"

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
    Write-Host ""
    Write-Host "🔍 Monitor the application:"
    Write-Host "  Cloud Run: https://console.cloud.google.com/run/detail/$Region/$ServiceName"
    Write-Host "  Logs: https://console.cloud.google.com/logs/query;query=resource.type%3D%22cloud_run_revision%22%0Aresource.labels.service_name%3D%22$ServiceName%22"
} else {
    Write-Warning "Could not retrieve service URL. Check Cloud Run console."
}

Write-Host ""
Write-Host "🎉 Deployment completed!" -ForegroundColor Green