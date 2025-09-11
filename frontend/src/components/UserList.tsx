import React, { useState, useEffect } from 'react';
import {
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    Paper,
    IconButton,
    Box,
    Button
} from '@mui/material';
import { Edit as EditIcon, Delete as DeleteIcon } from '@mui/icons-material';
import { User } from '../types/User';
import { userApi } from '../services/userApi';

interface UserListProps {
    onEdit: (user: User) => void;
    isFormOpen: boolean;
    onCloseForm: () => void;
    selectedUser: User | null;
}

const UserList: React.FC<UserListProps> = ({ onEdit, isFormOpen, onCloseForm, selectedUser }) => {
    const [users, setUsers] = useState<User[]>([]);
    const [error, setError] = useState<string | null>(null);
    const [loading, setLoading] = useState<boolean>(true);

    const loadUsers = async () => {
        try {
            setLoading(true);
            console.log('=== Fetching users from Node.js server ===');
            const response = await userApi.getAllUsers();
            console.log('=== Response received ===');
            console.log('Status:', response.status);
            console.log('Data:', response.data);
            
            if (response && Array.isArray(response.data)) {
                console.log(`=== Setting ${response.data.length} users ===`);
                setUsers(response.data);
                setError(null);
            } else {
                console.error('Invalid response format:', response.data);
                setError('Invalid response format from server');
            }
        } catch (error: any) {
            console.error('=== Error loading users ===');
            console.error('Error:', error);
            if (error.response) {
                console.error('Response error:', error.response.status, error.response.data);
                setError(`Server error: ${error.response.data.error || 'Unknown error'}`);
            } else if (error.request) {
                console.error('Request error:', error.request);
                setError('Could not connect to server');
            } else {
                console.error('Other error:', error.message);
                setError(`Error: ${error.message}`);
            }
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadUsers();
    }, [isFormOpen]); // Reload when form closes

    const handleDelete = async (userId: number) => {
        try {
            console.log('=== Attempting to delete user ===', userId);
            const response = await userApi.deleteUser(userId);
            console.log('=== Delete response ===', response);
            await loadUsers(); // Reload the users list after successful deletion
            setError(null); // Clear any previous errors
        } catch (error: any) {
            console.error('=== Error deleting user ===');
            console.error('Error:', error);
            if (error.response) {
                console.error('Response error:', error.response.status, error.response.data);
                setError(`Delete failed: ${error.response.data.error || error.response.statusText}`);
            } else if (error.request) {
                console.error('Request error:', error.request);
                setError('Could not reach server to delete user');
            } else {
                console.error('Other error:', error.message);
                setError(`Delete failed: ${error.message}`);
            }
        }
    };

    return (
        <TableContainer component={Paper}>
            {error && (
                <Box sx={{ p: 2, color: 'error.main' }}>
                    {error}
                    <Button 
                        variant="contained" 
                        size="small" 
                        onClick={loadUsers}
                        sx={{ ml: 2 }}
                    >
                        Retry
                    </Button>
                </Box>
            )}
            {loading ? (
                <Box sx={{ p: 2, textAlign: 'center' }}>Loading users...</Box>
            ) : (
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>Name</TableCell>
                            <TableCell>Account Number</TableCell>
                            <TableCell>Address</TableCell>
                            <TableCell>Credit Limit</TableCell>
                            <TableCell>Actions</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {users.map((user) => (
                            <TableRow key={user.id}>
                                <TableCell>{user.name}</TableCell>
                                <TableCell>{user.accountNumber}</TableCell>
                                <TableCell>{user.address}</TableCell>
                                <TableCell>{user.creditLimit}</TableCell>
                                <TableCell>
                                    <IconButton
                                        color="primary"
                                        onClick={() => onEdit(user)}
                                    >
                                        <EditIcon />
                                    </IconButton>
                                    <IconButton
                                        color="error"
                                        onClick={() => {
                                            if (user.id === undefined) {
                                                setError('Cannot delete user: no ID found');
                                                return;
                                            }
                                            handleDelete(user.id);
                                        }}
                                    >
                                        <DeleteIcon />
                                    </IconButton>
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            )}
        </TableContainer>
    );
};

export default UserList;