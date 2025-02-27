\c tompok_on_wheels
-- Insert into user_roles
INSERT INTO user_roles (name) VALUES
('Pet Owner'),
('Tompokker'),
('Service Provider');

-- Insert into users (Pet Owners, Tompokkers, Service Providers)
INSERT INTO users (role_id, email, password_hash, first_name, last_name, phone, picture, mime_type) VALUES
-- Pet Owners
(1, 'ali.ahmad@example.com', 'hash123', 'Ali', 'Ahmad', '0123456789', NULL, NULL),
(1, 'siti.kamarul@example.com', 'hash456', 'Siti', 'Kamarul', '0112345678', NULL, NULL),
(1, 'raj.kumar@example.com', 'hash789', 'Raj', 'Kumar', '0134567890', NULL, NULL),
-- Tompokkers
(2, 'ahmad.farhan@example.com', 'hash101', 'Ahmad', 'Farhan', '0145678901', NULL, NULL),
(2, 'nurul.aini@example.com', 'hash202', 'Nurul', 'Aini', '0156789012', NULL, NULL),
-- Service Providers
(3, 'petcare.kl@example.com', 'hash303', 'PetCare', 'KL', '0167890123', NULL, NULL),
(3, 'pawsome.grooming@example.com', 'hash404', 'Pawsome', 'Grooming', '0178901234', NULL, NULL);

-- Insert into pet_types
INSERT INTO pet_types (name) VALUES
('Dog'),
('Cat'),
('Bird'),
('Rabbit');

-- Insert into pets
INSERT INTO pets (user_id, type_id, name, breed, age, picture, mime_type, notes) VALUES
-- Ali Ahmad's pets
(1, 1, 'Max', 'Golden Retriever', 3, NULL, NULL, 'Friendly and loves to play fetch.'),
(1, 2, 'Milo', 'Siamese', 2, NULL, NULL, 'Loves to nap on the couch.'),
-- Siti Kamarul's pets
(2, 1, 'Buddy', 'Bulldog', 4, NULL, NULL, 'Loves long walks.'),
(2, 3, 'Tweety', 'Parakeet', 1, NULL, NULL, 'Loves to sing in the morning.'),
-- Raj Kumar's pets
(3, 4, 'Snowball', 'Holland Lop', 1, NULL, NULL, 'Loves carrots and lettuce.');

-- Insert into service_provider_categories
INSERT INTO service_provider_categories (name) VALUES
('Grooming'),
('Boarding'),
('Veterinary');

-- Insert into service_providers
INSERT INTO service_providers (user_id, category_id, name, address, phone, email, picture, mime_type) VALUES
-- PetCare KL (Grooming and Boarding)
(6, 1, 'PetCare KL', '123 Jalan Ampang, Kuala Lumpur', '0323456789', 'petcare.kl@example.com', NULL, NULL),
(6, 2, 'PetCare KL', '123 Jalan Ampang, Kuala Lumpur', '0323456789', 'petcare.kl@example.com', NULL, NULL),
-- Pawsome Grooming (Grooming)
(7, 1, 'Pawsome Grooming', '456 Jalan Bukit Bintang, Kuala Lumpur', '0334567890', 'pawsome.grooming@example.com', NULL, NULL);

-- Insert into services
INSERT INTO services (provider_id, name, description, price, duration_minutes) VALUES
-- PetCare KL Services
(1, 'Basic Grooming', 'Bath, brush, and nail trimming.', 50.00, 60),
(1, 'Full Grooming', 'Bath, haircut, nail trimming, and ear cleaning.', 80.00, 90),
(2, 'Overnight Boarding', 'Comfortable overnight stay for your pet.', 100.00, 1440),
-- Pawsome Grooming Services
(3, 'Deluxe Grooming', 'Bath, haircut, nail trimming, ear cleaning, and spa treatment.', 120.00, 120);

-- Insert into bookings
INSERT INTO bookings (user_id, pet_id, service_id, start_time, end_time, status) VALUES
-- Ali Ahmad's bookings
(1, 1, 1, '2023-10-15 10:00:00', '2023-10-15 11:00:00', 'Completed'),
(1, 2, 3, '2023-10-16 14:00:00', '2023-10-17 14:00:00', 'Scheduled'),
-- Siti Kamarul's bookings
(2, 3, 2, '2023-10-17 09:00:00', '2023-10-17 10:30:00', 'Scheduled');

-- Insert into trips
INSERT INTO trips (booking_id, tompokker_id, origin, destination, start_time, end_time, status) VALUES
-- Trip for Ali Ahmad's pet (Max)
(1, 4, '123 Jalan Tun Razak, Kuala Lumpur', '123 Jalan Ampang, Kuala Lumpur', '2023-10-15 09:30:00', '2023-10-15 10:00:00', 'Completed'),
-- Trip for Siti Kamarul's pet (Buddy)
(3, 5, '456 Jalan Pahang, Kuala Lumpur', '456 Jalan Bukit Bintang, Kuala Lumpur', '2023-10-17 08:30:00', '2023-10-17 09:00:00', 'Scheduled');

-- Insert into trip_tracking
INSERT INTO trip_tracking (trip_id, location) VALUES
(1, '123 Jalan Tun Razak, Kuala Lumpur'),
(1, 'Jalan Sultan Ismail, Kuala Lumpur'),
(1, '123 Jalan Ampang, Kuala Lumpur');

-- Insert into payment_methods
INSERT INTO payment_methods (name) VALUES
('Credit Card'),
('Touch n  Go eWallet'),
('GrabPay');

-- Insert into payments
INSERT INTO payments (trip_id, method_id, amount, status) VALUES
(1, 1, 50.00, 'Completed'),
(2, 2, 80.00, 'Pending');

-- Insert into reviews
INSERT INTO reviews (trip_id, rating, comment) VALUES
(1, 5, 'Excellent service! Max came back happy and clean.');

-- Insert into insurance_packages
INSERT INTO insurance_packages (name, description, price) VALUES
('Basic Plan', 'Covers accidents and illnesses.', 50.00),
('Premium Plan', 'Covers accidents, illnesses, and routine checkups.', 100.00);

-- Insert into insurance_purchases
INSERT INTO insurance_purchases (trip_id, package_id) VALUES
(1, 1);

-- Insert into subscription_plans
INSERT INTO subscription_plans (name, description, price, duration_days) VALUES
('Monthly Plan', 'Unlimited bookings for 30 days.', 30.00, 30),
('Yearly Plan', 'Unlimited bookings for 365 days.', 300.00, 365);

-- Insert into user_subscriptions
INSERT INTO user_subscriptions (user_id, plan_id, start_date, end_date) VALUES
(1, 1, '2023-10-01', '2023-10-31');