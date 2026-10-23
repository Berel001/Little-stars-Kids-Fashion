<?php
/**
 * PDO database configuration for Little Stars Kids Fashion.
 * Intended for use with XAMPP / MariaDB and PHP 8.1+.
 */

const DB_HOST = '127.0.0.1';
const DB_PORT = 3306;
const DB_NAME = 'little_stars_kids_fashion';
const DB_USER = 'root';
const DB_PASS = '';
const DB_CHARSET = 'utf8mb4';

function getDatabaseConnection(): PDO
{
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
