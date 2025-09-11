package com.example.banking.controller;

import com.example.banking.model.User;
import com.example.banking.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping
    public List<User> getAllUsers() {
        System.out.println("=== UserController: Received request for all users ===");
        try {
            List<User> users = userService.getAllUsers();
            System.out.println("=== UserController: Successfully found " + users.size() + " users ===");
            users.forEach(user -> System.out.println("User: " + user.getName() + ", Account: " + user.getAccountNumber()));
            return users;
        } catch (Exception e) {
            System.err.println("=== UserController: Error getting users: " + e.getMessage() + " ===");
            e.printStackTrace();
            throw e;
        }
    }

    @GetMapping("/{id}")
    public Optional<User> getUser(@PathVariable Long id) {
        return userService.getUser(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public User createUser(@RequestBody User user) {
        System.out.println("=== UserController: Received request to create user ===");
        System.out.println("User details: " + user);
        try {
            User createdUser = userService.createUser(user);
            System.out.println("=== UserController: Successfully created user: " + createdUser.getId() + " ===");
            return createdUser;
        } catch (Exception e) {
            System.err.println("=== UserController: Error creating user: " + e.getMessage() + " ===");
            e.printStackTrace();
            throw e;
        }
    }

    @PutMapping("/{id}")
    public User updateUser(@PathVariable Long id, @RequestBody User user) {
        return userService.updateUser(id, user);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteUser(@PathVariable Long id) {
        System.out.println("=== UserController: Received DELETE request for user ID: " + id + " ===");
        try {
            userService.deleteUser(id);
            System.out.println("=== UserController: Successfully deleted user ID: " + id + " ===");
        } catch (Exception e) {
            System.err.println("=== UserController: Error deleting user: " + e.getMessage() + " ===");
            e.printStackTrace();
            throw e;
        }
    }
}
