import axios from 'axios';
import { User } from '../types/User';

const BASE_URL = 'http://localhost:3001/api';

export const userApi = {
    getAllUsers: () => axios.get<User[]>(`${BASE_URL}/users`),
    getUser: (id: number) => axios.get<User>(`${BASE_URL}/users/${id}`),
    createUser: (user: User) => axios.post<User>(`${BASE_URL}/users`, user),
    updateUser: (id: number, user: User) => axios.put<User>(`${BASE_URL}/users/${id}`, user),
    deleteUser: (id: number) => axios.delete(`${BASE_URL}/users/${id}`),
};
