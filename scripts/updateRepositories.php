#!/usr/bin/env php
<?php

$repositoryToUpdate = array('joindin-web2', 'joindin-api', 'joindin-legacy');

$path = realpath(__DIR__ . '/../');
chdir($path);

system('git pull upstream master');

system('git submodule init');
system('git submodule update');

array_walk($repositoryToUpdate, 'updateRepository');
array_walk($repositoryToUpdate, 'installViaComposer');

function updateRepository($repoName) {
	echo "Updating repo {$repoName}\n";
	chdir($repoName);
	system("git pull upstream master");
	chdir('../');
}

function installViaComposer($repoName)
{
    $windowsAndNixHappyPath = __DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . $repoName;
    chdir($windowsAndNixHappyPath);

    if (!file_exists('composer.lock')) {
        return;
    }

    echo "Installing dev dependencies for {$repoName}\n";

    $remoteCommand = 'composer install';

    echo $remoteCommand. "\n";
    system($remoteCommand);
}
