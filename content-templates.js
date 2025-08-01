// Advanced Content Templates for LinkedIn AI Automation

// Post Templates by Category
const postTemplates = {
  devops: {
    hooks: [
      "🚀 DevOps teams are seeing 40% faster deployments with this approach...",
      "💡 Here's what most DevOps engineers get wrong about automation:",
      "🔧 Just discovered a game-changing DevOps practice that's saving teams hours:",
      "⚡ The DevOps trend that's quietly revolutionizing how we deploy:"
    ],
    structures: [
      "hook + insight + practical tip + CTA",
      "question + answer + example + discussion starter",
      "trend observation + personal experience + actionable advice"
    ]
  },
  
  ai: {
    hooks: [
      "🤖 AI is reshaping software development in ways we didn't expect...",
      "🧠 The AI breakthrough that's changing how developers work:",
      "💭 Most teams are using AI wrong. Here's the right approach:",
      "🎯 This AI tool just solved a problem that took us weeks:"
    ],
    structures: [
      "surprising fact + explanation + real-world application",
      "problem statement + AI solution + implementation tips",
      "trend analysis + personal insight + future prediction"
    ]
  },
  
  cloud: {
    hooks: [
      "☁️ Cloud costs spiraling out of control? Here's what we learned:",
      "🌩️ The cloud architecture mistake that cost us $50K:",
      "⚡ Multi-cloud strategy or vendor lock-in? Here's our take:",
      "🔒 Cloud security isn't what you think it is..."
    ]
  }
};

// Hashtag Strategies
const hashtagStrategies = {
  trending: [
    "#DevOps", "#CloudComputing", "#AI", "#MachineLearning", 
    "#Automation", "#TechTrends", "#Innovation"
  ],
  
  niche: [
    "#Kubernetes", "#Docker", "#Terraform", "#Jenkins", 
    "#AWS", "#Azure", "#GCP", "#Monitoring"
  ],
  
  community: [
    "#DevOpsCommunity", "#TechLeadership", "#SoftwareEngineering",
    "#CloudNative", "#SRE", "#Platform Engineering"
  ],
  
  engagement: [
    "#TechTalk", "#LearningInPublic", "#TechTips", 
    "#DeveloperLife", "#TechInsights"
  ]
};

// Content Quality Checkers
const contentValidation = {
  checkLength: (text) => text.length <= 1300,
  
  hasCallToAction: (text) => {
    const ctaPatterns = [
      /what.*think/i, /share.*experience/i, /thoughts/i,
      /comment/i, /discuss/i, /agree/i, /disagree/i
    ];
    return ctaPatterns.some(pattern => pattern.test(text));
  },
  
  hasEmojis: (text) => /[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]/u.test(text),
  
  isEngaging: (text) => {
    const engagementWords = ['discover', 'learn', 'insight', 'tip', 'secret', 'mistake', 'breakthrough'];
    return engagementWords.some(word => text.toLowerCase().includes(word));
  }
};

// Image Generation Prompts
const imagePrompts = {
  devops: [
    "Modern DevOps pipeline visualization with clean geometric shapes, professional blue and white color scheme, minimalist tech aesthetic",
    "CI/CD workflow diagram with modern icons, clean lines, professional color palette, suitable for LinkedIn",
    "DevOps tools integration graphic, modern flat design, tech-focused, professional presentation"
  ],
  
  ai: [
    "Abstract AI neural network visualization, clean modern design, professional color scheme with blues and whites",
    "Machine learning concept illustration, geometric patterns, professional tech aesthetic, LinkedIn-appropriate",
    "AI automation concept with clean icons and modern typography, professional presentation"
  ],
  
  cloud: [
    "Cloud architecture diagram with modern icons, clean professional design, suitable for business social media",
    "Multi-cloud infrastructure visualization, modern flat design, professional color scheme",
    "Cloud computing concept with clean geometric shapes, professional tech aesthetic"
  ]
};

// Advanced Prompt Engineering
const promptTemplates = {
  postGeneration: `
    Create an engaging LinkedIn post for DevOps/AI professionals based on this content:
    
    Title: {title}
    Description: {description}
    URL: {url}
    Category: {category}
    
    Requirements:
    - Target audience: Senior developers, DevOps engineers, tech leaders
    - Tone: Professional but conversational, thought-provoking
    - Length: 800-1200 characters (leave room for hashtags)
    - Structure: Hook + Insight + Practical value + Call to action
    - Include 1-2 relevant emojis (not excessive)
    - Make it discussion-worthy
    - Avoid buzzwords and hype
    - Focus on practical insights and real-world applications
    
    Style guidelines:
    - Start with an attention-grabbing hook
    - Share a specific insight or learning
    - Provide actionable advice or perspective
    - End with a question or discussion starter
    - Use line breaks for readability
    
    Do NOT include hashtags in the response.
  `,
  
  hashtagGeneration: `
    Generate 10-12 strategic hashtags for this LinkedIn post about {category}:
    
    Post content: {postContent}
    
    Hashtag strategy:
    - 3-4 broad trending tags (#DevOps, #AI, #CloudComputing)
    - 3-4 specific technical tags related to the content
    - 2-3 community/engagement tags (#TechLeadership, #DevOpsCommunity)
    - 1-2 niche tags for targeted reach
    
    Requirements:
    - Mix of high-volume and niche hashtags
    - Relevant to the content and audience
    - Include both trending and evergreen tags
    - Format: #HashTag #AnotherTag (space-separated)
    - No explanations, just the hashtags
  `,
  
  imageGeneration: `
    Create a professional LinkedIn-appropriate image for a post about: {topic}
    
    Style requirements:
    - Clean, modern, professional aesthetic
    - Color scheme: Blues, whites, grays (LinkedIn-friendly)
    - Minimalist design with clear visual hierarchy
    - Tech-focused but not overly complex
    - Suitable for business social media
    - No text overlay needed
    - High contrast for mobile viewing
    - Professional illustration style, not photorealistic
    
    Visual elements to include:
    - Relevant tech icons or symbols
    - Clean geometric shapes
    - Modern typography elements (if any)
    - Professional color gradients
    
    Avoid:
    - Cluttered designs
    - Bright, flashy colors
    - Comic or cartoon styles
    - Text overlays
    - Stock photo aesthetics
  `
};

// Content Scheduling Strategy
const schedulingStrategy = {
  // Best posting times for tech content (UTC)
  optimalTimes: [
    { day: 'tuesday', hour: 9 },    // 2:30 PM IST
    { day: 'wednesday', hour: 10 },  // 3:30 PM IST
    { day: 'thursday', hour: 8 },    // 1:30 PM IST
  ],
  
  // Content themes by day
  contentThemes: {
    monday: 'motivation',
    tuesday: 'technical-deep-dive',
    wednesday: 'industry-trends',
    thursday: 'tools-and-tips',
    friday: 'community-discussion'
  }
};

// Export for use in n8n workflow
module.exports = {
  postTemplates,
  hashtagStrategies,
  contentValidation,
  imagePrompts,
  promptTemplates,
  schedulingStrategy
};
