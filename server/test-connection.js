const axios = require('axios');

async function testSpringBootConnection() {
    try {
        console.log('Testing connection to Spring Boot...');
        const response = await axios.get('http://localhost:8080/api/users', {
            headers: {
                'Accept': 'application/json'
            }
        });
        console.log('Connection successful!');
        console.log('Status:', response.status);
        console.log('Data:', JSON.stringify(response.data, null, 2));
    } catch (error) {
        console.error('Connection test failed!');
        if (error.code === 'ECONNREFUSED') {
            console.error('Connection refused - Is Spring Boot running?');
        } else if (error.response) {
            console.error('Error response:', {
                status: error.response.status,
                data: error.response.data
            });
        } else {
            console.error('Error:', error.message);
        }
    }
}

testSpringBootConnection();
