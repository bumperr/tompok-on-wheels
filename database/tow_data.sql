-- Detailed Malaysian Cat-Specific Fake Data Generation

-- Malaysian-style Cat Owner Names
WITH malaysian_cat_owners(first_name, last_name, gender, email_prefix) AS (
    VALUES 
    ('Aminah', 'Abdullah', 'female', 'aminah'),
    ('Siti', 'Mohamed', 'female', 'siti'),
    ('Nur', 'Ismail', 'female', 'nur'),
    ('Ahmad', 'Rahman', 'male', 'ahmad'),
    ('Muhammad', 'Hassan', 'male', 'muhammad'),
    ('Fatimah', 'Ali', 'female', 'fatimah'),
    ('Zaki', 'Ibrahim', 'male', 'zaki'),
    ('Raihana', 'Yusof', 'female', 'raihana'),
    ('Farid', 'Shaari', 'male', 'farid'),
    ('Nadia', 'Hamid', 'female', 'nadia')
),
malaysian_cat_names(name, gender) AS (
    VALUES 
    ('Milo', 'male'),
    ('Luna', 'female'),
    ('Whiskers', 'male'),
    ('Bella', 'female'),
    ('Smokey', 'male'),
    ('Nala', 'female'),
    ('Tiger', 'male'),
    ('Coco', 'female'),
    ('Simba', 'male'),
    ('Mittens', 'female')
),
malaysian_cat_breeds(breed, origin_country) AS (
    VALUES 
    ('Siamese', 'Thailand'),
    ('Persian', 'Iran'),
    ('Maine Coon', 'United States'),
    ('Domestic Shorthair', 'Mixed Breed'),
    ('British Shorthair', 'United Kingdom'),
    ('Russian Blue', 'Russia'),
    ('Bengal', 'United States')
),
malaysian_cities(city, state) AS (
    VALUES 
    ('Kuala Lumpur', 'Wilayah Persekutuan'), 
    ('George Town', 'Pulau Pinang'), 
    ('Johor Bahru', 'Johor'), 
    ('Malacca City', 'Melaka'), 
    ('Shah Alam', 'Selangor'),
    ('Ipoh', 'Perak'),
    ('Cyberjaya', 'Selangor'),
    ('Petaling Jaya', 'Selangor')
),
malaysian_phone_prefixes(prefix) AS (
    VALUES ('017'), ('018'), ('019'), ('014'), ('011'), ('016')
)

-- Prepare for data insertion
BEGIN;

-- Ensure Cat Type Exists
INSERT INTO pet_types (name, description, size_category, special_handling_required) 
VALUES ('Cat', 'Feline companion', 'small', false)
ON CONFLICT (name) DO NOTHING;

-- Generate Cat Owners
WITH generated_users AS (
    INSERT INTO users (
        role_id, 
        email, 
        password_hash, 
        salt, 
        first_name, 
        last_name, 
        phone, 
        status
    )
    SELECT 
        (SELECT role_id FROM user_roles WHERE name = 'pet_owner'),
        lower(email_prefix || '.' || last_name || '@example.com'),
        md5(random()::text), -- Use proper hashing in production
        md5(random()::text),
        first_name,
        last_name,
        (SELECT prefix FROM malaysian_phone_prefixes ORDER BY RANDOM() LIMIT 1) || 
        lpad(floor(random() * 10000000)::text, 7, '0'),
        'active'
    FROM malaysian_cat_owners
    RETURNING user_id, first_name, last_name
)

-- Generate Cats
INSERT INTO pets (
    user_id, 
    type_id, 
    name, 
    breed, 
    age, 
    weight, 
    medical_notes, 
    special_requirements,
    vaccination_status,
    last_vet_visit
)
SELECT 
    gu.user_id,
    (SELECT type_id FROM pet_types WHERE name = 'Cat'),
    cn.name,
    cb.breed,
    floor(random() * 15 + 1), -- Age between 1-15
    CASE 
        WHEN cb.breed IN ('Maine Coon', 'Bengal') THEN round((random() * 8 + 5)::numeric, 2) -- Larger breeds
        ELSE round((random() * 5 + 2)::numeric, 2) -- Smaller breeds
    END,
    CASE 
        WHEN random() < 0.2 THEN 'Requires special diet' 
        WHEN random() < 0.1 THEN 'Mild allergies' 
        ELSE NULL 
    END,
    CASE 
        WHEN random() < 0.1 THEN 'Indoor cat only' 
        WHEN random() < 0.05 THEN 'Needs medication' 
        ELSE NULL 
    END,
    random() < 0.9, -- Vaccination status
    CURRENT_DATE - (random() * 365 * 2)::int -- Last vet visit within past 2 years
