<?php

use LittleStars\App\UserRepository;

require __DIR__ . '/../app/Database.php';
require __DIR__ . '/../app/UserRepository.php';

session_start();

$errors = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim((string) ($_POST['email'] ?? ''));
    $password = (string) ($_POST['password'] ?? '');

    $repo = new UserRepository();
    $user = $repo->loginUser($email, $password);

    if ($user) {
        $_SESSION['user_id'] = (int) $user['user_id'];
        $_SESSION['user_name'] = $user['full_name'];
        $_SESSION['user_email'] = $user['email'];
        header('Location: ../dashboard.php');
        exit;
    }

    $errors[] = 'Invalid email or password.';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8fafc; margin: 0; color: #1f2937; }
        .container { max-width: 460px; margin: 80px auto; background: white; padding: 32px; border: 1px solid #e5e7eb; border-radius: 12px; }
        label { display: block; margin: 12px 0 6px; font-weight: 600; }
        input { width: 100%; padding: 10px; border: 1px solid #d1d5db; border-radius: 8px; box-sizing: border-box; }
        .btn { background: #0f766e; color: white; padding: 12px 16px; border: none; border-radius: 8px; width: 100%; margin-top: 18px; cursor: pointer; }
        .message { margin-bottom: 14px; padding: 12px; border-radius: 8px; background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .link { display: inline-block; margin-top: 18px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Login</h1>

        <?php foreach ($errors as $error): ?>
            <div class="message"><?php echo htmlspecialchars($error, ENT_QUOTES, 'UTF-8'); ?></div>
        <?php endforeach; ?>

        <form method="POST" action="login.php">
            <label for="email">Email</label>
            <input id="email" name="email" type="email" required>

            <label for="password">Password</label>
            <input id="password" name="password" type="password" required>

            <button class="btn" type="submit">Login</button>
        </form>

        <a class="link" href="register.php">Need an account? Register</a>
    </div>
</body>
</html>
