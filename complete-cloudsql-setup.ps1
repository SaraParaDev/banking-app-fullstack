# Complete Cloud SQL Setup - Run this after instance is created
# Variables
$INSTANCE_NAME = "banking-db"
$DATABASE_NAME = "banking_app"
$DB_USER = "banking_user"
$DB_PASSWORD =  

Write-Host "=== Completing Cloud SQL Setup ===" -ForegroundColor Green

# Wait for instance to be ready
Write-Host "Checking instance status..." -ForegroundColor Yellow
$status = gcloud sql instances describe $INSTANCE_NAME --format="value(state)"
Write-Host "Current status: $status" -ForegroundColor Cyan

if ($status -eq "RUNNABLE") {
    Write-Host "Instance is ready! Continuing with setup..." -ForegroundColor Green
    
    # Create database
    Write-Host "Creating database: $DATABASE_NAME" -ForegroundColor Yellow
    gcloud sql databases create $DATABASE_NAME --instance=$INSTANCE_NAME
    
    # Create user
    Write-Host "Creating database user: $DB_USER" -ForegroundColor Yellow
    gcloud sql users create $DB_USER --instance=$INSTANCE_NAME --password=$DB_PASSWORD
    
    # Get connection info
    Write-Host "Getting connection information..." -ForegroundColor Yellow
    $CONNECTION_NAME = gcloud sql instances describe $INSTANCE_NAME --format="value(connectionName)"
    $PUBLIC_IP = gcloud sql instances describe $INSTANCE_NAME --format="value(ipAddresses[0].ipAddress)"
    
    Write-Host "=== Setup Complete! ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Connection Details:" -ForegroundColor Cyan
    Write-Host "Instance Name: $INSTANCE_NAME"
    Write-Host "Database Name: $DATABASE_NAME"
    Write-Host "Username: $DB_USER"
    Write-Host "Password: $DB_PASSWORD"
    Write-Host "Public IP: $PUBLIC_IP"
    Write-Host "Connection Name: $CONNECTION_NAME"
    Write-Host ""
    Write-Host "JDBC URL for your application.yaml:" -ForegroundColor Yellow
    Write-Host "jdbc:postgresql://${PUBLIC_IP}:5432/${DATABASE_NAME}" -ForegroundColor White
    Write-Host ""
    Write-Host "To connect and deploy schema:" -ForegroundColor Cyan
    Write-Host "gcloud sql connect $INSTANCE_NAME --user=$DB_USER --database=$DATABASE_NAME"
} else {
    Write-Host "Instance is still being created. Status: $status" -ForegroundColor Yellow
    Write-Host "Please wait a few more minutes and run this script again." -ForegroundColor Yellow
}