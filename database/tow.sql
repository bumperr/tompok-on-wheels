-- Improved Tompok on Wheels Database Design

-- Improvements and Rationale:
-- 1. Added more constraints and validations
-- 2. Improved data integrity
-- 3. Enhanced indexing and performance
-- 4. Added more comprehensive error handling
-- 5. Improved security and data management

-- Create the database
CREATE DATABASE tompok_on_wheels;

-- Connect to the database
\c tompok_on_wheels;

-- Enum Types for Consistent Status and Type Tracking
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'suspended');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'in_progress', 'completed', 'cancelled');
CREATE TYPE trip_status AS ENUM ('scheduled', 'in_transit', 'completed', 'cancelled');
CREATE TYPE payment_status AS ENUM ('pending', 'processing', 'completed', 'failed');
CREATE TYPE transaction_type AS ENUM ('credit', 'debit');
CREATE TYPE notification_type AS ENUM ('booking', 'trip', 'payment', 'message', 'system');

-- User Roles table with more comprehensive roles
CREATE TABLE user_roles (
  role_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users table with enhanced security and validation
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  role_id INTEGER REFERENCES user_roles(role_id),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  salt VARCHAR(50) NOT NULL, -- Additional security for password hashing
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) CHECK (phone ~ '^\+?[0-9]{10,14}$'), -- Validate phone number format
  picture BYTEA,
  mime_type VARCHAR(50),
  status user_status DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP,
  login_attempts INTEGER DEFAULT 0,
  locked_until TIMESTAMP,
  CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

-- Enhanced JWT Tokens table with stricter expiration and revocation
CREATE TABLE jwt_tokens (
  token_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  token TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NOT NULL,
  is_revoked BOOLEAN DEFAULT FALSE,
  revoked_at TIMESTAMP,
  CONSTRAINT token_not_expired CHECK (expires_at > CURRENT_TIMESTAMP)
);

-- Pet Types with more comprehensive categorization
CREATE TABLE pet_types (
  type_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  size_category VARCHAR(50), -- e.g., 'small', 'medium', 'large'
  special_handling_required BOOLEAN DEFAULT FALSE
);

-- Pets table with more detailed health and care information
CREATE TABLE pets (
  pet_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  type_id INTEGER REFERENCES pet_types(type_id),
  name VARCHAR(100) NOT NULL,
  breed VARCHAR(100),
  age INTEGER CHECK (age >= 0),
  weight NUMERIC(5,2), -- in kg
  picture BYTEA,
  mime_type VARCHAR(50),
  medical_notes TEXT,
  special_requirements TEXT,
  vaccination_status BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_vet_visit DATE
);

-- Service Provider Categories with more detailed classification
CREATE TABLE service_provider_categories (
  category_id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  requires_special_certification BOOLEAN DEFAULT FALSE
);

-- Service Providers with enhanced verification
CREATE TABLE service_providers (
  provider_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  category_id INTEGER REFERENCES service_provider_categories(category_id),
  name VARCHAR(255) NOT NULL,
  address TEXT NOT NULL,
  phone VARCHAR(20) CHECK (phone ~ '^\+?[0-9]{10,14}$'),
  email VARCHAR(255) NOT NULL,
  picture BYTEA,
  mime_type VARCHAR(50),
  verification_status BOOLEAN DEFAULT FALSE,
  verified_at TIMESTAMP,
  verification_notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

-- Services with more comprehensive pricing and availability
CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  provider_id INTEGER REFERENCES service_providers(provider_id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
  duration_minutes INTEGER CHECK (duration_minutes > 0),
  max_capacity INTEGER DEFAULT 1,
  is_available BOOLEAN DEFAULT TRUE,
  special_requirements TEXT
);

-- Bookings with more detailed tracking and validation
CREATE TABLE bookings (
  booking_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  pet_id INTEGER REFERENCES pets(pet_id),
  service_id INTEGER REFERENCES services(service_id),
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP,
  status booking_status DEFAULT 'pending',
  total_price NUMERIC(10,2) NOT NULL CHECK (total_price >= 0),
  special_instructions TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT valid_booking_times CHECK (end_time IS NULL OR end_time > start_time)
);

-- Trips with enhanced location and safety tracking
CREATE TABLE trips (
  trip_id SERIAL PRIMARY KEY,
  booking_id INTEGER REFERENCES bookings(booking_id),
  tompokker_id INTEGER REFERENCES users(user_id),
  origin TEXT NOT NULL,
  destination TEXT NOT NULL,
  start_location POINT, -- Geographic coordinates for start
  end_location POINT,   -- Geographic coordinates for end
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  status trip_status DEFAULT 'scheduled',
  distance_km NUMERIC(10,2),
  estimated_duration_minutes INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT valid_trip_times CHECK (end_time IS NULL OR end_time > start_time)
);

-- Trip Tracking with more precise location logging
CREATE TABLE trip_tracking (
  tracking_id SERIAL PRIMARY KEY,
  trip_id INTEGER REFERENCES trips(trip_id),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  location POINT, -- Geographic coordinates
  location_accuracy NUMERIC(10,2), -- Accuracy in meters
  speed NUMERIC(5,2), -- Speed in km/h
  heading NUMERIC(5,2) -- Direction in degrees
);

-- Payment Methods with extended support
CREATE TABLE payment_methods (
  method_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  provider VARCHAR(100),
  supports_recurring BOOLEAN DEFAULT FALSE
);

-- Payments with comprehensive transaction tracking
CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  trip_id INTEGER REFERENCES trips(trip_id),
  method_id INTEGER REFERENCES payment_methods(method_id),
  amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
  status payment_status DEFAULT 'pending',
  transaction_reference VARCHAR(255),
  error_message TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wallet with transaction logging and restrictions
CREATE TABLE wallets (
  wallet_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id) UNIQUE,
  balance NUMERIC(10,2) DEFAULT 0.00 CHECK (balance >= 0),
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE
);

