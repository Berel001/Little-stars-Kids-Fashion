<?php

use LittleStars\App\ProductRepository;

require __DIR__ . '/app/Database.php';
require __DIR__ . '/app/ProductRepository.php';

$repository = new ProductRepository();
$products = $repository->getAllProducts();

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
    <title>Little Stars Products</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8fafc; color: #1f2937; margin: 0; }
        .container { max-width: 1100px; margin: 0 auto; padding: 32px 20px 60px; }
        .header { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin-bottom: 24px; }
        .card { background: #fff; border: 1px solid #e5e7eb; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
        .product-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; }
        .product-card { padding: 18px; }
        .product-card h3 { margin-top: 0; margin-bottom: 10px; }
        .price { font-size: 1.2rem; font-weight: 700; color: #0f766e; margin: 12px 0; }
        .meta { color: #4b5563; font-size: 0.9em; margin-bottom: 12px; }
        .actions { display: flex; justify-content: space-between; align-items: center; gap: 10px; margin-top: 16px; }
        .btn { background: #0f766e; color: white; padding: 10px 14px; text-decoration: none; border: none; border-radius: 8px; cursor: pointer; }
        .btn.secondary { background: #1f2937; }
        .pill { display: inline-block; background: #ecfeff; color: #0f172a; font-size: 0.75rem; padding: 4px 8px; border-radius: 999px; }
        .empty { padding: 16px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Little Stars Kids Fashion</h1>
        <a class="btn secondary" href="index.php">Dashboard</a>
    </div>

    <h2>Shop Products</h2>

    <?php if (empty($products)): ?>
        <div class="card empty">No products available right now.</div>
    <?php else: ?>
        <div class="product-grid">
            <?php foreach ($products as $product): ?>
                <?php
                $displayPrice = !empty($product['min_variant_price']) ? (float)$product['min_variant_price'] : (float)$product['base_price'];
                $stock = (int)($product['total_stock'] ?? 0);
                ?>
                <div class="card product-card">
                    <span class="pill"><?php echo htmlspecialchars($product['category_name'], ENT_QUOTES, 'UTF-8'); ?></span>
                    <h3><?php echo htmlspecialchars($product['product_name'], ENT_QUOTES, 'UTF-8'); ?></h3>
                    <div class="meta"><?php echo htmlspecialchars($product['status'], ENT_QUOTES, 'UTF-8'); ?> · Stock: <?php echo $stock; ?></div>
                    <p><?php echo htmlspecialchars(substr($product['description'] ?? '', 0, 110), ENT_QUOTES, 'UTF-8'); ?></p>
                    <div class="price"><?php echo formatMoney($displayPrice); ?></div>

                    <div class="actions">
                        <a class="btn secondary" href="product_detail.php?id=<?php echo (int)$product['product_id']; ?>">View</a>
                        <form method="post" action="cart.php?action=add">
                            <input type="hidden" name="product_id" value="<?php echo (int)$product['product_id']; ?>">
                            <button type="submit" class="btn">Add to cart</button>
                        </form>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>
</body>
</html>
