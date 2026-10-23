<?php

use LittleStars\App\Database;

require __DIR__ . '/app/Database.php';

session_start();

$guestSession = $_SESSION['guest_session'] ?? ('guest_' . session_id());
$_SESSION['guest_session'] = $guestSession;

$pdo = Database::getConnection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'add') {
    $productId = (int)($_POST['product_id'] ?? 0);
    $productQuery = 'SELECT variant_id, stock_quantity FROM product_variants WHERE product_id = :product_id AND status = "active" ORDER BY variant_id ASC LIMIT 1';
    $stmt = $pdo->prepare($productQuery);
    $stmt->execute(['product_id' => $productId]);
    $variant = $stmt->fetch();

    if (!$variant) {
        header('Location: product.php?error=No+available+variant');
        exit;
    }

    $cartQuery = 'SELECT cart_id FROM carts WHERE session_id = :session_id LIMIT 1';
    $cartStmt = $pdo->prepare($cartQuery);
    $cartStmt->execute(['session_id' => $guestSession]);
    $cart = $cartStmt->fetch();

    if (!$cart) {
        $insertCart = 'INSERT INTO carts (session_id) VALUES (:session_id)';
        $insertCartStmt = $pdo->prepare($insertCart);
        $insertCartStmt->execute(['session_id' => $guestSession]);
        $cartId = $pdo->lastInsertId();
    } else {
        $cartId = (int)$cart['cart_id'];
    }

    $itemQuery = 'SELECT cart_item_id, quantity FROM cart_items WHERE cart_id = :cart_id AND product_variant_id = :variant_id LIMIT 1';
    $itemStmt = $pdo->prepare($itemQuery);
    $itemStmt->execute(['cart_id' => $cartId, 'variant_id' => (int)$variant['variant_id']]);
    $existing = $itemStmt->fetch();

    if ($existing) {
        $newQty = (int)$existing['quantity'] + 1;
        $update = 'UPDATE cart_items SET quantity = :quantity, updated_at = NOW() WHERE cart_item_id = :cart_item_id';
        $pdo->prepare($update)->execute(['quantity' => $newQty, 'cart_item_id' => (int)$existing['cart_item_id']]);
    } else {
        $insertItem = 'INSERT INTO cart_items (cart_id, product_variant_id, quantity) VALUES (:cart_id, :variant_id, :quantity)';
        $pdo->prepare($insertItem)->execute([
            'cart_id' => $cartId,
            'variant_id' => (int)$variant['variant_id'],
            'quantity' => 1,
        ]);
    }

    header('Location: cart.php');
    exit;
}

$cartSql = '
    SELECT ci.cart_item_id, ci.quantity, pv.variant_id, p.product_name, pv.size_label, pv.colour, pv.variant_price, p.base_price,
           (COALESCE(pv.variant_price, p.base_price) * ci.quantity) AS line_total
    FROM carts c
    INNER JOIN cart_items ci ON ci.cart_id = c.cart_id
    INNER JOIN product_variants pv ON pv.variant_id = ci.product_variant_id
    INNER JOIN products p ON p.product_id = pv.product_id
    WHERE c.session_id = :session_id
    ORDER BY ci.created_at DESC
';
$cartStmt = $pdo->prepare($cartSql);
$cartStmt->execute(['session_id' => $guestSession]);
$cartItems = $cartStmt->fetchAll();

function formatMoney(float $amount): string
{
    return '₦' . number_format($amount, 2);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8fafc; margin: 0; color: #1f2937; }
        .container { max-width: 1000px; margin: 0 auto; padding: 32px 20px 60px; }
        table { width: 100%; border-collapse: collapse; background: white; border: 1px solid #e5e7eb; }
        th, td { padding: 12px; border-bottom: 1px solid #e5e7eb; text-align: left; }
        th { background: #f3f4f6; }
        .btn { background: #0f766e; color: white; padding: 10px 14px; text-decoration: none; border-radius: 8px; display: inline-block; }
        .card { background: white; border: 1px solid #e5e7eb; border-radius: 12px; padding: 20px; margin-top: 16px; }
    </style>
</head>
<body>
<div class="container">
    <a href="product.php" class="btn">Continue shopping</a>
    <h1>Shopping Cart</h1>

    <?php if (empty($cartItems)): ?>
        <div class="card">Your cart is empty.</div>
    <?php else: ?>
        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Variant</th>
                    <th>Qty</th>
                    <th>Unit Price</th>
                    <th>Line Total</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($cartItems as $item): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($item['product_name'], ENT_QUOTES, 'UTF-8'); ?></td>
                        <td><?php echo htmlspecialchars($item['size_label'], ENT_QUOTES, 'UTF-8'); ?> / <?php echo htmlspecialchars($item['colour'], ENT_QUOTES, 'UTF-8'); ?></td>
                        <td><?php echo (int)$item['quantity']; ?></td>
                        <td><?php echo formatMoney((float)($item['variant_price'] ?? $item['base_price'])); ?></td>
                        <td><?php echo formatMoney((float)$item['line_total']); ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>
</div>
</body>
</html>
