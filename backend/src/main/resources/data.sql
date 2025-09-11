INSERT INTO users (name, address, account_number, credit_limit) 
VALUES 
('John Doe', '123 Main St', 'ACC001', 10000.00),
('Jane Smith', '456 Oak Ave', 'ACC002', 15000.00),
('Mike Johnson', '789 Pine Rd', 'ACC003', 20000.00)
ON CONFLICT (account_number) DO NOTHING;
