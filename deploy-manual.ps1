# Manual Cloud Run Deployment Script
# Run this after the Docker image has been built and pushed to GCR

param(
    [string]$ProjectId = "banking-app-fullstack",
    [string]$Region = "us-central1",
    [string]$ServiceName = "banking-backend",
    [string]$DatabasePassword = "banking123"
)

Write-Host "Deploying to Cloud Run..." -ForegroundColor Cyan

# Deploy to Cloud Run
$connectionName = "$ProjectId:$Region:banking-db"

gcloud run deploy $ServiceName `
    --image="gcr.io/$ProjectId/banking-backend:latest" `
    --platform=managed `
    --region=$Region `
    --allow-unauthenticated `
    --port=8080 `
    --memory=1Gi `
    --cpu=1 `
    --min-instances=0 `
    --max-instances=10 `
    --timeout=300 `
    --add-cloudsql-instances=$connectionName `
    --set-env-vars="DATABASE_URL=jdbc:postgresql:///banking_app?cloudSqlInstance=$connectionName&socketFactory=com.google.cloud.sql.postgres.SocketFactory,DATABASE_USERNAME=banking_user,DATABASE_PASSWORD=$DatabasePassword,SPRING_PROFILES_ACTIVE=prod"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Deployment successful!" -ForegroundColor Green
    
    # Get service URL
    $serviceUrl = gcloud run services describe $ServiceName --region=$Region --format="value(status.url)"
    
    Write-Host ""
    Write-Host "Service URL: $serviceUrl" -ForegroundColor Green
    Write-Host "Health Check: $serviceUrl/actuator/health" -ForegroundColor Green
    Write-Host "API Docs: $serviceUrl/swagger-ui.html" -ForegroundColor Green
} else {
    Write-Host "Deployment failed!" -ForegroundColor Red
}