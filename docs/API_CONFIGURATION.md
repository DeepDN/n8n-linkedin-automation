# 🔑 API Configuration Guide

This guide provides detailed instructions for setting up all required API integrations.

## 📋 Overview

Required APIs:
- ✅ **OpenAI API** - Content and image generation
- ✅ **LinkedIn API** - Social media posting
- ⚠️ **Google Sheets API** - Analytics logging (optional)

## 🤖 OpenAI API Configuration

### Step 1: Account Setup

1. **Create OpenAI Account**:
   - Visit [OpenAI Platform](https://platform.openai.com)
   - Sign up with email or OAuth provider
   - Verify email address

2. **Add Payment Method**:
   - Go to [Billing](https://platform.openai.com/account/billing)
   - Add credit card
   - Purchase credits (minimum $5 recommended)

### Step 2: API Key Generation

1. **Generate API Key**:
   - Go to [API Keys](https://platform.openai.com/api-keys)
   - Click "Create new secret key"
   - Name: "LinkedIn Automation"
   - Copy the key immediately (won't be shown again)

2. **Set Usage Limits** (Recommended):
   - Go to [Usage Limits](https://platform.openai.com/account/limits)
   - Set monthly limit: $50 (adjust based on needs)
   - Enable email notifications

### Step 3: Test API Access

```bash
# Test GPT-4 access
curl -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "model": "gpt-4",
    "messages": [{"role": "user", "content": "Hello, test message"}],
    "max_tokens": 10
  }'

# Test DALL-E access
curl -X POST "https://api.openai.com/v1/images/generations" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "prompt": "A simple test image",
    "n": 1,
    "size": "1024x1024"
  }'
```

### Step 4: n8n Configuration

1. **Add Credential in n8n**:
   - Go to Settings → Credentials
   - Add "OpenAI API" credential
   - Enter API key
   - Test connection

2. **Usage Monitoring**:
   - Monitor usage at [OpenAI Usage](https://platform.openai.com/usage)
   - Expected cost: ~$0.08 per post (GPT-4 + DALL-E)

## 🔗 LinkedIn API Configuration

### Step 1: Create LinkedIn App

1. **Access Developer Portal**:
   - Go to [LinkedIn Developer Portal](https://developer.linkedin.com)
   - Sign in with your LinkedIn account

2. **Create New App**:
   - Click "Create app"
   - Fill required information:
     ```
     App name: LinkedIn Content Automation
     LinkedIn Page: [Your personal or company page]
     Privacy policy URL: [Your website or GitHub repo]
     App logo: [Upload 400x400px professional logo]
     Legal agreement: ✅ Accept
     ```

### Step 2: Configure App Products

1. **Request Products**:
   - Go to Products tab
   - Request "Share on LinkedIn" (usually auto-approved)
   - Request "Sign In with LinkedIn" (usually auto-approved)

2. **Verify Approval**:
   - Check status in Products tab
   - Both should show "Approved" status

### Step 3: OAuth Configuration

1. **Get App Credentials**:
   - Go to Auth tab
   - Copy **Client ID**
   - Copy **Client Secret**

2. **Configure Redirect URLs**:
   - For n8n Cloud: `https://your-instance.app.n8n.cloud/rest/oauth2-credential/callback`
   - For local development: `http://localhost:5678/rest/oauth2-credential/callback`
   - Click "Update"

### Step 4: Test LinkedIn Integration

1. **Test OAuth Flow**:
   ```bash
   # Step 1: Get authorization URL
   https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI&scope=w_member_social

   # Step 2: Exchange code for token (done automatically by n8n)
   ```

2. **Test Posting Permission**:
   - Use LinkedIn's API test console
   - Verify you can post to your profile

### Step 5: n8n Configuration

1. **Add LinkedIn Credential**:
   - Go to Settings → Credentials
   - Add "LinkedIn OAuth2 API" credential
   - Enter Client ID and Client Secret
   - Click "Connect my account"
   - Complete OAuth authorization

2. **Verify Permissions**:
   - Ensure "Share on LinkedIn" permission is granted
   - Test with a sample post

## 📊 Google Sheets API Configuration (Optional)

### Step 1: Google Cloud Setup

1. **Create Project**:
   - Go to [Google Cloud Console](https://console.cloud.google.com)
   - Create new project: "LinkedIn Automation"
   - Enable billing (free tier sufficient)

2. **Enable APIs**:
   - Go to APIs & Services → Library
   - Search and enable "Google Sheets API"
   - Search and enable "Google Drive API"

### Step 2: Service Account Creation

1. **Create Service Account**:
   - Go to IAM & Admin → Service Accounts
   - Click "Create Service Account"
   - Name: "n8n-linkedin-automation"
   - Description: "Service account for LinkedIn automation analytics"

2. **Generate Key**:
   - Click on created service account
   - Go to Keys tab
   - Click "Add Key" → "Create new key"
   - Choose JSON format
   - Download and save the key file

### Step 3: Google Sheets Setup

1. **Create Analytics Sheet**:
   - Create new Google Sheet
   - Name: "LinkedIn Posts Analytics"
   - Add headers in row 1:
     ```
     timestamp | post_text | image_url | original_url | original_title | content_theme | quality_score | estimated_engagement | hashtag_count | status
     ```

2. **Share with Service Account**:
   - Click "Share" button
   - Add service account email (from JSON key file)
   - Give "Editor" permissions

3. **Get Sheet ID**:
   - Copy Sheet ID from URL: `https://docs.google.com/spreadsheets/d/SHEET_ID/edit`

### Step 4: n8n Configuration

1. **Add Google Sheets Credential**:
   - Go to Settings → Credentials
   - Add "Google Sheets Service Account" credential
   - Enter service account email and private key from JSON file

2. **Test Connection**:
   - Create test workflow with Google Sheets node
   - Verify it can read/write to your sheet

## 🔧 Advanced Configuration

### OpenAI Optimization

1. **Model Selection**:
   ```javascript
   // For content generation (higher quality)
   model: "gpt-4"
   
   // For cost optimization (lower quality)
   model: "gpt-3.5-turbo"
   ```

2. **Token Limits**:
   ```javascript
   // Content generation
   max_tokens: 500
   
   // Hashtag generation
   max_tokens: 100
   ```

3. **Temperature Settings**:
   ```javascript
   // More creative (0.7-1.0)
   temperature: 0.8
   
   // More consistent (0.1-0.3)
   temperature: 0.2
   ```

### LinkedIn Rate Limits

1. **Personal Profiles**:
   - 100 posts per day
   - 1 post per minute

2. **Company Pages**:
   - 25 posts per day
   - 1 post per 5 minutes

3. **Best Practices**:
   - Space posts at least 1 hour apart
   - Monitor for rate limit errors
   - Implement retry logic

### Google Sheets Optimization

1. **Batch Operations**:
   ```javascript
   // Instead of individual writes
   // Use batch updates for better performance
   ```

2. **Data Validation**:
   ```javascript
   // Add data validation rules
   // Prevent invalid data entry
   ```

## 🚨 Security Best Practices

### API Key Security

1. **Storage**:
   - Never commit API keys to version control
   - Use n8n's encrypted credential storage
   - Rotate keys regularly

2. **Access Control**:
   - Use least privilege principle
   - Monitor API usage regularly
   - Set up usage alerts

### LinkedIn Security

1. **App Security**:
   - Use HTTPS redirect URLs only
   - Regularly review app permissions
   - Monitor for suspicious activity

2. **Token Management**:
   - Tokens expire after 60 days
   - Implement automatic token refresh
   - Handle token expiration gracefully

## 📊 Monitoring & Alerts

### Usage Monitoring

1. **OpenAI Usage**:
   ```bash
   # Check usage via API
   curl -H "Authorization: Bearer YOUR_API_KEY" \
        https://api.openai.com/v1/usage
   ```

2. **LinkedIn API Limits**:
   - Monitor response headers for rate limit info
   - Track daily post counts
   - Set up alerts for approaching limits

### Error Handling

1. **Common Error Codes**:
   ```javascript
   // OpenAI
   401: "Invalid API key"
   429: "Rate limit exceeded"
   500: "Server error"
   
   // LinkedIn
   401: "Unauthorized"
   403: "Forbidden"
   429: "Too many requests"
   ```

2. **Retry Logic**:
   ```javascript
   // Implement exponential backoff
   // Handle temporary failures gracefully
   ```

## 🧪 Testing Checklist

### Pre-Production Testing

- [ ] OpenAI API key works
- [ ] GPT-4 access confirmed
- [ ] DALL-E access confirmed
- [ ] LinkedIn OAuth flow complete
- [ ] LinkedIn posting permission verified
- [ ] Google Sheets read/write access (if used)
- [ ] All credentials saved in n8n
- [ ] Test workflow executes successfully

### Production Monitoring

- [ ] Daily execution logs reviewed
- [ ] API usage within limits
- [ ] Error rates acceptable (<5%)
- [ ] Content quality maintained
- [ ] Costs within budget

## 💰 Cost Estimation

### OpenAI Costs (Daily Posts)

```
GPT-4 Content Generation:
- ~500 tokens per post
- $0.03 per 1K tokens
- Cost: ~$0.015 per post

DALL-E Image Generation:
- 1 image per post
- $0.020 per image
- Cost: $0.020 per post

Total per post: ~$0.035
Monthly (30 posts): ~$1.05
```

### LinkedIn API

- Free tier: Unlimited posts
- No additional costs

### Google Sheets API

- Free tier: 100 requests per 100 seconds
- No additional costs for typical usage

### Total Monthly Cost

- OpenAI: ~$1-3
- n8n Cloud: $20-50
- **Total: $21-53/month**

## 📞 Support Resources

### Official Documentation

- [OpenAI API Docs](https://platform.openai.com/docs)
- [LinkedIn API Docs](https://docs.microsoft.com/en-us/linkedin/)
- [Google Sheets API Docs](https://developers.google.com/sheets/api)
- [n8n Documentation](https://docs.n8n.io)

### Community Support

- [OpenAI Community](https://community.openai.com)
- [LinkedIn Developer Community](https://www.linkedin.com/groups/25827/)
- [n8n Community](https://community.n8n.io)

### Troubleshooting

- Check API status pages
- Review error logs carefully
- Test individual API calls
- Verify credential configuration
- Monitor rate limits and quotas
