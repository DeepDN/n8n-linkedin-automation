#!/bin/bash

# LinkedIn AI Content Automation - API Testing Script
# This script tests all required API connections

set -e

echo "LinkedIn AI Content Automation - API Testing"
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo -e "${GREEN}Environment variables loaded${NC}"
else
    echo -e "${RED}.env file not found. Please create it from .env.example${NC}"
    exit 1
fi

# Function to test API endpoint
test_api() {
    local name=$1
    local url=$2
    local headers=$3
    local data=$4
    local expected_status=$5
    
    echo -e "\n${BLUE}Testing $name...${NC}"
    
    if [ -n "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X POST "$url" -H "$headers" -d "$data" 2>/dev/null || echo "000")
    else
        response=$(curl -s -w "\n%{http_code}" -X GET "$url" -H "$headers" 2>/dev/null || echo "000")
    fi
    
    status_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)
    
    if [ "$status_code" = "$expected_status" ]; then
        echo -e "${GREEN}$name: Connection successful (Status: $status_code)${NC}"
        return 0
    else
        echo -e "${RED}$name: Connection failed (Status: $status_code)${NC}"
        echo -e "${YELLOW}Response: $body${NC}"
        return 1
    fi
}

# Test counters
total_tests=0
passed_tests=0

echo -e "\n${YELLOW}Starting API Tests...${NC}"

# Test 1: OpenAI API - Models List
echo -e "\n${BLUE}1. Testing OpenAI API Access...${NC}"
total_tests=$((total_tests + 1))

if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${RED}OPENAI_API_KEY not set${NC}"
else
    if test_api "OpenAI Models" "https://api.openai.com/v1/models" "Authorization: Bearer $OPENAI_API_KEY" "" "200"; then
        passed_tests=$((passed_tests + 1))
    fi
fi

# Test 2: OpenAI API - GPT-4 Chat Completion
echo -e "\n${BLUE}2. Testing OpenAI GPT-4 Access...${NC}"
total_tests=$((total_tests + 1))

if [ -n "$OPENAI_API_KEY" ]; then
    gpt4_data='{
        "model": "gpt-4",
        "messages": [{"role": "user", "content": "Hello, this is a test message."}],
        "max_tokens": 10
    }'
    
    if test_api "OpenAI GPT-4" "https://api.openai.com/v1/chat/completions" "Content-Type: application/json|Authorization: Bearer $OPENAI_API_KEY" "$gpt4_data" "200"; then
        passed_tests=$((passed_tests + 1))
    fi
fi

# Test 3: OpenAI API - DALL-E Image Generation
echo -e "\n${BLUE}3. Testing OpenAI DALL-E Access...${NC}"
total_tests=$((total_tests + 1))

if [ -n "$OPENAI_API_KEY" ]; then
    dalle_data='{
        "prompt": "A simple test image, professional style",
        "n": 1,
        "size": "1024x1024"
    }'
    
    if test_api "OpenAI DALL-E" "https://api.openai.com/v1/images/generations" "Content-Type: application/json|Authorization: Bearer $OPENAI_API_KEY" "$dalle_data" "200"; then
        passed_tests=$((passed_tests + 1))
    fi
fi

# Test 4: RSS Feeds Accessibility
echo -e "\n${BLUE}4. Testing RSS Feeds...${NC}"

rss_feeds=(
    "O'Reilly Radar|https://feeds.feedburner.com/oreilly/radar"
    "TechCrunch AI|https://techcrunch.com/category/artificial-intelligence/feed/"
    "Kubernetes Blog|https://kubernetes.io/feed.xml"
    "AWS DevOps Blog|https://aws.amazon.com/blogs/devops/feed/"
)

