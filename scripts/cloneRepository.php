#!/usr/bin/env php
<?php
declare(strict_types=1);

$repositoryToClone = ['joindin-legacy', 'joindin-api', 'joindin-web2'];

$path = realpath(dirname(__DIR__) . DIRECTORY_SEPARATOR);
chdir($path);

echo "Preparing the submodules\n";
system('git submodule init');
system('git submodule update');

$remoteString = shell_exec('git remote show origin');
$useHttps = isHttpsClone($remoteString);

$gitUsername = getGitUsername($remoteString, $useHttps);

array_walk($repositoryToClone, 'cloneRepository', [$gitUsername, $useHttps]);
array_walk($repositoryToClone, 'addUpstreamRemote', $useHttps);
array_walk($repositoryToClone, 'installViaComposer');

echo "Installing dev dependencies for joindin-vm\n";
system('composer install');

function getGitUsername(string $remoteString, bool $useHttps): string
{
	if ($useHttps) {
		$pattern = '/\s*Fetch URL:\s+https:\/\/github\.com\/(.+)\//';
	} else {
		$pattern = '/\s*Fetch URL:\s+git@github\.com:(.+)\//';
	}

	$found = preg_match($pattern, $remoteString, $matches);
	if (!$found || 2 !== count($matches)) {
		die('Failed to extract the username from git origin');
	}

	return $matches[1];
}

function cloneRepository(string $repoName, int $index, array $values): void
{
	[$gitUsername, $useHttps] = $values;

	echo "Cloning {$repoName}\n";

	if ($useHttps) {
		$cloneCommand = "git clone https://github.com/{$gitUsername}/{$repoName}.git";
	} else {
		$cloneCommand = "git clone git@github.com:{$gitUsername}/{$repoName}.git";
	}

	echo $cloneCommand . "\n";
	system($cloneCommand);
}

function addUpstreamRemote(string $repoName, int $index, bool $useHttps): void
{
	echo "Adding upstream remote to {$repoName}\n";
	chdir($repoName);

	if ($useHttps) {
		$remoteCommand = "git remote add upstream https://github.com/joindin/{$repoName}.git";
	} else {
		$remoteCommand = "git remote add upstream git@github.com:joindin/{$repoName}.git";
	}

	echo $remoteCommand. "\n";
	system($remoteCommand);
    chdir(dirname(__DIR__));
}

function isHttpsClone(string $remote): bool
{
	$pattern = '/\s*Fetch URL:\s+https:\/\//';
	return (bool) preg_match($pattern, $remote);
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
