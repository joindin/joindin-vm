#!/usr/bin/env php
<?php
declare(strict_types=1);

$repositoryToUpdate = ['joindin-web2', 'joindin-api', 'joindin-legacy'];

$path = realpath(dirname(__DIR__) . DIRECTORY_SEPARATOR);
chdir($path);

system('git pull upstream master');

system('git submodule init');
system('git submodule update');

echo "Installing dev dependencies for joindin-vm\n";
system('composer install');

array_walk($repositoryToUpdate, 'updateRepository');
array_walk($repositoryToUpdate, 'installViaComposer');

function updateRepository(string $repoName): void
{
	echo "Updating repo {$repoName}\n";
	chdir($repoName);
	system('git pull upstream master');
	chdir(dirname(__DIR__));
}

function installViaComposer(string $repoName): void
{
    $path = dirname(__DIR__) . DIRECTORY_SEPARATOR . $repoName;
    chdir($path);

    if (!file_exists('composer.lock')) {
        return;
    }

    echo "Installing dev dependencies for {$repoName}\n";

    $remoteCommand = 'composer install';

    echo $remoteCommand. "\n";
    system($remoteCommand);
}
