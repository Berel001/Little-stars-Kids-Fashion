<?php

session_start();

if (!isset($_SESSION['user_id'])) {
    header('Location: auth/login.php');
    exit;
}

$userName = $_SESSION['user_name'] ?? 'Customer';
$userEmail = $_SESSION['user_email'] ?? '';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8fafc; margin: 0; color: #1f2937; }
        .container { max-width: 900px; margin: 40px auto; background: white; border: 1px solid #e5e7eb; border-radius: 12px; padding: 32px; }
        .header { display: flex; justify-content: space-between; align-items: center; }
        .btn { background: #0f766e; color: white; padding: 10px 14px; text-decoration: none; border-radius: 8px; }
        .panel { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 10px; padding: 20px; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Welcome, <?php echo htmlspecialchars($userName, ENT_QUOTES, 'UTF-8'); ?></h1>
            <a class="btn" href="auth/logout.php">Logout</a>
        </div>

        <div class="panel">
            <p><strong>Email:</strong> <?php echo htmlspecialchars($userEmail, ENT_QUOTES, 'UTF-8'); ?></p>
            <p>Your account is active and ready for shopping.</p>
            <p><a href="product.php">Browse products</a> | <a href="cart.php">View cart</a></p>
        </div>
    </div>
</body>
</html>
