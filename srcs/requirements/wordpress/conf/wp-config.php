<?php
// Define database constants
define('DB_NAME', getenv('DB_NAME'));
define('DB_USER', getenv('DB_USER'));
define('DB_PASSWORD', getenv('DB_PASSWORD'));
define('DB_HOST', getenv('DB_HOST'));

// Define WordPress URLs
define('WP_HOME', getenv('WP_FULL_URL'));
define('WP_SITEURL', getenv('WP_FULL_URL'));

define('DB_CHARSET', 'utf8'); // Database character set
define('DB_COLLATE', ''); // Database collation

$table_prefix = 'wp_'; // Table prefix for database tables

define('WP_DEBUG', true); // Enable WordPress debugging

if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/'); // Absolute path to the WordPress directory
}

require_once ABSPATH . 'wp-settings.php'; // Include WordPress settings
