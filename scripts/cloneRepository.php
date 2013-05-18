#!/usr/bin/env php
<?php

$repositoryToClone = array('joind.in', 'joindin-api', 'joindin-web2');

$path = realpath(__DIR__ . '/../');
chdir($path);

$gitUsername = getGitUsername();

array_walk($repositoryToClone, 'cloneRepository', $gitUsername);
array_walk($repositoryToClone, 'addUpstreamRemote');

function getGitUsername() {
	$remote = `git remote show origin`;
	$pattern = '/\s*Fetch URL:\s+git@github\.com:(.+)\//';

	$found = preg_match($pattern, $remote, $matches);
	if (!$found || 2 != count($matches)) {
		die('Failed to extract the username from git origin');
	}

	return $matches[1];
}


function cloneRepository($repoName, $index, $gitUsername) {
	echo "Cloning {$repoName}\n";
	$cloneCommand = "git clone git@github.com:{$gitUsername}/{$repoName}.git";
	system($cloneCommand);
}

function addUpstreamRemote($repoName) {
	echo "Adding upstream remote to {$repoName}\n";
	chdir($repoName);
	$remoteCommand = "git remote add upstream git@github.com:joindin/{$repoName}.git";
	system($remoteCommand);
	chdir('../');
}
