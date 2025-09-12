# Google Cloud SQL Setup Script for Banking App
 
$PROJECT_ID = "banking-app-fullstack" 
$INSTANCE_NAME = "banking-db"
$DATABASE_NAME = "banking_app"
$DB_USER = "banking_user"
$DB_PASSWORD =   # 
$REGION = "us-central1"

Write-Host "=== Setting up Cloud SQL for Banking App ===" -ForegroundColor Green

# Set project
Write-Host "Setting project to: $PROJECT_ID" -ForegroundColor Yellow
gcloud config set project $PROJECT_ID

# Enable APIs
Write-Host "Enabling required APIs..." -ForegroundColor Yellow
gcloud services enable sqladmin.googleapis.com
gcloud services enable compute.googleapis.com

# Create Cloud SQL instance
Write-Host "Creating Cloud SQL PostgreSQL instance: $INSTANCE_NAME" -ForegroundColor Yellow
gcloud sql instances create $INSTANCE_NAME `
    --database-version=POSTGRES_15 `
    --tier=db-f1-micro `
    --region=$REGION `
    --storage-type=SSD `
    --storage-size=10GB `
    --backup-start-time=03:00 `
    --maintenance-window-day=SUN `
    --maintenance-window-hour=04

# Wait for instance to be ready
Write-Host "Waiting for instance to be ready..." -ForegroundColor Yellow
gcloud sql instances describe $INSTANCE_NAME --format="value(state)"

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
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Update your application.properties with these connection details"
Write-Host "2. Deploy your schema using the connect command below"
Write-Host ""
Write-Host "To connect and deploy schema:" -ForegroundColor Cyan
Write-Host "gcloud sql connect $INSTANCE_NAME --user=$DB_USER --database=$DATABASE_NAME"