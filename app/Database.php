<?php

namespace LittleStars\App;

use PDO;
use PDOException;
use RuntimeException;

if (!defined('DB_HOST') && !function_exists('getDatabaseConnection')) {
    require __DIR__ . '/../config/database.php';
}

class Database
{
    public static function getConnection(): PDO
    {
        if (!defined('DB_HOST') && !function_exists('getDatabaseConnection')) {
            require __DIR__ . '/../config/database.php';
        }

        if (function_exists('getDatabaseConnection')) {
            return getDatabaseConnection();
        }

        $dsn = sprintf(
            'mysql:host=%s;port=%d;dbname=%s;charset=%s',
            DB_HOST,
            DB_PORT,
            DB_NAME,
            DB_CHARSET
        );

        $options = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
            PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci',
        ];

        try {
            return new PDO($dsn, DB_USER, DB_PASS, $options);
        } catch (PDOException $e) {
            throw new RuntimeException('Database connection failed: ' . $e->getMessage());
        }
    }
}
