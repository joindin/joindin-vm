<?php
$config = array(
    'slim' => array(
        'mode' => 'development',
        'custom' => array(
            'redis' => array(
                'keyPrefix' => 'dev-',
            ),
            'apiUrl' => 'http://api.dev.joind.in',
            'googleAnalyticsId' => '',
        ),
        'oauth' => array(
            'client_id' => 'web2',
        ),
    ),
);