-- Wallet Transactions with detailed tracking
CREATE TABLE wallet_transactions (
  transaction_id SERIAL PRIMARY KEY,
  wallet_id INTEGER REFERENCES wallets(wallet_id),
  amount NUMERIC(10,2) NOT NULL,
  type transaction_type NOT NULL,
  description TEXT,
  balance_after_transaction NUMERIC(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews with more comprehensive feedback
CREATE TABLE reviews (
  review_id SERIAL PRIMARY KEY,
  trip_id INTEGER REFERENCES trips(trip_id),
  rating INTEGER CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  driver_professionalism INTEGER CHECK (driver_professionalism BETWEEN 1 AND 5),
  vehicle_cleanliness INTEGER CHECK (vehicle_cleanliness BETWEEN 1 AND 5),
  pet_comfort_rating INTEGER CHECK (pet_comfort_rating BETWEEN 1 AND 5),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insurance Packages with more detailed coverage
CREATE TABLE insurance_packages (
  package_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
  max_coverage_amount NUMERIC(10,2),
  coverage_details JSONB, -- Flexible JSON for detailed coverage terms
  is_active BOOLEAN DEFAULT TRUE
);

-- Insurance Purchases with comprehensive tracking
CREATE TABLE insurance_purchases (
  purchase_id SERIAL PRIMARY KEY,
  trip_id INTEGER REFERENCES trips(trip_id),
  package_id INTEGER REFERENCES insurance_packages(package_id),
  purchase_price NUMERIC(10,2) NOT NULL,
  coverage_start TIMESTAMP,
  coverage_end TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subscription Plans with more flexible options
CREATE TABLE subscription_plans (
  plan_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
  duration_days INTEGER CHECK (duration_days > 0),
  max_trips INTEGER,
  additional_benefits JSONB
);

-- User Subscriptions with auto-renewal and status tracking
CREATE TABLE user_subscriptions (
  subscription_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  plan_id INTEGER REFERENCES subscription_plans(plan_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  is_auto_renew BOOLEAN DEFAULT FALSE,
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT valid_subscription_dates CHECK (end_date > start_date)
);

-- Messages with enhanced communication features
CREATE TABLE messages (
  message_id SERIAL PRIMARY KEY,
  sender_id INTEGER REFERENCES users(user_id),
  receiver_id INTEGER REFERENCES users(user_id),
  trip_id INTEGER REFERENCES trips(trip_id),
  message TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP,
  message_type VARCHAR(50), -- 'text', 'system', 'emergency', etc.
  attachment BYTEA,
  attachment_mime_type VARCHAR(50)
);

-- Notifications with more comprehensive tracking
CREATE TABLE notifications (
  notification_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  message TEXT NOT NULL,
  type notification_type NOT NULL,
  related_entity_id INTEGER, -- Can link to various entities like trip_id, booking_id, etc.
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Comprehensive Indexes for Performance Optimization
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_pets_user_id ON pets(user_id);
CREATE INDEX idx_bookings_user_id_status ON bookings(user_id, status);
CREATE INDEX idx_trips_tompokker_id_status ON trips(tompokker_id, status);
CREATE INDEX idx_trip_tracking_trip_id_timestamp ON trip_tracking(trip_id, timestamp);
CREATE INDEX idx_messages_sender_receiver ON messages(sender_id, receiver_id);
CREATE INDEX idx_notifications_user_id_type ON notifications(user_id, type);
CREATE INDEX idx_payments_trip_id_status ON payments(trip_id, status);

-- Optional: Add Full-Text Search Index for messages and descriptions
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_messages_full_text ON messages USING gin (to_tsvector('english', message));
CREATE INDEX idx_services_full_text ON services USING gin (to_tsvector('english', name || ' ' || description));