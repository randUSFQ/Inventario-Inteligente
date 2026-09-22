<?php
try {
    $pdo = new PDO(
        'mysql:host=' . getenv('DB_HOST') .
        ';dbname=' . getenv('DB_NAME') .
        ';charset=utf8mb4',
        getenv('DB_USER'),
        getenv('DB_PASSWORD'),
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    $version = $pdo->query('SELECT VERSION()')->fetchColumn();
    echo '<h1>Apache y PHP funcionando</h1>';
    echo '<p>Conectado a MySQL ' .
         htmlspecialchars($version, ENT_QUOTES, 'UTF-8') .
         '</p>';
} catch (PDOException $e) {
    http_response_code(503);
    echo '<p>MySQL todavía no está disponible. Recarga la página en unos segundos.</p>';
}
