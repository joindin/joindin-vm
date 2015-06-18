#!/usr/bin/env php
<?php

$repositoryToUpdate = array('joind.in', 'joindin-api', 'joindin-web2');

$path = realpath(__DIR__ . '/../');
chdir($path);

system('git pull upstream master');

system('git submodule init');
system('git submodule update');

array_walk($repositoryToUpdate, 'updateRepository');

function updateRepository($repoName) {
	echo "Updating repo {$repoName}\n";
	chdir($repoName);
	system("git pull upstream master");
	chdir('../');
}