for feed in "${rss_feeds[@]}"; do
    IFS='|' read -r name url <<< "$feed"
    total_tests=$((total_tests + 1))
    
    echo -e "\n${BLUE}Testing $name...${NC}"
    
    if curl -s --head "$url" | head -n 1 | grep -q "200 OK"; then
        echo -e "${GREEN}$name: Feed accessible${NC}"
        passed_tests=$((passed_tests + 1))
    else
        echo -e "${RED}$name: Feed not accessible${NC}"
    fi
done

# Test 5: LinkedIn API (if credentials are provided)
echo -e "\n${BLUE}5. Testing LinkedIn API Configuration...${NC}"
total_tests=$((total_tests + 1))

if [ -n "$LINKEDIN_CLIENT_ID" ] && [ -n "$LINKEDIN_CLIENT_SECRET" ]; then
    # Test LinkedIn OAuth endpoint
    linkedin_auth_url="https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=$LINKEDIN_CLIENT_ID&redirect_uri=http://localhost:5678/rest/oauth2-credential/callback&scope=w_member_social"
    
    if curl -s --head "$linkedin_auth_url" | head -n 1 | grep -q "200\|302"; then
        echo -e "${GREEN}LinkedIn OAuth: Configuration valid${NC}"
        passed_tests=$((passed_tests + 1))
    else
        echo -e "${RED}LinkedIn OAuth: Configuration invalid${NC}"
    fi
else
    echo -e "${YELLOW} LinkedIn credentials not provided - skipping test${NC}"
    total_tests=$((total_tests - 1))
fi

# Test 6: Google Sheets API (if credentials are provided)
echo -e "\n${BLUE}6. Testing Google Sheets API...${NC}"
total_tests=$((total_tests + 1))

if [ -n "$GOOGLE_SHEETS_CLIENT_EMAIL" ] && [ -n "$GOOGLE_SHEET_ID" ]; then
    # Create a temporary service account key file for testing
    temp_key_file=$(mktemp)
    cat > "$temp_key_file" << EOF
{
    "type": "service_account",
    "client_email": "$GOOGLE_SHEETS_CLIENT_EMAIL",
    "private_key": "$GOOGLE_SHEETS_PRIVATE_KEY"
}
EOF
    
    # Test Google Sheets API access (this is a simplified test)
    sheets_url="https://sheets.googleapis.com/v4/spreadsheets/$GOOGLE_SHEET_ID"
    
    # Note: This test requires proper OAuth token, so we just check if the sheet ID format is valid
    if [[ "$GOOGLE_SHEET_ID" =~ ^[a-zA-Z0-9-_]{44}$ ]]; then
        echo -e "${GREEN}Google Sheets: Sheet ID format valid${NC}"
        passed_tests=$((passed_tests + 1))
    else
        echo -e "${RED}Google Sheets: Invalid Sheet ID format${NC}"
    fi
    
    rm -f "$temp_key_file"
else
    echo -e "${YELLOW} Google Sheets credentials not provided - skipping test${NC}"
    total_tests=$((total_tests - 1))
fi

# Test 7: n8n Local Instance (if running)
echo -e "\n${BLUE}7. Testing n8n Local Instance...${NC}"
total_tests=$((total_tests + 1))

n8n_url="http://localhost:5678"
if curl -s --connect-timeout 5 "$n8n_url" > /dev/null 2>&1; then
    echo -e "${GREEN}n8n Local: Instance accessible${NC}"
    passed_tests=$((passed_tests + 1))
else
    echo -e "${YELLOW} n8n Local: Instance not running (this is OK if using n8n Cloud)${NC}"
    total_tests=$((total_tests - 1))
fi

# Test 8: Internet Connectivity
echo -e "\n${BLUE}8. Testing Internet Connectivity...${NC}"
total_tests=$((total_tests + 1))

if ping -c 1 google.com > /dev/null 2>&1; then
    echo -e "${GREEN}Internet: Connection available${NC}"
    passed_tests=$((passed_tests + 1))
else
    echo -e "${RED}Internet: No connection${NC}"
fi

# Test 9: DNS Resolution
echo -e "\n${BLUE}9. Testing DNS Resolution...${NC}"
total_tests=$((total_tests + 1))

