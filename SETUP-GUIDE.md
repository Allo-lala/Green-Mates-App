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

## Issues Fixed

### 1. Onboarding Image Loading
- **Issue**: Images were referenced but not displayed, showing loading icons instead
- **Fix**: Updated `onboarding_page.dart` with proper `Image.asset()` display and error handling with fallback to icons

### 2. MetaMask Infinite Load
- **Issue**: Connection stayed loading indefinitely
- **Fix**: 
  - Added connection state flags (`_isConnecting`) to prevent multiple simultaneous connections
  - Set proper timeouts (20s for URI generation, 60s for session confirmation)
  - Added proper error handling and retry logic (max 3 attempts with exponential backoff)
  - Moved ProjectID to environment variables for flexibility

### 3. Environment Variables
- **Issue**: ProjectID was hardcoded in code
- **Fix**: Implemented `.env` file support using `flutter_dotenv` package

### 4. Wallet Screen Content
- **Issue**: Wallet tab showed green points content instead of wallet data
- **Fix**: 
  - Rewrote `wallet_screen.dart` to display actual wallet balances
  - Connected to MetaMask service for real balance retrieval
  - Fixed navigation in `home_screen.dart` (case 4 now properly routes to WalletScreen)

### 5. KYC Flow Integration
- **Issue**: KYC screen required userId but wasn't called after login
- **Fix**: 
  - Made userId optional in KYCScreen
  - Updated login flow to navigate to KYCScreen after successful MetaMask connection
  - KYC now appears as the mandatory next step after wallet connection

### 6. Database Integration
- **Issue**: No production database setup
- **Fix**: 
  - Created PostgreSQL schema with users, KYC data, transactions, balances tables
  - Added `database_service.dart` for database operations
  - Includes proper indexing and audit logging for compliance

## Authentication Flow

1. **Splash Screen** → Shows onboarding to new users
2. **Login Screen** → Users can connect MetaMask or create/import wallet
3. **MetaMask Connection** → Wallet address is retrieved
4. **KYC Screen** → Mandatory verification (3 steps: personal info, address, documents)
5. **Home Screen** → Access to all app features after KYC submission

## Next Steps for Production

1. **Backend API**: Set up Node.js/Express backend to handle:
   - KYC document verification
   - User authentication
   - Transaction recording
   - Balance queries

2. **File Upload**: Configure cloud storage (AWS S3, Google Cloud Storage) for KYC documents

3. **Email Verification**: Add email confirmation for security

4. **Two-Factor Authentication**: Enable 2FA option for wallet security

5. **Testing**: Run comprehensive testing:
   \`\`\`bash
   flutter test
   \`\`\`

6. **Deployment**: Use Codemagic or EAS Build for CI/CD pipeline

## Support

For issues or questions, refer to the individual feature documentation or create an issue in the repository.
