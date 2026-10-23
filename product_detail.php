<?php

use LittleStars\App\ProductRepository;

require __DIR__ . '/app/Database.php';
require __DIR__ . '/app/ProductRepository.php';

$productId = isset($_GET['id']) ? (int) $_GET['id'] : 0;
$repository = new ProductRepository();
$product = $repository->getProductById($productId);
$variants = $product ? $repository->getVariantsForProduct($productId) : [];

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
    <title>Product Details</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8fafc; color: #1f2937; margin: 0; }
        .container { max-width: 900px; margin: 0 auto; padding: 32px 20px 60px; }
        .card { background: white; border: 1px solid #e5e7eb; border-radius: 12px; padding: 20px; }
        .price { font-size: 1.8rem; font-weight: 700; color: #0f766e; margin: 12px 0; }
        .variants { margin-top: 24px; display: grid; gap: 12px; }
        .variant { display: flex; justify-content: space-between; align-items: center; border: 1px solid #e5e7eb; border-radius: 8px; padding: 12px; }
        .btn { background: #0f766e; color: white; padding: 10px 14px; text-decoration: none; border-radius: 8px; display: inline-block; }
    </style>
</head>
<body>
<div class="container">
    <a href="product.php" class="btn">Back to products</a>
    <?php if (!$product): ?>
        <div class="card" style="margin-top: 24px;">Product not found.</div>
    <?php else: ?>
        <div class="card" style="margin-top: 24px;">
            <h1><?php echo htmlspecialchars($product['product_name'], ENT_QUOTES, 'UTF-8'); ?></h1>
            <p><strong>Category:</strong> <?php echo htmlspecialchars($product['category_name'], ENT_QUOTES, 'UTF-8'); ?></p>
            <div class="price"><?php echo formatMoney((float)$product['base_price']); ?></div>
            <p><?php echo nl2br(htmlspecialchars($product['description'] ?? '', ENT_QUOTES, 'UTF-8')); ?></p>

            <div class="variants">
                <h2>Available Variants</h2>
                <?php if (empty($variants)): ?>
                    <div class="card">No active variants for this product.</div>
                <?php else: ?>
                    <?php foreach ($variants as $variant): ?>
                        <div class="variant">
                            <div>
                                <strong><?php echo htmlspecialchars($variant['size_label'], ENT_QUOTES, 'UTF-8'); ?></strong>
                                <span> / <?php echo htmlspecialchars($variant['colour'], ENT_QUOTES, 'UTF-8'); ?></span><br>
                                <small>SKU: <?php echo htmlspecialchars($variant['sku'], ENT_QUOTES, 'UTF-8'); ?></small>
                            </div>
                            <div>
                                <div><strong><?php echo formatMoney((float)($variant['variant_price'] ?? $product['base_price'])); ?></strong></div>
                                <div>Stock: <?php echo (int)$variant['stock_quantity']; ?></div>
                            </div>
                        </div>
                    <?php endforeach; ?>
                <?php endif; ?>
            </div>
        </div>
    <?php endif; ?>
</div>
</body>
</html>
