#!/usr/bin/env php
<?php

$repositoryToClone = array('joindin-legacy', 'joindin-api', 'joindin-web2');

$path = realpath(__DIR__ . '/../');
chdir($path);

echo "Preparing the submodules\n";
echo `git submodule init`;
echo `git submodule update`;

$remoteString = `git remote show origin`;
$useHttps = isHttpsClone($remoteString);

$gitUsername = getGitUsername($remoteString, $useHttps);

array_walk($repositoryToClone, 'cloneRepository', array($gitUsername, $useHttps));
array_walk($repositoryToClone, 'addUpstreamRemote', $useHttps);


function getGitUsername($remoteString, $useHttps) {

	if ($useHttps) {
		$pattern = '/\s*Fetch URL:\s+https:\/\/github\.com\/(.+)\//';
	} else {
		$pattern = '/\s*Fetch URL:\s+git@github\.com:(.+)\//';
	}

	$found = preg_match($pattern, $remoteString, $matches);
	if (!$found || 2 != count($matches)) {
		die('Failed to extract the username from git origin');
	}

	return $matches[1];
}

function cloneRepository($repoName, $index, $values) {
	$gitUsername = $values[0];
	$useHttps = $values[1];

	echo "Cloning {$repoName}\n";

	if ($useHttps) {
		$cloneCommand = "git clone https://github.com/{$gitUsername}/{$repoName}.git";
	} else {
		$cloneCommand = "git clone git@github.com:{$gitUsername}/{$repoName}.git";
	}

	echo $cloneCommand . "\n";
	system($cloneCommand);
}

function addUpstreamRemote($repoName, $index, $useHttps) {
	echo "Adding upstream remote to {$repoName}\n";
	chdir($repoName);

	if ($useHttps) {
		$remoteCommand = "git remote add upstream https://github.com/joindin/{$repoName}.git";
	} else {
		$remoteCommand = "git remote add upstream git@github.com:joindin/{$repoName}.git";
	}

	echo $remoteCommand. "\n";
	system($remoteCommand);
	chdir('../');
}

function isHttpsClone($remote) {
	$pattern = '/\s*Fetch URL:\s+https:\/\//';
	return preg_match($pattern, $remote);
}
