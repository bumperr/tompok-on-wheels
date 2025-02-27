-- 1. User Management Functions

-- 1.1. Create a New User
CREATE OR REPLACE FUNCTION create_user(
  role_id INTEGER,
  email VARCHAR(255),
  password_hash VARCHAR(255),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone VARCHAR(20),
  picture BYTEA,
  mime_type VARCHAR(50)
) RETURNS TABLE(user_id INTEGER, created_at TIMESTAMP) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO users (role_id, email, password_hash, first_name, last_name, phone, picture, mime_type)
  VALUES (role_id, email, password_hash, first_name, last_name, phone, picture, mime_type)
  RETURNING users.user_id, users.created_at;
END;
$$ LANGUAGE plpgsql;

-- 1.2. Get User by ID
CREATE OR REPLACE FUNCTION get_user_by_id(
  user_id INTEGER
) RETURNS TABLE(
  user_id INTEGER,
  role_id INTEGER,
  email VARCHAR(255),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone VARCHAR(20),
  picture BYTEA,
  mime_type VARCHAR(50),
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM users WHERE users.user_id = get_user_by_id.user_id;
END;
$$ LANGUAGE plpgsql;

-- 1.3. Update User Profile
CREATE OR REPLACE FUNCTION update_user(
  user_id INTEGER,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone VARCHAR(20),
  picture BYTEA,
  mime_type VARCHAR(50)
) RETURNS VOID AS $$
BEGIN
  UPDATE users
  SET
    first_name = update_user.first_name,
    last_name = update_user.last_name,
    phone = update_user.phone,
    picture = update_user.picture,
    mime_type = update_user.mime_type
  WHERE users.user_id = update_user.user_id;
END;
$$ LANGUAGE plpgsql;


-- 2. Pet Management Functions

-- 2.1. Add a New Pet
CREATE OR REPLACE FUNCTION add_pet(
  user_id INTEGER,
  type_id INTEGER,
  name VARCHAR(100),
  breed VARCHAR(100),
  age INTEGER,
  picture BYTEA,
  mime_type VARCHAR(50),
  notes TEXT
) RETURNS TABLE(pet_id INTEGER, created_at TIMESTAMP) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO pets (user_id, type_id, name, breed, age, picture, mime_type, notes)
  VALUES (user_id, type_id, name, breed, age, picture, mime_type, notes)
  RETURNING pets.pet_id, pets.created_at;
END;
$$ LANGUAGE plpgsql;

-- 2.2. Get Pets by User ID
CREATE OR REPLACE FUNCTION get_pets_by_user_id(
  user_id INTEGER
) RETURNS TABLE(
  pet_id INTEGER,
  type_id INTEGER,
  name VARCHAR(100),
  breed VARCHAR(100),
  age INTEGER,
  picture BYTEA,
  mime_type VARCHAR(50),
  notes TEXT,
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM pets WHERE pets.user_id = get_pets_by_user_id.user_id;
END;
$$ LANGUAGE plpgsql;

-- 2.3. Update Pet Details
CREATE OR REPLACE FUNCTION update_pet(
  pet_id INTEGER,
  name VARCHAR(100),
  breed VARCHAR(100),
  age INTEGER,
  picture BYTEA,
  mime_type VARCHAR(50),
  notes TEXT
) RETURNS VOID AS $$
BEGIN
  UPDATE pets
  SET
    name = update_pet.name,
    breed = update_pet.breed,
    age = update_pet.age,
    picture = update_pet.picture,
    mime_type = update_pet.mime_type,
    notes = update_pet.notes
  WHERE pets.pet_id = update_pet.pet_id;
END;
$$ LANGUAGE plpgsql;


-- 3. Booking Management Functions

-- 3.1. Create a New Booking
CREATE OR REPLACE FUNCTION create_booking(
  user_id INTEGER,
  pet_id INTEGER,
  service_id INTEGER,
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  status VARCHAR(50)
) RETURNS TABLE(booking_id INTEGER, created_at TIMESTAMP) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO bookings (user_id, pet_id, service_id, start_time, end_time, status)
  VALUES (user_id, pet_id, service_id, start_time, end_time, status)
  RETURNING bookings.booking_id, bookings.created_at;
END;
$$ LANGUAGE plpgsql;

-- 3.2. Get Bookings by User ID
CREATE OR REPLACE FUNCTION get_bookings_by_user_id(
  user_id INTEGER
) RETURNS TABLE(
  booking_id INTEGER,
  pet_id INTEGER,
  service_id INTEGER,
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  status VARCHAR(50),
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM bookings WHERE bookings.user_id = get_bookings_by_user_id.user_id;
END;
$$ LANGUAGE plpgsql;

-- 3.3. Update Booking Status
CREATE OR REPLACE FUNCTION update_booking_status(
  booking_id INTEGER,
  status VARCHAR(50)
) RETURNS VOID AS $$
BEGIN
  UPDATE bookings
  SET status = update_booking_status.status
  WHERE bookings.booking_id = update_booking_status.booking_id;
END;
$$ LANGUAGE plpgsql;


-- 4. Trip Management Functions

-- 4.1. Create a New Trip
CREATE OR REPLACE FUNCTION create_trip(
  booking_id INTEGER,
  tompokker_id INTEGER,
  origin TEXT,
  destination TEXT,
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  status VARCHAR(50)
) RETURNS TABLE(trip_id INTEGER, created_at TIMESTAMP) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO trips (booking_id, tompokker_id, origin, destination, start_time, end_time, status)
  VALUES (booking_id, tompokker_id, origin, destination, start_time, end_time, status)
  RETURNING trips.trip_id, trips.created_at;
END;
$$ LANGUAGE plpgsql;

-- 4.2. Get Trips by Tompokker ID
CREATE OR REPLACE FUNCTION get_trips_by_tompokker_id(
  tompokker_id INTEGER
) RETURNS TABLE(
  trip_id INTEGER,
  booking_id INTEGER,
  origin TEXT,
  destination TEXT,
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  status VARCHAR(50),
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM trips WHERE trips.tompokker_id = get_trips_by_tompokker_id.tompokker_id;
END;
$$ LANGUAGE plpgsql;

-- 4.3. Update Trip Status
CREATE OR REPLACE FUNCTION update_trip_status(
  trip_id INTEGER,
  status VARCHAR(50)
) RETURNS VOID AS $$
BEGIN
  UPDATE trips
  SET status = update_trip_status.status
  WHERE trips.trip_id = update_trip_status.trip_id;
END;
$$ LANGUAGE plpgsql;


-- 5. Payment Management Functions

-- 5.1. Create a New Payment
CREATE OR REPLACE FUNCTION create_payment(
  trip_id INTEGER,
  method_id INTEGER,
  amount NUMERIC(10,2),
  status VARCHAR(50)
) RETURNS TABLE(payment_id INTEGER, created_at TIMESTAMP) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO payments (trip_id, method_id, amount, status)
  VALUES (trip_id, method_id, amount, status)
  RETURNING payments.payment_id, payments.created_at;
END;
$$ LANGUAGE plpgsql;

-- 5.2. Get Payments by Trip ID
CREATE OR REPLACE FUNCTION get_payments_by_trip_id(
  trip_id INTEGER
) RETURNS TABLE(
  payment_id INTEGER,
  method_id INTEGER,
  amount NUMERIC(10,2),
  status VARCHAR(50),
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM payments WHERE payments.trip_id = get_payments_by_trip_id.trip_id;
END;
$$ LANGUAGE plpgsql;


-- 6. Review Management Functions

-- 6.1. Create a New Review
CREATE OR REPLACE FUNCTION create_review(
  trip_id INTEGER,
  rating INTEGER,
  comment TEXT
) RETURNS TABLE(review_id INTEGER, created_at TIMESTAMP) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO reviews (trip_id, rating, comment)
  VALUES (trip_id, rating, comment)
  RETURNING reviews.review_id, reviews.created_at;
END;
$$ LANGUAGE plpgsql;

-- 6.2. Get Reviews by Trip ID
CREATE OR REPLACE FUNCTION get_reviews_by_trip_id(
  trip_id INTEGER
) RETURNS TABLE(
  review_id INTEGER,
  rating INTEGER,
  comment TEXT,
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM reviews WHERE reviews.trip_id = get_reviews_by_trip_id.trip_id;
END;
$$ LANGUAGE plpgsql;