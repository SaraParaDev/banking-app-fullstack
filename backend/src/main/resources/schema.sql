-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    account_number VARCHAR(20) UNIQUE NOT NULL,
    credit_limit NUMERIC(15,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit table
CREATE TABLE IF NOT EXISTS audit (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    operation VARCHAR(10), -- UPDATE or DELETE
    old_data JSONB,
    new_data JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
