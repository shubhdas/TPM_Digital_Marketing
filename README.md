# Salesforce Digital Marketing CRM

A comprehensive Salesforce CRM solution for managing digital marketing operations including Leads, Clients, Campaigns, Projects, and Billing.

## Project Overview

This project implements a complete digital marketing management system built on Salesforce with:
- Custom objects for Leads, Clients, Campaigns, Projects, and Billing
- Apex controllers with full CRUD operations
- Lightning Web Components for the user interface
- Automated deployment and CI/CD pipeline
- GitFlow branching strategy implementation
- Enhanced Lightning Experience with personalization features

## Features

### Core Functionality
- Lead management with status tracking
- Client relationship management
- Campaign planning and tracking
- Project management with timeline controls
- Billing and invoicing system

### Technical Features
- Full CRUD operations for all entities
- Proper error handling and validation
- Security checks and user permissions
- Responsive Lightning Web Components
- Automated testing framework
- Multi-environment deployment scripts
- GitHub Actions CI/CD pipeline
- Lightning Experience personalization capabilities

## Repository Structure

```
.
├── force-app/                    # Salesforce source code
│   └── main/
│       └── default/
│           ├── apps/              # Application definitions
│           ├── classes/           # Apex classes
│           ├── lwc/               # Lightning Web Components
│           ├── objects/           # Custom objects
│           ├── pages/             # Visualforce pages
│           ├── permissionsets/    # Permission sets
│           ├── flexipages/        # Lightning App Pages (enhanced)
│           ├── lightningapps/     # Lightning Apps (enhanced)
│           └── triggers/          # Apex triggers
├── config/                       # Environment configurations
├── scripts/                      # Deployment scripts
├── .github/workflows/            # CI/CD pipeline
└── README.md                     # This file
```

## Setup Instructions

### Prerequisites
- Salesforce CLI installed
- Salesforce DX Developer Hub
- Git installed

### Installation Steps
1. Clone this repository to your local machine
2. Authorize your Dev Hub org:
   ```bash
   sf org login web --set-default-dev-hub --alias dev-hub
   ```
3. Create a scratch org:
   ```bash
   sf org create scratch --definition-file config/dev-scratch-def.json --alias digital-marketing-dev
   ```
4. Deploy the source code:
   ```bash
   sf deploy metadata --source-dir force-app/main/default
   ```

## Deployment Scripts

Cross-platform deployment scripts are provided:
- `scripts/deploy-dev.bat` - Deploy to development org (Windows)
- `scripts/deploy-dev.sh` - Deploy to development org (Linux/Mac)
- `scripts/deploy-staging.bat` - Deploy to staging org (Windows)
- `scripts/deploy-staging.sh` - Deploy to staging org (Linux/Mac)
- `scripts/deploy-prod.bat` - Deploy to production org (Windows)
- `scripts/deploy-prod.sh` - Deploy to production org (Linux/Mac)
- `scripts/create-scratch.bat` - Create a new scratch org (Windows)
- `scripts/create-scratch.sh` - Create a new scratch org (Linux/Mac)
- `scripts/deploy-lightning-experience.bat` - Deploy with Lightning Experience enhancements (Windows)
- `scripts/deploy-lightning-experience.sh` - Deploy with Lightning Experience enhancements (Linux/Mac)

> Note: On Linux/Mac systems, you may need to make the shell script executable with `chmod +x scripts/deploy-lightning-experience.sh` before running it.

## CI/CD Pipeline

The project includes a GitHub Actions workflow that automates testing and deployment:
- `.github/workflows/ci-cd-pipeline.yml`

## Branching Strategy

This project follows GitFlow branching strategy:
- `main` - Production-ready code
- `develop` - Integration branch
- `feature/*` - Feature branches
- `release/*` - Release preparation branches
- `hotfix/*` - Emergency fixes

## Lightning Experience Enhancements

This application now supports enhanced Lightning Experience features including:
- Customizable dashboard with personalization options
- Flexible Lightning App Page structure
- User preference persistence
- Improved UI/UX with responsive design

## License

This project is licensed under the MIT License.