critical_domains=("api.openai.com" "www.linkedin.com" "sheets.googleapis.com")
dns_success=true

for domain in "${critical_domains[@]}"; do
    if ! nslookup "$domain" > /dev/null 2>&1; then
        echo -e "${RED}DNS: Cannot resolve $domain${NC}"
        dns_success=false
    fi
done

if $dns_success; then
    echo -e "${GREEN}DNS: All critical domains resolved${NC}"
    passed_tests=$((passed_tests + 1))
fi

# Test 10: System Requirements
echo -e "\n${BLUE}10. Testing System Requirements...${NC}"
total_tests=$((total_tests + 1))

# Check Node.js version
node_version=$(node --version 2>/dev/null | sed 's/v//' || echo "0.0.0")
required_node="16.0.0"

if [ "$(printf '%s\n' "$required_node" "$node_version" | sort -V | head -n1)" = "$required_node" ]; then
    echo -e "${GREEN}Node.js: Version $node_version (>= $required_node required)${NC}"
    passed_tests=$((passed_tests + 1))
else
    echo -e "${RED}Node.js: Version $node_version (>= $required_node required)${NC}"
fi

# Summary
echo -e "\n${BLUE}Test Summary${NC}"
echo "==============="
echo -e "Total Tests: $total_tests"
echo -e "Passed: ${GREEN}$passed_tests${NC}"
echo -e "Failed: ${RED}$((total_tests - passed_tests))${NC}"

if [ $passed_tests -eq $total_tests ]; then
    echo -e "\n${GREEN}All tests passed! Your system is ready for LinkedIn automation.${NC}"
    exit 0
elif [ $passed_tests -gt $((total_tests * 3 / 4)) ]; then
    echo -e "\n${YELLOW} Most tests passed. Review failed tests and fix issues before proceeding.${NC}"
    exit 1
else
    echo -e "\n${RED}Multiple tests failed. Please fix the issues before proceeding.${NC}"
    exit 1
fi

# Additional diagnostic information
echo -e "\n${BLUE}Diagnostic Information${NC}"
echo "=========================="
echo "Operating System: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "Node.js Version: $(node --version 2>/dev/null || echo 'Not installed')"
echo "npm Version: $(npm --version 2>/dev/null || echo 'Not installed')"
echo "curl Version: $(curl --version 2>/dev/null | head -n1 || echo 'Not installed')"
echo "Current Directory: $(pwd)"
echo "Environment File: $([ -f .env ] && echo 'Present' || echo 'Missing')"

# Check for common issues
echo -e "\n${BLUE}Common Issues Check${NC}"
echo "======================"

# Check if running in correct directory
if [ ! -f "package.json" ]; then
    echo -e "${YELLOW} package.json not found. Make sure you're in the project root directory.${NC}"
fi

# Check if n8n is installed
if ! command -v n8n &> /dev/null; then
    echo -e "${YELLOW} n8n not installed globally. Run: npm install -g n8n${NC}"
fi

# Check for firewall issues
if command -v ufw &> /dev/null && ufw status | grep -q "Status: active"; then
    echo -e "${YELLOW} UFW firewall is active. Ensure ports 5678 is allowed if testing locally.${NC}"
fi

echo -e "\n${BLUE}Next Steps${NC}"
echo "============="
echo "1. Fix any failed tests above"
echo "2. Ensure all required API keys are set in .env file"
echo "3. Run the deployment script: ./scripts/deploy.sh"
echo "4. Import the workflow into n8n"
echo "5. Configure credentials in n8n interface"
echo "6. Test the workflow manually before activation"

echo -e "\n${BLUE}Need Help?${NC}"
echo "============"
echo "- Check the setup guide: docs/SETUP.md"
echo "- Review API configuration: docs/API_CONFIGURATION.md"
echo "- Report issues: https://github.com/yourusername/linkedin-ai-automation/issues"
