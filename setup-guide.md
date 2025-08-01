# LinkedIn AI Content Automation - Setup Guide

## Prerequisites

1. **n8n Installation**
   ```bash
   npm install -g n8n
   # Or use Docker
   docker run -it --rm --name n8n -p 5678:5678 n8nio/n8n
   ```

2. **Required API Keys & Credentials**
   - OpenAI API Key
   - LinkedIn API credentials
   - Google Sheets API credentials (optional)

## Step-by-Step Setup

### 1. Configure OpenAI Integration

1. Go to n8n Settings → Credentials
2. Add new credential: "OpenAI API"
3. Enter your OpenAI API key
4. Test the connection

### 2. Configure LinkedIn Integration

1. Create LinkedIn App:
   - Go to https://developer.linkedin.com/
   - Create new app
   - Add "Share on LinkedIn" and "Sign In with LinkedIn" products
   - Note down Client ID and Client Secret

2. In n8n:
   - Add LinkedIn OAuth2 API credential
   - Enter Client ID and Client Secret
   - Complete OAuth flow

### 3. Configure Google Sheets (Optional)

1. Create Google Cloud Project
2. Enable Google Sheets API
3. Create service account and download JSON key
4. In n8n, add Google Sheets credential with service account

### 4. Content Sources Configuration

Update the RSS feed URLs in the workflow for your preferred sources:

```javascript
// Popular DevOps/AI content sources
const contentSources = [
  'https://feeds.feedburner.com/oreilly/radar',
  'https://techcrunch.com/category/artificial-intelligence/feed/',
  'https://www.docker.com/blog/feed/',
  'https://kubernetes.io/feed.xml',
  'https://aws.amazon.com/blogs/devops/feed/',
  'https://devops.com/feed/'
];
```

### 5. Customize Content Filters

Modify the content filter keywords based on your niche:

```javascript
const keywords = [
  'devops', 'ai', 'artificial intelligence', 'machine learning',
  'automation', 'kubernetes', 'docker', 'cloud', 'aws', 'azure',
  'terraform', 'jenkins', 'cicd', 'monitoring', 'observability'
];
```

## Workflow Components Explained

### 1. Cron Trigger
- Runs daily at 10 AM IST
- Adjust timezone: `0 10 * * *` (UTC) = 10 AM IST (4:30 AM UTC)
- For 10 AM IST: `30 4 * * *`

### 2. Content Scraping
- Uses RSS feeds from tech blogs
- Filters content based on keywords
- Randomly selects one article per run

### 3. AI Content Generation
- **Post Content**: Creates engaging LinkedIn posts
- **Hashtags**: Generates SEO-optimized hashtags
- **Images**: Creates relevant visuals using DALL-E

### 4. LinkedIn Publishing
- Posts text + image to your LinkedIn profile
- Can be modified for company pages

### 5. Logging
- Tracks all posts in Google Sheets
- Includes timestamps, content, and URLs

## Advanced Features

### Content Moderation (Optional)

Add an approval step before posting:

```javascript
// Add after "Combine Content" node
{
  "name": "Manual Approval",
  "type": "n8n-nodes-base.wait",
  "parameters": {
    "resume": "webhook",
    "options": {
      "ignoreBots": false
    }
  }
}
```

### Multiple Content Sources

```javascript
// Rotate between different RSS feeds
const sources = [
  'https://feeds.feedburner.com/oreilly/radar',
  'https://techcrunch.com/category/artificial-intelligence/feed/',
  'https://www.docker.com/blog/feed/'
];

const todayIndex = new Date().getDay() % sources.length;
const selectedSource = sources[todayIndex];
```

### Enhanced Image Generation

```javascript
// More specific image prompts
const imagePrompts = {
  'devops': 'Professional DevOps illustration with CI/CD pipeline, modern tech aesthetic',
  'ai': 'Clean AI/ML visualization with neural networks, futuristic but professional',
  'cloud': 'Cloud computing diagram with modern icons, professional color scheme',
  'kubernetes': 'Kubernetes architecture diagram, clean and technical'
};
```

## Testing & Debugging

1. **Test Individual Nodes**
   - Right-click any node → "Execute Node"
   - Check output data format

2. **Debug Content Generation**
   - Monitor OpenAI API usage
   - Adjust prompts based on output quality

3. **LinkedIn API Limits**
   - Personal profiles: 100 posts/day
   - Company pages: 25 posts/day

## Monitoring & Optimization

### Performance Metrics
- Track engagement rates in Google Sheets
- Monitor follower growth
- A/B test different content styles

### Content Quality Improvements
- Analyze top-performing posts
- Refine AI prompts based on engagement
- Update keyword filters regularly

## Troubleshooting

### Common Issues

1. **LinkedIn API Errors**
   - Check token expiration
   - Verify app permissions
   - Rate limit handling

2. **Content Quality Issues**
   - Refine AI prompts
   - Add content validation
   - Implement fallback content

3. **Image Generation Failures**
   - Add error handling
   - Implement image fallbacks
   - Monitor DALL-E credits

## Security Best Practices

- Store API keys in n8n credentials (encrypted)
- Use environment variables for sensitive data
- Regularly rotate API keys
- Monitor API usage and costs

## Cost Optimization

- **OpenAI**: ~$0.02 per post (GPT-4 + DALL-E)
- **LinkedIn API**: Free tier available
- **Google Sheets**: Free for basic usage

Monthly cost estimate: ~$15-30 for daily posts

## Next Steps

1. Import the workflow JSON into n8n
2. Configure all credentials
3. Test with manual execution
4. Enable the cron trigger
5. Monitor first few automated posts
6. Optimize based on performance

Happy automating! 🚀
