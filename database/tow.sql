-- Create the database
CREATE DATABASE tompok_on_wheels;

-- Connect to the database
\c tompok_on_wheels;

-- User Roles table
CREATE TABLE user_roles (
  role_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL
);

-- Users table (with picture stored as binary data)
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  role_id INTEGER REFERENCES user_roles(role_id),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone VARCHAR(20),
  picture BYTEA, -- Binary data for the user's profile picture
  mime_type VARCHAR(50), -- MIME type of the image (e.g., 'image/jpeg', 'image/png')
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE
);

-- JWT Tokens table for managing active sessions
CREATE TABLE jwt_tokens (
  token_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  token TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NOT NULL
);

-- Pet Types table
CREATE TABLE pet_types (
  type_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Pets table (with picture stored as binary data)
CREATE TABLE pets (
  pet_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  type_id INTEGER REFERENCES pet_types(type_id),
  name VARCHAR(100),
  breed VARCHAR(100),
  age INTEGER,
  picture BYTEA, -- Binary data for the pet's picture
  mime_type VARCHAR(50), -- MIME type of the image
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Service Provider Categories table
CREATE TABLE service_provider_categories (
  category_id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL
);

-- Service Providers table (with picture column)
-- Service Providers table (with picture stored as binary data)
CREATE TABLE service_providers (
  provider_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  category_id INTEGER REFERENCES service_provider_categories(category_id),
  name VARCHAR(255) NOT NULL,
  address TEXT,
  phone VARCHAR(20),
  email VARCHAR(255),
  picture BYTEA, -- Binary data for the service provider's logo or picture
  mime_type VARCHAR(50), -- MIME type of the image
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Services table
CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  provider_id INTEGER REFERENCES service_providers(provider_id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL,
  duration_minutes INTEGER
);

-- Bookings table
CREATE TABLE bookings (
  booking_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  pet_id INTEGER REFERENCES pets(pet_id),
  service_id INTEGER REFERENCES services(service_id),
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP,
  status VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trips table
CREATE TABLE trips (
  trip_id SERIAL PRIMARY KEY,
  booking_id INTEGER REFERENCES bookings(booking_id),
  tompokker_id INTEGER REFERENCES users(user_id),
  origin TEXT NOT NULL,
  destination TEXT NOT NULL,
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  status VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trip Tracking table
CREATE TABLE trip_tracking (
  tracking_id SERIAL PRIMARY KEY,
  trip_id INTEGER REFERENCES trips(trip_id),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  location TEXT
);

-- Payment Methods table
CREATE TABLE payment_methods (
  method_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Payments table
CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  trip_id INTEGER REFERENCES trips(trip_id),
  method_id INTEGER REFERENCES payment_methods(method_id),
  amount NUMERIC(10,2) NOT NULL,
  status VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wallet table for Tompokkers
CREATE TABLE wallets (
  wallet_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  balance NUMERIC(10,2) DEFAULT 0.00,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wallet Transactions table
CREATE TABLE wallet_transactions (
  transaction_id SERIAL PRIMARY KEY,
  wallet_id INTEGER REFERENCES wallets(wallet_id),
  amount NUMERIC(10,2) NOT NULL,
  type VARCHAR(50), -- 'credit' or 'debit'
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews table
CREATE TABLE reviews (
  review_id SERIAL PRIMARY KEY,
  trip_id INTEGER REFERENCES trips(trip_id),
  rating INTEGER CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insurance Packages table
CREATE TABLE insurance_packages (
  package_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL
);

-- Insurance Purchases table
CREATE TABLE insurance_purchases (
  purchase_id SERIAL PRIMARY KEY,
  trip_id INTEGER REFERENCES trips(trip_id),
  package_id INTEGER REFERENCES insurance_packages(package_id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subscription Plans table
CREATE TABLE subscription_plans (
  plan_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL,
  duration_days INTEGER
);

-- User Subscriptions table
CREATE TABLE user_subscriptions (
  subscription_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  plan_id INTEGER REFERENCES subscription_plans(plan_id),
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Messages table for real-time communication
CREATE TABLE messages (
  message_id SERIAL PRIMARY KEY,
  sender_id INTEGER REFERENCES users(user_id),
  receiver_id INTEGER REFERENCES users(user_id),
  message TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP
);

-- Notifications table for real-time notifications
CREATE TABLE notifications (
  notification_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(user_id),
  message TEXT NOT NULL,
  type VARCHAR(50), -- 'booking', 'payment', 'trip', etc.
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance optimization
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_pets_user_id ON pets(user_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_trips_tompokker_id ON trips(tompokker_id);
CREATE INDEX idx_trip_tracking_trip_id ON trip_tracking(trip_id);
CREATE INDEX idx_messages_sender_receiver ON messages(sender_id, receiver_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);