FROM 
    generated_users gu,
    malaysian_cat_names cn,
    malaysian_cat_breeds cb
WHERE 
    random() < 0.8 -- Not all owners will have a cat
LIMIT 50;

-- Generate Cat-Specific Service Providers
WITH cat_service_providers AS (
    INSERT INTO service_providers (
        user_id, 
        category_id, 
        name, 
        address, 
        phone, 
        email, 
        verification_status
    )
    SELECT 
        u.user_id,
        spc.category_id,
        CASE spc.name
            WHEN 'Veterinary Clinic' THEN 
                (ARRAY['Kucing Care Veterinary', 'Feline Friends Clinic', 'Whiskers & Paws Vet'])[floor(random()*3 + 1)]
            WHEN 'Pet Grooming' THEN 
                (ARRAY['Purr-fect Grooming', 'Cat Spa Salon', 'Meow Makeover'])[floor(random()*3 + 1)]
            WHEN 'Pet Boarding' THEN 
                (ARRAY['Kitty Haven', 'Feline Retreat', 'Cat Castle Boarding'])[floor(random()*3 + 1)]
        END,
        (SELECT city || ', ' || state FROM malaysian_cities ORDER BY RANDOM() LIMIT 1),
        (SELECT prefix FROM malaysian_phone_prefixes ORDER BY RANDOM() LIMIT 1) || 
        lpad(floor(random() * 10000000)::text, 7, '0'),
        lower(
            replace(
                CASE spc.name
                    WHEN 'Veterinary Clinic' THEN 'Kucing Care Veterinary'
                    WHEN 'Pet Grooming' THEN 'Purr-fect Grooming'
                    ELSE 'Kitty Haven'
                END, 
                ' ', 
                ''
            ) || '@petservice.com'
        ),
        true
    FROM 
        users u
    CROSS JOIN 
        service_provider_categories spc
    WHERE 
        u.role_id = (SELECT role_id FROM user_roles WHERE name = 'vet_provider')
    LIMIT 10
    RETURNING provider_id, name
)

-- Generate Services for Cat Providers
INSERT INTO services (
    provider_id, 
    name, 
    description, 
    price, 
    duration_minutes,
    max_capacity,
    special_requirements
)
SELECT 
    csp.provider_id,
    CASE 
        WHEN random() < 0.4 THEN 'Regular Cat Check-up'
        WHEN random() < 0.7 THEN 'Cat Vaccination Package'
        ELSE 'Emergency Feline Consultation'
    END,
    CASE 
        WHEN random() < 0.4 THEN 'Comprehensive health examination for cats'
        WHEN random() < 0.7 THEN 'Complete vaccination and health screening'
        ELSE 'Urgent medical consultation for feline emergencies'
    END,
    CASE 
        WHEN random() < 0.4 THEN round((random() * 100 + 50)::numeric, 2)
        WHEN random() < 0.7 THEN round((random() * 200 + 150)::numeric, 2)
        ELSE round((random() * 300 + 250)::numeric, 2)
    END,
    CASE 
        WHEN random() < 0.4 THEN 30
        WHEN random() < 0.7 THEN 45
        ELSE 60
    END,
    1,
    CASE 
        WHEN random() < 0.2 THEN 'Requires advanced booking'
        WHEN random() < 0.1 THEN 'Limited slots available'
        ELSE NULL
    END
FROM 
    cat_service_providers csp
LIMIT 30;

COMMIT;

-- Optional: Create some sample indexes if not already created
CREATE INDEX IF NOT EXISTS idx_pets_user_id ON pets(user_id);
CREATE INDEX IF NOT EXISTS idx_pets_breed ON pets(breed);
CREATE INDEX IF NOT EXISTS idx_services_provider_id ON services(provider_id);