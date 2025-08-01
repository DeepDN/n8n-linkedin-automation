# LinkedIn AI Content Automation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![n8n](https://img.shields.io/badge/n8n-Compatible-FF6D5A)](https://n8n.io)
[![OpenAI](https://img.shields.io/badge/OpenAI-GPT--4-412991)](https://openai.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-API-0077B5)](https://developer.linkedin.com)

Automate high-quality LinkedIn posts with AI-generated content, images, and SEO-optimized hashtags. Built for DevOps and AI professionals to maintain consistent, engaging social media presence.

## Features

- **AI-Powered Content Generation** - GPT-4 creates engaging posts
- **Professional Image Creation** - DALL-E generates LinkedIn-optimized visuals
- **SEO-Optimized Hashtags** - Strategic hashtag generation for maximum reach
- **Smart Scheduling** - Posts at optimal times (Tue/Wed/Thu 10 AM IST)
- **Intelligent Content Curation** - Scrapes and filters trending tech content
- **Quality Assurance** - Content validation and fallback systems
- **Analytics Dashboard** - Track performance and optimize strategy
- **Cloud-Ready** - Designed for n8n Cloud deployment

## Architecture

```mermaid
graph TD
    A[Cron Trigger] --> B[Smart Source Selection]
    B --> C[Content Scraping]
    C --> D[Content Filtering & Scoring]
    D --> E[AI Content Generation]
    D --> F[Hashtag Generation]
    D --> G[Image Generation]
    E --> H[Content Combiner]
    F --> H
    G --> H
    H --> I[Quality Gate]
    I --> J[LinkedIn Publisher]
    I --> K[Fallback Generator]
    K --> J
    J --> L[Analytics Logger]
```

## Prerequisites

### Required Accounts & API Keys

1. **OpenAI Account**
   - Sign up at [OpenAI Platform](https://platform.openai.com)
   - Generate API key with GPT-4 and DALL-E access
   - Minimum $5 credit recommended

2. **LinkedIn Developer Account**
   - Create app at [LinkedIn Developer Portal](https://developer.linkedin.com)
   - Enable "Share on LinkedIn" and "Sign In with LinkedIn" products
   - Note Client ID and Client Secret

3. **Google Account (Optional)**
   - For Google Sheets logging
   - Create service account in Google Cloud Console
   - Enable Google Sheets API

4. **n8n Cloud Account**
   - Sign up at [n8n.cloud](https://n8n.cloud)
   - Choose appropriate plan (Starter plan sufficient)

### Technical Requirements

- Node.js 16+ (for local development)
- Git (for version control)
- Modern web browser
- Internet connection

## Quick Start

### Option 1: n8n Cloud Deployment (Recommended)

1. **Clone Repository**
   ```bash
   git clone https://github.com/DeepDN/n8n-linkedin-automation.git
   cd n8n-linkedin-automation
   ```

2. **Set Up n8n Cloud**
   - Log into your n8n Cloud account
   - Create new workflow
   - Import `workflows/working-linkedin-workflow.json` (recommended)

3. **Configure Credentials**
   - Add OpenAI API credential
   - Add LinkedIn OAuth2 credential
   - Add Google Sheets credential (optional)

4. **Activate Workflow**
   - Test individual nodes
   - Enable the workflow
   - Monitor execution logs

### Option 2: Local Development

1. **Install n8n**
   ```bash
   npm install -g n8n
   ```

2. **Run Setup Script**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Start n8n**
   ```bash
   n8n start
   ```

4. **Import Workflow**
   - Open http://localhost:5678
   - Import workflow from `workflows/` directory

## Project Structure

```
n8n-linkedin-automation/
├── README.md                          # This file
├── GETTING_STARTED.md                 # Quick setup guide
├── LICENSE                           # MIT License
├── .gitignore                       # Git ignore rules
├── package.json                     # Project metadata
├── deploy.sh                        # Quick deployment script
├── workflows/
│   ├── working-linkedin-workflow.json    # Recommended workflow
│   ├── enhanced-workflow-clean.json      # Advanced workflow
│   └── basic-workflow-fixed.json         # Simple workflow
├── docs/
│   ├── SETUP.md                     # Detailed setup guide
│   ├── API_CONFIGURATION.md         # API setup instructions
│   └── DEPLOYMENT.md                # Deployment guide
└── config/
    └── .env.example                 # Environment variables template
```

## Workflow Options

### 1. working-linkedin-workflow.json (Recommended)
- **Nodes**: 5 nodes with essential functionality
- **Features**: RSS feed reading, AI content generation, LinkedIn posting
- **Best for**: Getting started quickly, production use
- **File size**: 3KB

### 2. enhanced-workflow-clean.json (Advanced)
- **Nodes**: 9 nodes with advanced features
- **Features**: Smart content filtering, quality gates, fallback systems
- **Best for**: Advanced users who want comprehensive automation
- **File size**: 8.5KB

### 3. basic-workflow-fixed.json (Simple)
- **Nodes**: 5 nodes with minimal configuration
- **Features**: Basic RSS to LinkedIn posting
- **Best for**: Troubleshooting, learning n8n basics
- **File size**: 2.7KB

## Configuration

### Environment Variables

Create `.env` file from template:

```bash
cp config/.env.example .env
```

Required variables:
```env
# OpenAI Configuration
OPENAI_API_KEY=sk-your-openai-api-key

# LinkedIn Configuration
LINKEDIN_CLIENT_ID=your-linkedin-client-id
LINKEDIN_CLIENT_SECRET=your-linkedin-client-secret

# Google Sheets (Optional)
GOOGLE_SHEETS_CLIENT_EMAIL=your-service-account@project.iam.gserviceaccount.com
GOOGLE_SHEETS_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
GOOGLE_SHEET_ID=your-google-sheet-id

# Workflow Configuration
POSTING_SCHEDULE="30 4 * * 2,3,4"  # Tue/Wed/Thu 10 AM IST
CONTENT_THEMES=devops,ai-trends,cloud-native
QUALITY_THRESHOLD=7

# Monitoring
WEBHOOK_URL=https://your-n8n-instance.app.n8n.cloud
ENABLE_ANALYTICS=true
```

### Content Sources

Configure RSS feeds in workflow:
```javascript
const contentSources = {
  devops: [
    'https://feeds.feedburner.com/oreilly/radar',
    'https://www.docker.com/blog/feed/',
    'https://kubernetes.io/feed.xml'
  ],
  ai: [
    'https://techcrunch.com/category/artificial-intelligence/feed/',
    'https://openai.com/blog/rss/',
    'https://ai.googleblog.com/feeds/posts/default'
  ],
  cloud: [
    'https://aws.amazon.com/blogs/devops/feed/',
    'https://azure.microsoft.com/en-us/blog/feed/',
    'https://cloud.google.com/blog/rss'
  ]
};
```

## API Setup Guide

### 1. OpenAI API Setup

1. Visit [OpenAI Platform](https://platform.openai.com/api-keys)
2. Create new API key
3. Add billing information (minimum $5)
4. Test with curl:
   ```bash
   curl -H "Authorization: Bearer YOUR_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{"model":"gpt-4","messages":[{"role":"user","content":"Hello"}],"max_tokens":10}' \
        https://api.openai.com/v1/chat/completions
   ```

### 2. LinkedIn API Setup

1. Go to [LinkedIn Developer Portal](https://developer.linkedin.com/apps)
2. Create new app:
   - App name: "LinkedIn Content Automation"
   - Company: Your company/personal
   - Privacy policy URL: Your website
   - App logo: Upload professional logo
3. Add products:
   - "Share on LinkedIn"
   - "Sign In with LinkedIn"
4. Configure OAuth 2.0:
   - Redirect URLs: `https://your-n8n-instance.app.n8n.cloud/rest/oauth2-credential/callback`
5. Note Client ID and Client Secret

### 3. Google Sheets API Setup (Optional)

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create new project or select existing
3. Enable Google Sheets API
4. Create service account:
   - Go to IAM & Admin → Service Accounts
   - Create service account
   - Download JSON key file
5. Share Google Sheet with service account email
6. Extract client_email and private_key from JSON

## n8n Cloud Deployment

### Step 1: Prepare Workflow

1. **Choose Workflow File**:
   - Start with `workflows/working-linkedin-workflow.json`
   - Advanced users can use `workflows/enhanced-workflow-clean.json`

2. **Validate Workflow**:
   ```bash
   # Check workflow syntax
   python3 -m json.tool workflows/working-linkedin-workflow.json
   ```

### Step 2: Deploy to n8n Cloud

1. **Login to n8n Cloud**:
   - Visit [n8n.cloud](https://n8n.cloud)
   - Access your instance

2. **Import Workflow**:
   - Click "Import from File"
   - Select your chosen workflow file
   - Review imported nodes

3. **Configure Credentials**:
   - Go to Settings → Credentials
   - Add each credential type:
     - OpenAI API
     - LinkedIn OAuth2 API
     - Google Sheets Service Account (optional)

4. **Test Workflow**:
   - Execute individual nodes
   - Check error logs
   - Verify API connections

5. **Activate Workflow**:
   - Toggle workflow to "Active"
   - Monitor execution logs
   - Check first automated run

### Step 3: Monitor & Optimize

1. **Set Up Monitoring**:
   - Enable workflow execution logging
   - Configure error notifications
   - Set up performance alerts

2. **Analytics Dashboard**:
   - Monitor key metrics through n8n interface
   - Track execution success rates
   - Monitor API usage

## Monitoring & Analytics

### Key Metrics to Track

- **Content Performance**:
  - Posts published successfully
  - Average quality score
  - Engagement predictions
  - Content theme distribution

- **System Health**:
  - Workflow execution success rate
  - API response times
  - Error frequency
  - Resource usage

- **Business Impact**:
  - LinkedIn follower growth
  - Post engagement rates
  - Profile view increases
  - Lead generation

## Troubleshooting

### Common Issues

1. **OpenAI API Errors**:
   ```bash
   # Check API key validity
   curl -H "Authorization: Bearer $OPENAI_API_KEY" \
        https://api.openai.com/v1/models
   ```

2. **LinkedIn Authentication**:
   - Verify redirect URLs match exactly
   - Check app permissions
   - Refresh OAuth tokens

3. **Content Quality Issues**:
   - Adjust quality threshold
   - Update content filters
   - Refine AI prompts

4. **Scheduling Problems**:
   - Verify cron expression
   - Check timezone settings
   - Monitor execution logs

5. **Import Errors**:
   - Start with `working-linkedin-workflow.json`
   - Validate JSON syntax
   - Check n8n Cloud compatibility

### Debug Mode

Enable debug logging in n8n:
```env
N8N_LOG_LEVEL=debug
N8N_LOG_OUTPUT=console,file
```

## Customization

### Content Templates

Modify content generation prompts in workflow nodes:
```javascript
const postTemplates = {
  devops: {
    hooks: [
      "DevOps teams are seeing 40% faster deployments...",
      "Here's what most DevOps engineers get wrong..."
    ],
    structures: [
      "hook + insight + practical tip + CTA"
    ]
  }
};
```

### Hashtag Strategy

Update hashtag generation in workflow:
```javascript
const hashtagStrategies = {
  trending: ["#DevOps", "#AI", "#CloudComputing"],
  niche: ["#Kubernetes", "#Docker", "#Terraform"],
  community: ["#DevOpsCommunity", "#TechLeadership"]
};
```

## Cost Estimation

### Monthly Costs (Daily Posts)

- **OpenAI API**: $15-30
  - GPT-4: ~$0.06 per post
  - DALL-E: ~$0.02 per image
- **n8n Cloud**: $20-50 (Starter/Pro plan)
- **LinkedIn API**: Free
- **Google Sheets**: Free

**Total: $35-80/month**

### Cost Optimization Tips

1. Use GPT-3.5-turbo for non-critical content
2. Implement image caching
3. Batch API requests
4. Monitor usage with alerts

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Development Setup

```bash
# Clone repository
git clone https://github.com/DeepDN/n8n-linkedin-automation.git
cd n8n-linkedin-automation

# Install dependencies
npm install

# Set up environment
cp config/.env.example .env
# Edit .env with your credentials

# Start local n8n
npm run dev
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [n8n](https://n8n.io) - Workflow automation platform
- [OpenAI](https://openai.com) - AI content generation
- [LinkedIn](https://developer.linkedin.com) - Social media platform
- Community contributors and testers

## Support

- Email: your-email@domain.com
- Discord: [Join our community](https://discord.gg/your-server)
- Issues: [GitHub Issues](https://github.com/DeepDN/n8n-linkedin-automation/issues)
- Documentation: [Wiki](https://github.com/DeepDN/n8n-linkedin-automation/wiki)

---

**Made with love for the DevOps and AI community**

Star this repository if it helps you automate your LinkedIn presence!
