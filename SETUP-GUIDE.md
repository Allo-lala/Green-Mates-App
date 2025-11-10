# GrinMates Flutter App - Production Setup Guide

## Quick Start

### 1. Environment Variables Setup

Copy `.env.example` to `.env` and fill in your values:

\`\`\`bash
cp .env.example .env
\`\`\`

Key environment variables to configure:

- **WALLET_CONNECT_PROJECT_ID**: Get from [WalletConnect Cloud](https://cloud.walletconnect.com)
- **DATABASE_URL**: PostgreSQL connection string
- **JWT_SECRET**: Generate a strong random secret
- **ENCRYPTION_KEY**: For secure data storage

### 2. PostgreSQL Database Setup

1. Create a PostgreSQL database:
   \`\`\`bash
   createdb grinmates_db
   \`\`\`

2. Run the schema initialization script:
   \`\`\`bash
   psql -U grinmates_user -d grinmates_db -f scripts/01_init_schema.sql
   \`\`\`

### 3. Flutter Dependencies

Install all dependencies:
\`\`\`bash
flutter pub get
\`\`\`

### 4. Run the App

Development:
\`\`\`bash
flutter run
\`\`\`

Production build:
\`\`\`bash
flutter build apk --release  # Android
flutter build ios --release   # iOS
\`\`\`

## Authentication Flow

## Next Steps for Production

1. **Backend API**: Set up Node.js/Express backend to handle:
   - KYC document verification
   - User authentication
   - Transaction recording
   - Balance queries

2. **File Upload**: Configure cloud storage (AWS S3, Google Cloud Storage) for KYC documents

4. **Two-Factor Authentication**: Enable 2FA option for wallet security

5. **Testing**: Run comprehensive testing:
   \`\`\`bash
   flutter test
   \`\`\`

6. **Deployment**: Use Codemagic or EAS Build for CI/CD pipeline
