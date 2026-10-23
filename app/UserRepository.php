<?php

namespace LittleStars\App;

use PDO;

class UserRepository
{
    public function registerUser(string $fullName, string $email, string $phone, string $password): array
    {
        $pdo = Database::getConnection();
        $email = trim(strtolower($email));
        $fullName = trim($fullName);
        $phone = trim($phone);

        if ($email === '' || $fullName === '' || $password === '') {
            throw new \InvalidArgumentException('Full name, email, and password are required.');
        }

        if (strlen($password) < 8) {
            throw new \InvalidArgumentException('Password must be at least 8 characters long.');
        }

        $existing = $this->findByEmail($email);
        if ($existing) {
            throw new \RuntimeException('An account with this email already exists.');
        }

        $hash = password_hash($password, PASSWORD_DEFAULT);

        $sql = 'INSERT INTO users (full_name, email, phone, password_hash, role, account_status) VALUES (:full_name, :email, :phone, :password_hash, :role, :account_status)';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            'full_name' => $fullName,
            'email' => $email,
            'phone' => $phone,
            'password_hash' => $hash,
            'role' => 'customer',
            'account_status' => 'active',
        ]);

        $userId = (int) $pdo->lastInsertId();
        return $this->findById($userId);
    }

    public function loginUser(string $email, string $password): ?array
    {
        $pdo = Database::getConnection();
        $email = trim(strtolower($email));

        $sql = 'SELECT * FROM users WHERE email = :email LIMIT 1';
        $stmt = $pdo->prepare($sql);
        $stmt->execute(['email' => $email]);
        $user = $stmt->fetch();

        if (!$user) {
            return null;
        }

        if (!password_verify($password, $user['password_hash'])) {
            return null;
        }

        return $user;
    }

    public function findByEmail(string $email): ?array
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare('SELECT * FROM users WHERE email = :email LIMIT 1');
        $stmt->execute(['email' => trim(strtolower($email))]);
        $user = $stmt->fetch();
        return $user ?: null;
    }

    public function findById(int $userId): ?array
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare('SELECT * FROM users WHERE user_id = :user_id LIMIT 1');
        $stmt->execute(['user_id' => $userId]);
        $user = $stmt->fetch();
        return $user ?: null;
    }
}
