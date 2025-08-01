# 🚀 Deployment Guide

This guide covers deploying the LinkedIn AI Content Automation system to n8n Cloud for production use.

## 📋 Deployment Overview

**Deployment Options:**
1. ✅ **n8n Cloud** (Recommended) - Fully managed, reliable
2. ⚠️ **Self-hosted** - More control, requires maintenance
3. ⚠️ **Local Development** - Testing only

## 🌐 n8n Cloud Deployment (Recommended)

### Prerequisites

- [ ] n8n Cloud account with appropriate plan
- [ ] All API keys and credentials ready
- [ ] Workflow tested locally (optional but recommended)

### Step 1: Choose n8n Cloud Plan

**Plan Recommendations:**

| Plan | Price | Executions | Best For |
|------|-------|------------|----------|
| Starter | $20/month | 2,500/month | Personal use, testing |
| Pro | $50/month | 10,000/month | Professional use |
| Enterprise | Custom | Unlimited | Business use |

**For this project**: Starter plan is sufficient (3 posts/week = ~12 executions/month)

### Step 2: Set Up n8n Cloud Instance

1. **Sign Up**:
   - Go to [n8n.cloud](https://n8n.cloud)
   - Choose your plan
   - Complete registration

2. **Access Your Instance**:
   - Note your instance URL: `https://your-instance.app.n8n.cloud`
   - Login with your credentials

3. **Initial Configuration**:
   - Set up 2FA (recommended)
   - Configure timezone: Asia/Kolkata
   - Enable execution logging

### Step 3: Import Workflow

1. **Download Workflow**:
   ```bash
   # Clone repository
   git clone https://github.com/yourusername/linkedin-ai-automation.git
   cd linkedin-ai-automation
   ```

2. **Import to n8n Cloud**:
   - In n8n interface, click "Import from File"
   - Select `workflows/enhanced-workflow.json`
   - Review imported nodes
   - Click "Import"

### Step 4: Configure Credentials

#### 4.1 OpenAI Credential

1. Go to **Settings → Credentials**
2. Click **Add Credential**
3. Select **OpenAI API**
4. Configure:
   ```
   Name: OpenAI - LinkedIn Automation
   API Key: [Your OpenAI API key]
   ```
5. Test connection and save

#### 4.2 LinkedIn Credential

1. Add new credential
2. Select **LinkedIn OAuth2 API**
3. Configure:
   ```
   Name: LinkedIn - Content Automation
   Client ID: [Your LinkedIn app client ID]
   Client Secret: [Your LinkedIn app client secret]
   ```
4. Click **Connect my account**
5. Complete OAuth authorization
6. Save credential

#### 4.3 Google Sheets Credential (Optional)

1. Add new credential
2. Select **Google Sheets Service Account**
3. Configure:
   ```
   Name: Google Sheets - Analytics
   Service Account Email: [From JSON key file]
   Private Key: [From JSON key file - include full key with headers]
   ```
4. Test connection and save

### Step 5: Configure Workflow Settings

1. **Update Google Sheet ID**:
   - Open "Enhanced Logging" node
   - Replace `YOUR_GOOGLE_SHEET_ID` with actual Sheet ID
   - Sheet ID is in URL: `https://docs.google.com/spreadsheets/d/SHEET_ID/edit`

2. **Verify Schedule**:
   - Check "Smart Schedule" node
   - Default: `30 4 * * 2,3,4` (Tue/Wed/Thu 10 AM IST)
   - Adjust if needed

3. **Assign Credentials**:
   - Click each node requiring credentials
   - Select appropriate credential from dropdown

### Step 6: Test Deployment

#### 6.1 Individual Node Testing

Test nodes in this order:

1. **Smart Source Selection** → Should return RSS URL and theme
2. **Dynamic Content Scraper** → Should return RSS items
3. **Smart Content Filter** → Should return filtered content with score
4. **Enhanced Post Generator** → Should return AI-generated post
5. **Strategic Hashtag Generator** → Should return hashtags
6. **Professional Image Generator** → Should return image URL
7. **Enhanced Content Combiner** → Should combine all content
8. **Quality Gate** → Should validate content quality

#### 6.2 Full Workflow Test

1. **Manual Execution**:
   - Click workflow name
   - Click "Execute Workflow"
   - Monitor execution progress

2. **Verify Results**:
   - Check LinkedIn for posted content
   - Verify Google Sheets logging (if enabled)
   - Review execution logs for errors

### Step 7: Production Activation

1. **Final Checks**:
   - [ ] All nodes execute successfully
   - [ ] LinkedIn posting works
   - [ ] Content quality is acceptable
   - [ ] Logging works (if enabled)
   - [ ] No error messages

2. **Activate Workflow**:
   - Toggle workflow to "Active"
   - Workflow will now run on schedule

3. **Monitor First Runs**:
   - Check execution logs daily for first week
   - Verify posts are being created
   - Monitor for any errors

## 🔧 Self-Hosted Deployment (Advanced)

### Prerequisites

- Linux server (Ubuntu 20.04+ recommended)
- Node.js 16+
- PostgreSQL or SQLite
- Domain name with SSL certificate
- Basic server administration knowledge

### Step 1: Server Setup

1. **Provision Server**:
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Install Node.js
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   
   # Install PostgreSQL
   sudo apt install postgresql postgresql-contrib
   ```

2. **Create Database**:
   ```bash
   sudo -u postgres createuser n8n
   sudo -u postgres createdb n8n
   sudo -u postgres psql -c "ALTER USER n8n PASSWORD 'secure_password';"
   ```

### Step 2: Install n8n

1. **Install n8n**:
   ```bash
   npm install -g n8n
   ```

2. **Configure Environment**:
   ```bash
   # Create .env file
   cat > ~/.n8n/.env << EOF
   DB_TYPE=postgresdb
   DB_POSTGRESDB_HOST=localhost
   DB_POSTGRESDB_PORT=5432
   DB_POSTGRESDB_DATABASE=n8n
   DB_POSTGRESDB_USER=n8n
   DB_POSTGRESDB_PASSWORD=secure_password
   
   N8N_BASIC_AUTH_ACTIVE=true
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=your_secure_password
   
   WEBHOOK_URL=https://your-domain.com
   N8N_HOST=your-domain.com
   N8N_PORT=5678
   N8N_PROTOCOL=https
   EOF
   ```

### Step 3: SSL and Reverse Proxy

1. **Install Nginx**:
   ```bash
   sudo apt install nginx certbot python3-certbot-nginx
   ```

2. **Configure Nginx**:
   ```bash
   sudo nano /etc/nginx/sites-available/n8n
   ```
   
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;
       
       location / {
           proxy_pass http://localhost:5678;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

3. **Enable SSL**:
   ```bash
   sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
   sudo certbot --nginx -d your-domain.com
   ```

### Step 4: Process Management

1. **Create Systemd Service**:
   ```bash
   sudo nano /etc/systemd/system/n8n.service
   ```
   
   ```ini
   [Unit]
   Description=n8n
   After=network.target
   
   [Service]
   Type=simple
   User=n8n
   ExecStart=/usr/bin/n8n start
   Restart=on-failure
   Environment=NODE_ENV=production
   
   [Install]
   WantedBy=multi-user.target
   ```

2. **Start Service**:
   ```bash
   sudo systemctl enable n8n
   sudo systemctl start n8n
   ```

## 📊 Monitoring and Maintenance

### Health Monitoring

1. **Set Up Monitoring**:
   ```bash
   # Create health check script
   cat > ~/health-check.sh << 'EOF'
   #!/bin/bash
   
   # Check n8n service
   if ! systemctl is-active --quiet n8n; then
       echo "n8n service is down"
       # Send alert (email, Slack, etc.)
   fi
   
   # Check workflow execution
   # Add custom checks here
   EOF
   
   chmod +x ~/health-check.sh
   ```

2. **Schedule Health Checks**:
   ```bash
   # Add to crontab
   crontab -e
   # Add: */5 * * * * /home/user/health-check.sh
   ```

### Log Management

1. **Configure Log Rotation**:
   ```bash
   sudo nano /etc/logrotate.d/n8n
   ```
   
   ```
   /home/n8n/.n8n/logs/*.log {
       daily
       missingok
       rotate 30
       compress
       delaycompress
       notifempty
       copytruncate
   }
   ```

### Backup Strategy

1. **Database Backup**:
   ```bash
   # Create backup script
   cat > ~/backup-n8n.sh << 'EOF'
   #!/bin/bash
   
   DATE=$(date +%Y%m%d_%H%M%S)
   BACKUP_DIR="/backup/n8n"
   
   # Create backup directory
   mkdir -p $BACKUP_DIR
   
   # Backup database
   pg_dump -h localhost -U n8n n8n > $BACKUP_DIR/n8n_db_$DATE.sql
   
   # Backup n8n data
   tar -czf $BACKUP_DIR/n8n_data_$DATE.tar.gz /home/n8n/.n8n
   
   # Keep only last 7 days
   find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
   find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
   EOF
   
   chmod +x ~/backup-n8n.sh
   ```

2. **Schedule Backups**:
   ```bash
   # Add to crontab
   crontab -e
   # Add: 0 2 * * * /home/user/backup-n8n.sh
   ```

## 🔄 Updates and Maintenance

### n8n Updates

1. **Update n8n**:
   ```bash
   # Stop service
   sudo systemctl stop n8n
   
   # Update n8n
   npm update -g n8n
   
   # Start service
   sudo systemctl start n8n
   ```

2. **Workflow Updates**:
   - Export current workflow as backup
   - Import updated workflow
   - Test thoroughly before activation

### Security Updates

1. **System Updates**:
   ```bash
   # Regular system updates
   sudo apt update && sudo apt upgrade -y
   ```

2. **SSL Certificate Renewal**:
   ```bash
   # Certbot auto-renewal (usually automatic)
   sudo certbot renew --dry-run
   ```

## 🚨 Troubleshooting

### Common Issues

1. **Workflow Not Executing**:
   - Check if workflow is active
   - Verify cron expression
   - Check execution logs
   - Verify credentials are valid

2. **API Errors**:
   - Check API key validity
   - Verify rate limits
   - Check API service status
   - Review error messages in logs

3. **Performance Issues**:
   - Monitor server resources
   - Check database performance
   - Review workflow complexity
   - Optimize node configurations

### Debug Mode

1. **Enable Debug Logging**:
   ```bash
   export N8N_LOG_LEVEL=debug
   n8n start
   ```

2. **Check Logs**:
   ```bash
   # View recent logs
   tail -f ~/.n8n/logs/n8n.log
   
   # Search for errors
   grep -i error ~/.n8n/logs/n8n.log
   ```

## 📈 Scaling Considerations

### Performance Optimization

1. **Database Optimization**:
   - Regular database maintenance
   - Index optimization
   - Connection pooling

2. **Workflow Optimization**:
   - Minimize API calls
   - Use efficient node configurations
   - Implement caching where possible

### High Availability

1. **Load Balancing**:
   - Multiple n8n instances
   - Shared database
   - Load balancer configuration

2. **Failover Strategy**:
   - Database replication
   - Automated failover
   - Health checks and alerts

## 💰 Cost Analysis

### n8n Cloud vs Self-Hosted

| Aspect | n8n Cloud | Self-Hosted |
|--------|-----------|-------------|
| **Setup Time** | 30 minutes | 2-4 hours |
| **Monthly Cost** | $20-50 | $10-30 (server) |
| **Maintenance** | None | 2-4 hours/month |
| **Reliability** | 99.9% SLA | Depends on setup |
| **Scalability** | Automatic | Manual |
| **Security** | Managed | Your responsibility |

**Recommendation**: Use n8n Cloud unless you have specific requirements for self-hosting.

## 📞 Support and Resources

### Getting Help

1. **n8n Community**: [community.n8n.io](https://community.n8n.io)
2. **Documentation**: [docs.n8n.io](https://docs.n8n.io)
3. **GitHub Issues**: Report bugs and feature requests
4. **Discord/Slack**: Real-time community support

### Professional Support

- n8n Cloud includes support
- Enterprise plans include priority support
- Community support for self-hosted deployments

---

**Deployment Checklist:**

- [ ] Choose deployment method
- [ ] Set up hosting environment
- [ ] Configure credentials
- [ ] Import and test workflow
- [ ] Set up monitoring
- [ ] Configure backups
- [ ] Document configuration
- [ ] Train team members
- [ ] Plan maintenance schedule
