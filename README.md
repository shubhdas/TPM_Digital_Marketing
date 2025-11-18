# Salesforce Digital Marketing CRM

A comprehensive digital marketing management system built on Salesforce with modern CI/CD practices.

## Project Structure

This project follows a standard Salesforce DX structure with the following key components:

```
.
├── force-app/                 # Main source directory
│   ├── main/                  # Default package
│   │   └── default/
│   │       ├── classes/       # Apex classes
│   │       ├── objects/       # Custom objects
│   │       ├── triggers/      # Triggers
│   │       ├── lwc/           # Lightning Web Components
│   │       └── pages/         # Visualforce pages
├── config/                    # Configuration files
├── scripts/                   # Deployment scripts
├── .github/workflows/         # GitHub Actions workflows
└── README.md                  # This file
```

## Branching Strategy

This project implements a GitFlow-inspired branching strategy for smooth CI/CD:

### Main Branches
- **main**: Production-ready code
- **develop**: Integration branch for features
- **feature/**: Feature branches for new development
- **release/**: Release preparation branches
- **hotfix/**: Emergency fixes for production

### Branch Naming Convention
- `feature/feature-name` - For new features
- `release/vX.X.X` - For release preparation
- `hotfix/issue-number` - For urgent fixes
- `bugfix/issue-number` - For bug fixes

## CI/CD Pipeline

### Deployment Scripts

The project includes deployment scripts in the `scripts/` directory:

1. **scripts/deploy-dev.sh** - Deploy to development org
2. **scripts/deploy-staging.sh** - Deploy to staging org  
3. **scripts/deploy-prod.sh** - Deploy to production org
4. **scripts/create-scratch.sh** - Create a new scratch org

### Environment Configuration

Configuration files are stored in the `config/` directory:
- `config/dev-scratch-def.json` - Scratch org definition for development
- `config/staging-scratch-def.json` - Scratch org definition for staging
- `config/prod-scratch-def.json` - Scratch org definition for production

## Deployment Process

### 1. Development Workflow
1. Create feature branch from `develop`: `git checkout -b feature/new-feature develop`
2. Implement changes
3. Commit and push to feature branch
4. Create Pull Request to `develop`
5. Code review and merge

### 2. Release Workflow
1. Create release branch from `develop`: `git checkout -b release/v1.2.0 develop`
2. Final testing and bug fixes
3. Merge to `main` and `develop`
4. Tag the release: `git tag v1.2.0`
5. Push tags: `git push origin v1.2.0`

### 3. Hotfix Workflow
1. Create hotfix branch from `main`: `git checkout -b hotfix/urgent-fix main`
2. Fix the issue
3. Test the fix
4. Merge to `main` and `develop`
5. Tag the release: `git tag v1.2.1`
6. Push tags: `git push origin v1.2.1`

## Prerequisites

- Salesforce CLI installed
- Node.js 14.x or higher
- Git installed

## Getting Started

1. Clone the repository
2. Install dependencies: `npm install`
3. Authorize your org: `sfdx force:auth:web:login -d -r https://test.salesforce.com`
4. Deploy to org: `sfdx force:source:deploy -p force-app`

## Automated Testing

This project includes automated testing:
- Apex unit tests
- LWC component tests
- Validation scripts

Run tests with: `sfdx force:apex:test:run`

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -am 'Add your feature'`
4. Push to branch: `git push origin feature/your-feature`
5. Create pull request

## License

MIT License
