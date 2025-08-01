#!/bin/bash

# LinkedIn AI Content Automation - Quick Deploy Script
# This script helps you set up the n8n workflow quickly

echo "LinkedIn AI Content Automation - Quick Deploy"
echo "================================================"

# Check if n8n is installed
if ! command -v n8n &> /dev/null; then
    echo "n8n is not installed. Installing now..."
    npm install -g n8n
    echo "n8n installed successfully"
else
    echo "n8n is already installed"
fi

# Create n8n data directory if it doesn't exist
N8N_DATA_DIR="$HOME/.n8n"
if [ ! -d "$N8N_DATA_DIR" ]; then
    mkdir -p "$N8N_DATA_DIR"
    echo "Created n8n data directory"
fi

# Set environment variables
echo "Setting up environment variables..."

# Create .env file for n8n
cat > .env << EOF
# n8n Configuration
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your_secure_password_here

# Webhook URL (change if needed)
WEBHOOK_URL=http://localhost:5678

# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# LinkedIn Configuration  
LINKEDIN_CLIENT_ID=your_linkedin_client_id
LINKEDIN_CLIENT_SECRET=your_linkedin_client_secret

# Google Sheets (optional)
GOOGLE_SHEETS_CLIENT_EMAIL=your_service_account_email
GOOGLE_SHEETS_PRIVATE_KEY=your_private_key

# Timezone
TZ=Asia/Kolkata
EOF

echo "Created .env file with configuration templates"

# Create credentials template
cat > credentials-template.json << EOF
{
  "openai": {
    "name": "OpenAI API",
    "type": "openAiApi",
    "data": {
      "apiKey": "your_openai_api_key_here"
    }
  },
  "linkedin": {
    "name": "LinkedIn OAuth2",
    "type": "linkedInOAuth2Api", 
    "data": {
      "clientId": "your_linkedin_client_id",
      "clientSecret": "your_linkedin_client_secret"
    }
  },
  "googleSheets": {
    "name": "Google Sheets Service Account",
    "type": "googleSheetsOAuth2Api",
    "data": {
      "serviceAccountEmail": "your_service_account_email",
      "privateKey": "your_private_key"
    }
  }
}
EOF

echo "Created credentials template"

# Create startup script
cat > start-n8n.sh << EOF
#!/bin/bash
export N8N_BASIC_AUTH_ACTIVE=true
export N8N_BASIC_AUTH_USER=admin
export N8N_BASIC_AUTH_PASSWORD=your_secure_password_here
export TZ=Asia/Kolkata

echo "Starting n8n..."
echo "Access n8n at: http://localhost:5678"
echo "Username: admin"
echo "Password: your_secure_password_here"

n8n start
EOF

chmod +x start-n8n.sh

echo "Created startup script"

# Create Google Sheets template
cat > google-sheets-template.csv << EOF
timestamp,post_text,image_url,original_url,original_title,content_theme,quality_score,estimated_engagement,hashtag_count,status
EOF

echo "Created Google Sheets template"

# Create quick test script
cat > test-workflow.sh << EOF
#!/bin/bash

echo "🧪 Testing workflow components..."

# Test OpenAI connection
echo "Testing OpenAI API..."
curl -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer \$OPENAI_API_KEY" \
  -d '{
    "model": "gpt-4",
    "messages": [{"role": "user", "content": "Hello, this is a test."}],
    "max_tokens": 10
  }' > /dev/null 2>&1

if [ \$? -eq 0 ]; then
    echo "OpenAI API connection successful"
else
    echo "OpenAI API connection failed - check your API key"
fi

echo "Checking RSS feeds..."
curl -s "https://feeds.feedburner.com/oreilly/radar" | head -n 20 > /dev/null
if [ \$? -eq 0 ]; then
    echo "RSS feed accessible"
else
    echo "RSS feed not accessible"
fi

echo "Basic tests completed"
EOF

chmod +x test-workflow.sh

echo ""
echo "Setup completed! Next steps:"
echo ""
echo "1. Edit the .env file with your actual API keys:"
echo "   - OpenAI API key from https://platform.openai.com/api-keys"
echo "   - LinkedIn app credentials from https://developer.linkedin.com/"
echo "   - Google Sheets credentials (optional)"
echo ""
echo "2. Start n8n:"
echo "   ./start-n8n.sh"
echo ""
echo "3. Import the workflow:"
echo "   - Open http://localhost:5678 in your browser"
echo "   - Go to Workflows → Import from File"
echo "   - Select 'enhanced-workflow.json'"
echo ""
echo "4. Configure credentials in n8n:"
echo "   - Go to Settings → Credentials"
echo "   - Add OpenAI, LinkedIn, and Google Sheets credentials"
echo ""
echo "5. Test the workflow:"
echo "   - Execute individual nodes to test"
echo "   - Run ./test-workflow.sh for basic connectivity tests"
echo ""
echo "6. Activate the workflow:"
echo "   - Toggle the workflow to 'Active'"
echo "   - It will run automatically on Tue/Wed/Thu at 10 AM IST"
echo ""
echo "📚 Check setup-guide.md for detailed instructions"
echo "Check content-templates.js for customization options"
echo ""
echo "Happy automating! 🚀"
