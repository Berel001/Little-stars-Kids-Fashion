<?php

use LittleStars\App\UserRepository;

require __DIR__ . '/../app/Database.php';
require __DIR__ . '/../app/UserRepository.php';

session_start();

$errors = [];
$success = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $fullName = trim((string) ($_POST['full_name'] ?? ''));
    $email = trim((string) ($_POST['email'] ?? ''));
    $phone = trim((string) ($_POST['phone'] ?? ''));
    $password = (string) ($_POST['password'] ?? '');

    try {
        $repo = new UserRepository();
        $repo->registerUser($fullName, $email, $phone, $password);
        $success = true;
    } catch (Throwable $e) {
        $errors[] = $e->getMessage();
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8fafc; margin: 0; color: #1f2937; }
        .container { max-width: 480px; margin: 60px auto; background: white; padding: 32px; border: 1px solid #e5e7eb; border-radius: 12px; }
        label { display: block; margin: 14px 0 6px; font-weight: 600; }
        input { width: 100%; padding: 10px; border: 1px solid #d1d5db; border-radius: 8px; box-sizing: border-box; }
        .btn { background: #0f766e; color: white; padding: 12px 16px; border: none; border-radius: 8px; width: 100%; margin-top: 18px; cursor: pointer; }
        .link { display: inline-block; margin-top: 18px; }
        .message { margin-bottom: 14px; padding: 12px; border-radius: 8px; }
        .error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .success { background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Create your account</h1>

        <?php if ($success): ?>
            <div class="message success">Registration successful. You can now <a href="login.php">log in</a>.</div>
        <?php endif; ?>

        <?php foreach ($errors as $error): ?>
            <div class="message error"><?php echo htmlspecialchars($error, ENT_QUOTES, 'UTF-8'); ?></div>
        <?php endforeach; ?>

        <form method="POST" action="register.php">
            <label for="full_name">Full name</label>
            <input id="full_name" name="full_name" type="text" required>

            <label for="email">Email address</label>
            <input id="email" name="email" type="email" required>

            <label for="phone">Phone number</label>
            <input id="phone" name="phone" type="text" placeholder="Optional">

            <label for="password">Password</label>
            <input id="password" name="password" type="password" minlength="8" required>

            <button class="btn" type="submit">Register</button>
        </form>

        <a class="link" href="login.php">Already have an account? Log in</a>
    </div>
</body>
</html>
