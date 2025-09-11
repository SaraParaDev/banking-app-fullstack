import React, { useState } from 'react';
import UserList from './components/UserList';
import UserForm from './components/UserForm';
import { Container, Typography, Box, Button } from '@mui/material';
import { User } from './types/User';
import { userApi } from './services/userApi';

const App = () => {
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  const [isFormOpen, setIsFormOpen] = useState(false);

  const handleEditUser = (user: User) => {
    setSelectedUser(user);
    setIsFormOpen(true);
  };

  const handleAddUser = () => {
    setSelectedUser(null);
    setIsFormOpen(true);
  };

  const handleCloseForm = () => {
    setIsFormOpen(false);
    setSelectedUser(null);
  };

  const handleSaveUser = async (user: User): Promise<void> => {
    console.log('Saving user:', user);
    try {
      if (selectedUser) {
        console.log('Updating existing user with ID:', selectedUser.id);
        const response = await userApi.updateUser(selectedUser.id!, user);
        console.log('Update response:', response);
      } else {
        console.log('Creating new user');
        const response = await userApi.createUser(user);
        console.log('Create response:', response);
      }
      // Only close the form if the save was successful
      handleCloseForm();
    } catch (error: any) {
      console.error('Error saving user:', error);
      if (error.response) {
        console.error('Response error:', error.response.status, error.response.data);
        throw new Error(error.response.data.error || 'Failed to save user');
      } else if (error.request) {
        console.error('Request error:', error.request);
        throw new Error('Could not connect to server');
      } else {
        console.error('Other error:', error.message);
        throw new Error('An unexpected error occurred');
      }
    }
  };

  return (
    <Container maxWidth="lg">
      <Box sx={{ my: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Banking Application
        </Typography>
        <Button
          variant="contained"
          color="primary"
          onClick={handleAddUser}
          sx={{ mb: 2 }}
        >
          Add New User
        </Button>
        <UserList 
          onEdit={handleEditUser}
          isFormOpen={isFormOpen}
          onCloseForm={handleCloseForm}
          selectedUser={selectedUser}
        />
        <UserForm
          open={isFormOpen}
          onClose={handleCloseForm}
          onSave={handleSaveUser}
          user={selectedUser}
        />
      </Box>
    </Container>
  );
};

export default App;