<?php

namespace LittleStars\App;

class ProductRepository
{
    public function getAllProducts(): array
    {
        $pdo = Database::getConnection();

        $sql = '
            SELECT
                p.product_id,
                p.product_name,
                p.description,
                p.base_price,
                p.status,
                c.category_name,
                (
                    SELECT MIN(pv.variant_price) FROM product_variants pv
                    WHERE pv.product_id = p.product_id AND pv.status = "active"
                ) AS min_variant_price,
                (
                    SELECT SUM(pv.stock_quantity) FROM product_variants pv
                    WHERE pv.product_id = p.product_id AND pv.status = "active"
                ) AS total_stock
            FROM products p
            INNER JOIN categories c ON c.category_id = p.category_id
            WHERE p.status IN ("active", "out_of_stock")
            ORDER BY p.product_id ASC
        ';

        $stmt = $pdo->query($sql);
        return $stmt->fetchAll();
    }

    public function getProductById(int $productId): ?array
    {
        $pdo = Database::getConnection();

        $sql = '
            SELECT p.*, c.category_name
            FROM products p
            INNER JOIN categories c ON c.category_id = p.category_id
            WHERE p.product_id = :product_id
            LIMIT 1
        ';

        $stmt = $pdo->prepare($sql);
        $stmt->execute(['product_id' => $productId]);
        $product = $stmt->fetch();

        return $product ?: null;
    }

    public function getVariantsForProduct(int $productId): array
    {
        $pdo = Database::getConnection();

        $sql = 'SELECT * FROM product_variants WHERE product_id = :product_id AND status = "active" ORDER BY size_label, colour';
        $stmt = $pdo->prepare($sql);
        $stmt->execute(['product_id' => $productId]);

        return $stmt->fetchAll();
    }
}
