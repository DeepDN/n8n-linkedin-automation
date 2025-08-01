#!/bin/bash

# LinkedIn AI Content Automation - Workflow Backup Script
# This script creates backups of your n8n workflows

set -e

echo "💾 LinkedIn AI Content Automation - Workflow Backup"
echo "===================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="backups"
DATE=$(date +%Y%m%d_%H%M%S)
N8N_URL="http://localhost:5678"
N8N_CLOUD_URL=""

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo -e "${BLUE}📁 Creating backup directory: $BACKUP_DIR${NC}"

# Function to backup from local n8n
backup_local() {
    echo -e "\n${BLUE}🔄 Backing up from local n8n instance...${NC}"
    
    # Check if n8n is running
    if ! curl -s --connect-timeout 5 "$N8N_URL" > /dev/null 2>&1; then
        echo -e "${RED}❌ Local n8n instance not accessible at $N8N_URL${NC}"
        return 1
    fi
    
    # Export workflows
    echo -e "${YELLOW}📤 Exporting workflows...${NC}"
    
    # Get list of workflows
    workflows=$(curl -s "$N8N_URL/api/v1/workflows" | jq -r '.[].id' 2>/dev/null || echo "")
    
    if [ -z "$workflows" ]; then
        echo -e "${YELLOW}⚠️  No workflows found or jq not installed${NC}"
        echo -e "${BLUE}💡 Manual backup: Go to n8n UI → Workflows → Export${NC}"
        return 1
    fi
    
    # Backup each workflow
    for workflow_id in $workflows; do
        workflow_name=$(curl -s "$N8N_URL/api/v1/workflows/$workflow_id" | jq -r '.name' 2>/dev/null || echo "workflow_$workflow_id")
        safe_name=$(echo "$workflow_name" | sed 's/[^a-zA-Z0-9]/_/g')
        
        echo -e "${BLUE}📋 Backing up: $workflow_name${NC}"
        
        curl -s "$N8N_URL/api/v1/workflows/$workflow_id/export" > "$BACKUP_DIR/${safe_name}_${DATE}.json"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Backed up: ${safe_name}_${DATE}.json${NC}"
        else
            echo -e "${RED}❌ Failed to backup: $workflow_name${NC}"
        fi
    done
}

# Function to backup credentials template
backup_credentials() {
    echo -e "\n${BLUE}🔑 Creating credentials template backup...${NC}"
    
    if [ -f "config/credentials-template.json" ]; then
        cp "config/credentials-template.json" "$BACKUP_DIR/credentials-template_${DATE}.json"
        echo -e "${GREEN}✅ Credentials template backed up${NC}"
    else
        echo -e "${YELLOW}⚠️  Credentials template not found${NC}"
    fi
}

# Function to backup configuration files
backup_config() {
    echo -e "\n${BLUE}⚙️ Backing up configuration files...${NC}"
    
    # Backup .env.example
    if [ -f "config/.env.example" ]; then
        cp "config/.env.example" "$BACKUP_DIR/env.example_${DATE}"
        echo -e "${GREEN}✅ Environment template backed up${NC}"
    fi
    
    # Backup package.json
    if [ -f "package.json" ]; then
        cp "package.json" "$BACKUP_DIR/package_${DATE}.json"
        echo -e "${GREEN}✅ Package.json backed up${NC}"
    fi
    
    # Backup workflow files
    if [ -d "workflows" ]; then
        cp -r workflows "$BACKUP_DIR/workflows_${DATE}"
        echo -e "${GREEN}✅ Workflow files backed up${NC}"
    fi
    
    # Backup templates
    if [ -d "templates" ]; then
        cp -r templates "$BACKUP_DIR/templates_${DATE}"
        echo -e "${GREEN}✅ Template files backed up${NC}"
    fi
    
    # Backup documentation
    if [ -d "docs" ]; then
        cp -r docs "$BACKUP_DIR/docs_${DATE}"
        echo -e "${GREEN}✅ Documentation backed up${NC}"
    fi
}

# Function to create a complete project backup
backup_complete() {
    echo -e "\n${BLUE}📦 Creating complete project backup...${NC}"
    
    # Create tar archive of entire project (excluding sensitive files)
    tar -czf "$BACKUP_DIR/complete_project_${DATE}.tar.gz" \
        --exclude='.env' \
        --exclude='node_modules' \
        --exclude='.git' \
        --exclude='backups' \
        --exclude='*.log' \
        --exclude='.n8n' \
        .
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Complete project backup created: complete_project_${DATE}.tar.gz${NC}"
    else
        echo -e "${RED}❌ Failed to create complete project backup${NC}"
    fi
}

# Function to backup to cloud storage (optional)
backup_to_cloud() {
    echo -e "\n${BLUE}☁️ Cloud backup options...${NC}"
    
    # Check if AWS CLI is available
    if command -v aws &> /dev/null; then
        echo -e "${YELLOW}💡 AWS CLI detected. You can backup to S3 with:${NC}"
        echo -e "${BLUE}   aws s3 cp $BACKUP_DIR s3://your-bucket/n8n-backups/ --recursive${NC}"
    fi
    
    # Check if Google Cloud SDK is available
    if command -v gsutil &> /dev/null; then
        echo -e "${YELLOW}💡 Google Cloud SDK detected. You can backup to GCS with:${NC}"
        echo -e "${BLUE}   gsutil -m cp -r $BACKUP_DIR gs://your-bucket/n8n-backups/${NC}"
    fi
    
    # Check if rclone is available
    if command -v rclone &> /dev/null; then
        echo -e "${YELLOW}💡 rclone detected. You can backup to various cloud providers with:${NC}"
        echo -e "${BLUE}   rclone copy $BACKUP_DIR remote:n8n-backups${NC}"
    fi
}

