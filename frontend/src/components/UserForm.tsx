import React, { useState, useEffect } from 'react';
import { Button, TextField, Dialog, DialogTitle, DialogContent, DialogActions, Typography } from '@mui/material';
import { User } from '../types/User';

interface UserFormProps {
  open: boolean;
  onClose: () => void;
  user: User | null;
  onSave: (user: User) => void;
}

const UserForm: React.FC<UserFormProps> = ({ open, onClose, user, onSave }) => {
  const [formData, setFormData] = useState<Partial<User>>({
    name: '',
    address: '',
    creditLimit: 0
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (user) {
      setFormData(user);
    } else {
      setFormData({
        name: '',
        address: '',
        creditLimit: 0
      });
    }
    setErrors({});
  }, [user, open]);

  const validateForm = (): boolean => {
    const newErrors: Record<string, string> = {};
    
    if (!formData.name?.trim()) {
      newErrors.name = 'Name is required';
    }
    
    if (!formData.address?.trim()) {
      newErrors.address = 'Address is required';
    }
    
    if (formData.creditLimit === undefined || formData.creditLimit < 0) {
      newErrors.creditLimit = 'Credit limit must be a positive number';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    const newValue = name === 'creditLimit' ? Number(value) : value;
    
    setFormData(prev => ({
      ...prev,
      [name]: newValue
    }));
    
    // Clear error when user types
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  };

  const handleSubmit = async () => {
    if (validateForm()) {
      setIsSubmitting(true);
      try {
        await onSave(formData as User);
        onClose();
      } catch (error) {
        console.error('Error submitting form:', error);
        setErrors(prev => ({
          ...prev,
          submit: 'Failed to save user. Please try again.'
        }));
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  return (
    <Dialog 
      open={open} 
      onClose={onClose}
      maxWidth="sm"
      fullWidth
    >
      <DialogTitle>{user ? 'Edit User' : 'Add New User'}</DialogTitle>
      <DialogContent>
        {errors.submit && (
          <Typography color="error" variant="body2" sx={{ mb: 2 }}>
            {errors.submit}
          </Typography>
        )}
        <TextField
          fullWidth
          margin="dense"
          label="Name"
          name="name"
          value={formData.name || ''}
          onChange={handleChange}
          error={!!errors.name}
          helperText={errors.name}
          disabled={isSubmitting}
          required
        />
        <TextField
          fullWidth
          margin="dense"
          label="Address"
          name="address"
          value={formData.address || ''}
          onChange={handleChange}
          error={!!errors.address}
          helperText={errors.address}
          disabled={isSubmitting}
          required
          multiline
          rows={2}
        />
        <TextField
          fullWidth
          margin="dense"
          label="Credit Limit"
          name="creditLimit"
          type="number"
          value={formData.creditLimit || ''}
          onChange={handleChange}
          error={!!errors.creditLimit}
          helperText={errors.creditLimit}
          disabled={isSubmitting}
          required
          inputProps={{ min: 0 }}
        />
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose} disabled={isSubmitting}>
          Cancel
        </Button>
        <Button 
          onClick={handleSubmit} 
          variant="contained" 
          color="primary"
          disabled={isSubmitting}
        >
          {isSubmitting ? 'Saving...' : (user ? 'Save' : 'Add')}
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default UserForm;
