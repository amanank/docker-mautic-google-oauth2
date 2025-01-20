<?php
$parameters = array(
	'db_driver' => 'pdo_mysql',
	'db_host' => getenv('MAUTIC_DB_HOST'),
	'db_port' => '3306',
	'db_name' => getenv('MAUTIC_DB_NAME'),
	'db_user' => getenv('MAUTIC_DB_USER'),
	'db_password' => getenv('MAUTIC_DB_PASSWORD'),
	'db_table_prefix' => null,
	'db_backup_tables' => 0,
	'db_backup_prefix' => 'bak_',
	'mailer_dsn' => getenv('MAUTIC_MAILER_DSN'),
	'db_host_ro' => null,
	'site_url' => getenv('SITE_URL'),
);