# Function to clean old backups
cleanup_old_backups() {
    echo -e "\n${BLUE}🧹 Cleaning up old backups...${NC}"
    
    # Keep only last 10 backups
    backup_count=$(ls -1 "$BACKUP_DIR" | wc -l)
    
    if [ "$backup_count" -gt 10 ]; then
        echo -e "${YELLOW}📊 Found $backup_count backups, keeping latest 10${NC}"
        
        # Remove oldest backups
        ls -1t "$BACKUP_DIR" | tail -n +11 | while read -r old_backup; do
            rm -rf "$BACKUP_DIR/$old_backup"
            echo -e "${GREEN}🗑️  Removed old backup: $old_backup${NC}"
        done
    else
        echo -e "${GREEN}✅ Backup count ($backup_count) within limit${NC}"
    fi
}

# Function to verify backups
verify_backups() {
    echo -e "\n${BLUE}🔍 Verifying backups...${NC}"
    
    backup_files=$(find "$BACKUP_DIR" -name "*${DATE}*" -type f)
    
    if [ -z "$backup_files" ]; then
        echo -e "${RED}❌ No backup files created${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Backup files created:${NC}"
    echo "$backup_files" | while read -r file; do
        size=$(du -h "$file" | cut -f1)
        echo -e "${BLUE}   📄 $(basename "$file") ($size)${NC}"
    done
    
    # Verify JSON files are valid
    json_files=$(find "$BACKUP_DIR" -name "*${DATE}*.json" -type f)
    
    if [ -n "$json_files" ]; then
        echo -e "\n${BLUE}🔍 Validating JSON files...${NC}"
        
        echo "$json_files" | while read -r json_file; do
            if command -v jq &> /dev/null; then
                if jq empty "$json_file" 2>/dev/null; then
                    echo -e "${GREEN}✅ Valid JSON: $(basename "$json_file")${NC}"
                else
                    echo -e "${RED}❌ Invalid JSON: $(basename "$json_file")${NC}"
                fi
            else
                echo -e "${YELLOW}⚠️  jq not installed, skipping JSON validation${NC}"
                break
            fi
        done
    fi
}

# Main execution
echo -e "${BLUE}🚀 Starting backup process...${NC}"

# Parse command line arguments
BACKUP_TYPE="all"
while [[ $# -gt 0 ]]; do
    case $1 in
        --local-only)
            BACKUP_TYPE="local"
            shift
            ;;
        --config-only)
            BACKUP_TYPE="config"
            shift
            ;;
        --complete-only)
            BACKUP_TYPE="complete"
            shift
            ;;
        --n8n-url)
            N8N_URL="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --local-only     Backup only from local n8n instance"
            echo "  --config-only    Backup only configuration files"
            echo "  --complete-only  Create only complete project backup"
            echo "  --n8n-url URL    Custom n8n instance URL (default: http://localhost:5678)"
            echo "  --help           Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                           # Full backup"
            echo "  $0 --local-only             # Backup only workflows from local n8n"
            echo "  $0 --config-only            # Backup only config files"
            echo "  $0 --n8n-url http://custom:5678  # Use custom n8n URL"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Execute backup based on type
case $BACKUP_TYPE in
    "local")
        backup_local
        ;;
    "config")
        backup_config
        ;;
    "complete")
        backup_complete
        ;;
    "all")
        backup_local || echo -e "${YELLOW}⚠️  Local backup failed, continuing...${NC}"
        backup_credentials
        backup_config
        backup_complete
        ;;
esac

# Always verify and cleanup
verify_backups
cleanup_old_backups
backup_to_cloud

# Summary
echo -e "\n${GREEN}🎉 Backup process completed!${NC}"
echo -e "${BLUE}📁 Backup location: $BACKUP_DIR${NC}"
echo -e "${BLUE}📅 Backup timestamp: $DATE${NC}"

# Calculate total backup size
if command -v du &> /dev/null; then
    total_size=$(du -sh "$BACKUP_DIR" | cut -f1)
    echo -e "${BLUE}💾 Total backup size: $total_size${NC}"
fi

echo -e "\n${BLUE}📋 Backup Contents:${NC}"
ls -la "$BACKUP_DIR" | grep "$DATE" || echo -e "${YELLOW}⚠️  No files with today's timestamp found${NC}"

echo -e "\n${BLUE}💡 Tips:${NC}"
echo -e "${YELLOW}   • Store backups in a secure location${NC}"
echo -e "${YELLOW}   • Test restore process periodically${NC}"
echo -e "${YELLOW}   • Consider automated cloud backups${NC}"
echo -e "${YELLOW}   • Keep backups for compliance requirements${NC}"

echo -e "\n${BLUE}🔄 Restore Instructions:${NC}"
echo -e "${YELLOW}   1. Import workflow JSON files into n8n${NC}"
echo -e "${YELLOW}   2. Restore configuration files as needed${NC}"
echo -e "${YELLOW}   3. Reconfigure credentials (not backed up for security)${NC}"
echo -e "${YELLOW}   4. Test workflow execution${NC}"

exit 0
