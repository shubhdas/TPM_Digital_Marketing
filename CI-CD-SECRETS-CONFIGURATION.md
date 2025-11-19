# CI/CD Pipeline Secrets Configuration

## Required GitHub Repository Secrets

### 🔐 Dev Hub Secrets
These secrets are needed for authenticating to your Salesforce Dev Hub:

1. **SFDX_AUTH_URL** - JWT authentication URL for your Dev Hub org
2. **CONSUMER_KEY** - Consumer key from your Connected App configured in Dev Hub
3. **DEV_HUB_USERNAME** - Username of your Dev Hub org

### 🔐 Dev Org Secrets  
These secrets are needed for authenticating to your Development org:

1. **DEV_ORG_AUTH_URL** - JWT authentication URL for your Dev org
2. **CONSUMER_KEY** - Consumer key from your Connected App configured in Dev org (same as above)
3. **DEV_ORG_USERNAME** - Username of your Dev org

### 🔐 Prod Org Secrets
These secrets are needed for authenticating to your Production org:

1. **PROD_ORG_AUTH_URL** - JWT authentication URL for your Prod org
2. **CONSUMER_KEY** - Consumer key from your Connected App configured in Prod org (same as above)
3. **PROD_ORG_USERNAME** - Username of your Prod org

## How to Configure These Secrets

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret" for each required secret
4. Enter the secret name and value as specified above

## Important Notes

- The **CONSUMER_KEY** should be the same across all three environments if you're using the same Connected App
- The **SFDX_AUTH_URL** values should be base64 encoded JWT tokens for each respective org
- Make sure your Connected Apps are properly configured in each org with the correct callback URLs
- All orgs (Dev Hub, Dev, and Prod) must have the same Connected App configured with appropriate permissions
