<?php
require __DIR__ . '/config/database.php';

function formatMoney(float $amount): string
{
    return '₦' . number_format($amount, 2);
}

try {
    $pdo = getDatabaseConnection();

    $userQuery = 'SELECT COUNT(*) AS total_users FROM users';
    $userStmt = $pdo->query($userQuery);
    $userTotal = $userStmt->fetch();

    $productQuery = 'SELECT COUNT(*) AS total_products FROM products';
    $productStmt = $pdo->query($productQuery);
    $productTotal = $productStmt->fetch();

    $orderQuery = 'SELECT COUNT(*) AS total_orders FROM orders';
    $orderStmt = $pdo->query($orderQuery);
    $orderTotal = $orderStmt->fetch();

    $catalogQuery = '
        SELECT
            p.product_id,
            p.product_name,
            c.category_name,
            p.base_price,
            p.status,
            COUNT(pv.variant_id) AS variant_count,
            COALESCE(SUM(pv.stock_quantity), 0) AS total_stock
        FROM products p
        INNER JOIN categories c ON c.category_id = p.category_id
        LEFT JOIN product_variants pv ON pv.product_id = p.product_id
        GROUP BY p.product_id, p.product_name, c.category_name, p.base_price, p.status
        ORDER BY p.product_id ASC
    ';
    $catalogStmt = $pdo->query($catalogQuery);
    $products = $catalogStmt->fetchAll();

    echo '<!DOCTYPE html>';
    echo '<html lang="en">';
    echo '<head>';
    echo '<meta charset="UTF-8">';
    echo '<title>Little Stars Kids Fashion</title>';
    echo '<style>';
    echo 'body { font-family: Arial, sans-serif; margin: 24px; background: #f7f7f7; color: #1f2937; }';
    echo 'h1, h2 { margin-bottom: 12px; }';
    echo '.stats { display: flex; gap: 20px; margin: 20px 0; flex-wrap: wrap; }';
    echo '.stat { background: white; border: 1px solid #e5e7eb; border-radius: 8px; padding: 16px 20px; min-width: 150px; box-shadow: 0 1px 2px rgba(0,0,0,0.04); }';
    echo '.stat strong { display: block; font-size: 22px; margin-top: 8px; }';
    echo 'table { width: 100%; border-collapse: collapse; background: white; border: 1px solid #e5e7eb; }';
    echo 'th, td { padding: 12px 10px; border-bottom: 1px solid #e5e7eb; text-align: left; }';
    echo 'th { background: #f3f4f6; }';
    echo '</style>';
    echo '</head>';
    echo '<body>';
    echo '<h1>Little Stars Kids Fashion</h1>';
    echo '<p>Database connection successful.</p>';
    echo '<div class="stats">';
    echo '<div class="stat"><span>Users</span><strong>' . (int) $userTotal['total_users'] . '</strong></div>';
    echo '<div class="stat"><span>Products</span><strong>' . (int) $productTotal['total_products'] . '</strong></div>';
    echo '<div class="stat"><span>Orders</span><strong>' . (int) $orderTotal['total_orders'] . '</strong></div>';
    echo '</div>';

    echo '<h2>Product Catalog</h2>';
    echo '<table>';
    echo '<thead><tr><th>ID</th><th>Product</th><th>Category</th><th>Base Price</th><th>Variants</th><th>Stock</th><th>Status</th></tr></thead>';
    echo '<tbody>';

    if ($products) {
        foreach ($products as $product) {
            echo '<tr>';
            echo '<td>' . (int) $product['product_id'] . '</td>';
            echo '<td>' . htmlspecialchars($product['product_name'], ENT_QUOTES, 'UTF-8') . '</td>';
            echo '<td>' . htmlspecialchars($product['category_name'], ENT_QUOTES, 'UTF-8') . '</td>';
            echo '<td>' . formatMoney((float) $product['base_price']) . '</td>';
            echo '<td>' . (int) $product['variant_count'] . '</td>';
            echo '<td>' . (int) $product['total_stock'] . '</td>';
            echo '<td>' . htmlspecialchars($product['status'], ENT_QUOTES, 'UTF-8') . '</td>';
            echo '</tr>';
        }
    } else {
        echo '<tr><td colspan="7">No products found.</td></tr>';
    }

    echo '</tbody>';
    echo '</table>';
    echo '</body>';
    echo '</html>';
} catch (Throwable $e) {
    http_response_code(500);
    echo '<h2>Database connection failed</h2>';
    echo '<p>' . htmlspecialchars($e->getMessage(), ENT_QUOTES, 'UTF-8') . '</p>';
}
