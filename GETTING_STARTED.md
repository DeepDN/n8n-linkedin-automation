# Getting Started Guide

## Quick Setup (5 minutes)

### 1. Choose Your Workflow

**For beginners:** Start with `workflows/working-linkedin-workflow.json`
- 5 nodes, simple structure
- RSS → AI → LinkedIn flow
- Production ready

**For advanced users:** Use `workflows/enhanced-workflow-clean.json`
- 9 nodes with smart filtering
- Quality gates and fallback systems
- Advanced content scoring

### 2. Import to n8n Cloud

1. Go to your [n8n Cloud](https://n8n.cloud) instance
2. Click "Import from File"
3. Select your chosen workflow file
4. Click "Import"

### 3. Configure Credentials

You need these API keys:

**OpenAI (Required)**
- Go to [OpenAI Platform](https://platform.openai.com/api-keys)
- Create new API key
- Add to n8n: Settings → Credentials → OpenAI

**LinkedIn (Required)**
- Go to [LinkedIn Developer Portal](https://developer.linkedin.com/apps)
- Create app with "Share on LinkedIn" permission
- Add to n8n: Settings → Credentials → LinkedIn OAuth2

### 4. Test & Activate

1. **Test individual nodes** - Click "Execute Node" on each
2. **Check connections** - Verify all credentials work
3. **Run full workflow** - Execute the entire flow once
4. **Activate workflow** - Toggle to "Active" when ready

## File Guide

| File | Purpose | When to Use |
|------|---------|-------------|
| `working-linkedin-workflow.json` | Main workflow | Start here |
| `enhanced-workflow-clean.json` | Advanced features | After basic setup works |
| `basic-workflow-fixed.json` | Minimal version | Troubleshooting |

## Configuration Files

- **`config/.env.example`** - Environment variables template
- **`docs/SETUP.md`** - Detailed setup instructions
- **`docs/API_CONFIGURATION.md`** - API setup guide
- **`deploy.sh`** - Automated deployment script

## Quick Commands

```bash
# Deploy to n8n Cloud
./deploy.sh

# Check environment setup
cat config/.env.example
```

## Need Help?

1. **Import Issues:** Try `working-linkedin-workflow.json` first
2. **API Errors:** Check `docs/API_CONFIGURATION.md`
3. **Setup Problems:** See `docs/SETUP.md`

## Next Steps

Once your basic workflow is running:
1. Customize content themes in the workflow
2. Adjust posting schedule (cron expression)
3. Add Google Sheets logging (optional)
4. Monitor performance and optimize

---

**Ready to automate your LinkedIn presence!**
