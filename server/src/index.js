/* Middleware Server setup with detailed logging and error handling for proxying requests to a Spring Boot backend */
const express = require('express');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');
const axios = require('axios');

const app = express();
const port = 3001;

app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'UP' });
});

// Test endpoint to check if server is running
app.get('/test', (req, res) => {
    res.json({ status: 'Server is running' });
});

// Common error handler
const handleError = (error, res, operation) => {
    console.error(`=== Error ${operation} ===`);
    console.error('Error type:', error.name);
    console.error('Error message:', error.message);
    
    if (error.code === 'ECONNREFUSED') {
        console.error('Connection refused - Spring Boot server might be down');
        res.status(503).json({
            error: 'Spring Boot service is not available',
            details: 'Connection refused'
        });
    } else if (error.response) {
        console.error('Spring Boot error response:', {
            status: error.response.status,
            data: error.response.data
        });
        res.status(error.response.status).json({
            error: 'Backend error',
            details: error.response.data
        });
    } else if (error.code === 'ETIMEDOUT') {
        console.error('Request timed out');
        res.status(504).json({
            error: 'Request timed out',
            details: 'Spring Boot server took too long to respond'
        });
    } else {
        console.error('Unknown error:', error);
        res.status(500).json({
            error: `Failed to ${operation}`,
            details: error.message,
            type: error.name
        });
    }
};

// Get all users
app.get('/api/users', async (req, res) => {
    console.log('=== Received GET request for users ===');
    try {
        const response = await axios.get('https://banking-backend-63839693512.us-central1.run.app/api/users', {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            timeout: 10000
        });
        
        console.log('=== Response from Spring Boot ===');
        console.log('Status:', response.status);
        console.log('Data:', JSON.stringify(response.data, null, 2));

        if (Array.isArray(response.data)) {
            console.log(`Successfully retrieved ${response.data.length} users`);
            res.json(response.data);
        } else {
            console.error('Unexpected response format:', response.data);
            res.status(500).json({
                error: 'Invalid response format from backend',
                received: response.data
            });
        }
    } catch (error) {
        handleError(error, res, 'fetching users');
    }
});

// Create new user
app.post('/api/users', async (req, res) => {
    console.log('=== Received POST request to create user ===');
    console.log('Request body:', req.body);
    
    try {
        const response = await axios.post('https://banking-backend-63839693512.us-central1.run.app/api/users', req.body, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            timeout: 5000
        });
        
        console.log('=== User created successfully ===');
        console.log('Status:', response.status);
        console.log('Data:', response.data);
        
        res.status(201).json(response.data);
    } catch (error) {
        handleError(error, res, 'creating user');
    }
});

// Update user
app.put('/api/users/:id', async (req, res) => {
    const userId = req.params.id;
    console.log(`=== Received PUT request to update user ${userId} ===`);
    console.log('Request body:', req.body);
    
    try {
        const response = await axios.put(`https://banking-backend-63839693512.us-central1.run.app/api/users/${userId}`, req.body, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            timeout: 10000
        });
        
        console.log('=== User updated successfully ===');
        console.log('Status:', response.status);
        console.log('Data:', response.data);
        
        res.json(response.data);
    } catch (error) {
        handleError(error, res, 'updating user');
    }
});

// Delete user
app.delete('/api/users/:id', async (req, res) => {
    const userId = req.params.id;
    console.log(`=== Received DELETE request for user ${userId} ===`);
    
    try {
        const response = await axios.delete(`https://banking-backend-63839693512.us-central1.run.app/api/users/${userId}`, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            timeout: 10000
        });
        
        console.log('=== User deleted successfully ===');
        console.log('Status:', response.status);
        
        res.status(204).send();
    } catch (error) {
        handleError(error, res, 'deleting user');
    }
});


app.use('/api', createProxyMiddleware({
    target: 'https://banking-backend-63839693512.us-central1.run.app',
    changeOrigin: true,
    onProxyReq: (proxyReq, req) => {
        console.log('Proxying request:', req.method, req.url);
    },
    onProxyRes: (proxyRes, req) => {
        console.log('Received response:', proxyRes.statusCode, req.url);
    },
    onError: (err, req, res) => {
        console.error('Proxy error:', err);
        res.status(503).json({ error: 'Backend service unavailable', details: err.message });
    }
}));

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
