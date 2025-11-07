-- Initialize PostgreSQL Schema for GrinMates
-- Run this script first to set up the database schema

-- Users Table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_address VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE,
  full_name VARCHAR(255),
  bio TEXT,
  profile_image_url VARCHAR(500),
  phone_number VARCHAR(20),
  country VARCHAR(100),
  language VARCHAR(10) DEFAULT 'en',
  two_factor_enabled BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP
);

-- KYC Data Table
CREATE TABLE kyc_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  date_of_birth DATE,
  nationality VARCHAR(100),
  identity_document_type VARCHAR(50),
  identity_document_url VARCHAR(500),
  proof_of_address_url VARCHAR(500),
  selfie_url VARCHAR(500),
  address VARCHAR(500),
  city VARCHAR(100),
  postal_code VARCHAR(20),
  country VARCHAR(100),
  kyc_status VARCHAR(50) DEFAULT 'pending', -- pending, approved, rejected, expired
  rejection_reason TEXT,
  verified_by VARCHAR(255),
  verified_at TIMESTAMP,
  expiry_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id) -- Only one active KYC per user
);

-- Wallet Transactions Table
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  transaction_hash VARCHAR(255) UNIQUE NOT NULL,
  transaction_type VARCHAR(50), -- send, receive, stake, swap
  token_symbol VARCHAR(50),
  amount NUMERIC(20, 8),
  usd_value NUMERIC(15, 2),
  recipient_address VARCHAR(255),
  status VARCHAR(50) DEFAULT 'pending', -- pending, completed, failed
  gas_fee NUMERIC(20, 8),
  blockchain_network VARCHAR(50) DEFAULT 'celo',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  confirmed_at TIMESTAMP
);

-- Green Points Table
CREATE TABLE green_points (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  points_earned INTEGER,
  activity_type VARCHAR(100), -- donation, eco_service, referral, etc.
  description TEXT,
  reference_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User Balance Table
CREATE TABLE balances (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  celo_balance NUMERIC(20, 8) DEFAULT 0,
  cusd_balance NUMERIC(20, 8) DEFAULT 0,
  green_points_balance INTEGER DEFAULT 0,
  total_donated NUMERIC(15, 2) DEFAULT 0,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sessions Table (for authentication)
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token VARCHAR(1000) NOT NULL,
  device_name VARCHAR(255),
  device_type VARCHAR(50),
  ip_address VARCHAR(50),
  user_agent TEXT,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit Log Table
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  action VARCHAR(255),
  entity_type VARCHAR(100),
  entity_id VARCHAR(255),
  old_values JSONB,
  new_values JSONB,
  ip_address VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Indexes for Performance
CREATE INDEX idx_users_wallet_address ON users(wallet_address);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_kyc_data_user_id ON kyc_data(user_id);
CREATE INDEX idx_kyc_data_status ON kyc_data(kyc_status);
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_hash ON transactions(transaction_hash);
CREATE INDEX idx_green_points_user_id ON green_points(user_id);
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_token ON sessions(token);
CREATE INDEX idx_balances_user_id ON balances(user_id);

-- Create Updated_at Trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_kyc_data_updated_at BEFORE UPDATE ON kyc_data FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
