# joindin-vm

Quick way to get the platform for joind.in development set up

This repository provides a vagrant virtual machine so you can start contributing quickly. Joind.in is a big project, so there a few parts involved.

## Welcome

Joind.in welcomes all contributors regardless of your ability or experience. We especially welcome
you if you are new to Open Source development and will provide a helping hand. To ensure that
everyone understands what we expect from our community, our projects have a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md) and by participating in the development of joind.in you agree to abide
by its terms.

## Getting Started

1. Install requirements. (Note: these are not required by joind.in itself, but are required for this quick start guide.)

    - VirtualBox and the VirtualBox Extension Pack (https://www.virtualbox.org/) (version 6.0 or later)
    - Vagrant (http://vagrantup.com/) version 2.x+
      - Recommended plugin: [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
    - Composer (https://getcomposer.org/)

1. Make your own github fork of the following joind.in repositories:

    - [joindin-api](https://github.com/joindin/joindin-api)
    - [joindin-web2](https://github.com/joindin/joindin-web2)
    - [joindin-vm](https://github.com/joindin/joindin-vm)

1. Clone joindin-vm

    Make sure that you are accessing your fork of the *joindin-vm* repo

    ```sh
    git clone git@github.com:{YourGitHubId}/joindin-vm.git --recursive
    ```

    For example:

    ```sh
    git clone git@github.com:defunkt/joindin-vm.git --recursive
    ```

1. Execute the script that will clone the other 2 repositories from your forks

    ```sh
    cd joindin-vm
    php scripts/cloneRepository.php
    ```

    If you are getting Git and PHP warnings and you have previously forked joind.in before the introduction of web2,
    you can safely remove your forks of `joindin-legacy` and the even older `joind.in`.

1. Run Composer Install and the Homestead `make` command:

    ```sh
    composer install
    php vendor/bin/homestead make
    ```

    This copies the `Homestead.yaml.example` file to `Homestead.yaml` (which is ignored from VCS) that has computer
    specific paths configured for the joind.in repositories.

1. Start the VM

    ```sh
    vagrant up
    ```

1. If you get asked for the vagrant user password during provisioning, try the password `vagrant`

1. If you don't have the [hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
   Vagrant plugin, then add hostname to /etc/hosts.

    If you are on Linux, run this:

    ```sh
    (echo ; echo "192.168.10.10 dev.joind.in api.dev.joind.in") | sudo tee -a /etc/hosts
    ```

    If you are on macOS, run this:

    ```sh
    echo "192.168.10.10 dev.joind.in api.dev.joind.in" | sudo tee -a /etc/hosts
    ```

    If you are on Windows, run this on the cmd line

    ```bat
    echo 192.168.10.10 dev.joind.in api.dev.joind.in >> %SYSTEMDRIVE%\Windows\System32\Drivers\Etc\Hosts
    ```

1. Browse to the sites
    - For the joind.in site: http://dev.joind.in/
    - For the API: http://api.dev.joind.in/

1. You can log in to the joind.in test site with these credentials for an admin account:
    - Username: imaadmin
    - Password: password

1. For other users, [look at the dbgen documentation.](https://github.com/joindin/joindin-api/tree/master/tools/dbgen#usernames-and-passwords)

*Notes:*

- The joind.in directory you cloned will be mounted inside the VM at `/home/joindin-vm`
- You can develop by editing the files you cloned in the IDE of your choice.
- The database is running inside the VM. You can get to it with the following commands:

    ```sh
    you@you> vagrant ssh
    vagrant@vm> mysql joindin -u joindin
    ```

- The database is exposed on port 3306 of the VM, so you can also use:

    ```sh
    you@you> mysql -u joindin -h 192.168.10.10 -P 3306 -ppassword joindin
    ```

    Or by its external port, 33060, on localhost:

    ```sh
    you@you> mysql -u joindin -h 127.0.01 -P 33060 -ppassword joindin
    ```

- To stop the VM so that you can work on it later, issue the following command
  from the host machine:

    ```sh
    vagrant halt
    ```

- To delete the VM completely, issue the following command from the host machine:

    ```sh
    vagrant destroy
    ```

## Troubleshooting

### Slim Application Error

Recreate the config files:

```sh
cd joindin-api/src
cp config.php.dist config.php
cp database.php.dist database.php

cd ../../joindin-web2/src
cp config.php.dist config.php
```

### Configuration is missing

Update the config files:

```sh
you@you> vagrant ssh
vagrant@vm> cd ~/joindin-vm
vagrant@vm> sh scripts/fixConfig.sh
```

## Mailhog

We use mailhog to grab emails before they leave the VM, and present them to you in a web interface so you can see what the system would be sending.  To check the mails that have been sent, visit [http://dev.joind.in:8025/](http://dev.joind.in:8025/) on your host machine.

## Xdebug/PHPStorm Setup

Xdebug is setup on the dev VM, with remote_start enabled, by default.  To start
using this, visit http://www.jetbrains.com/phpstorm/marklets/, generate the
bookmarklets with IDE key `PHPSTORM`, and the 'Start debugger' and 'Stop
debugger' bookmarklets to your browsers bookmark bar.  These bookmarklets set
the required cookies to trigger or stop triggering remote debugging of scripts.

To test all is working OK, open the entry point index.php file for the relevant
repo and add a breakpoint (Cmd+F8 on Mac), and visit a public URL for the
relevant repo.  If all is setup correctly, PHPStorm should prompt you to select
the local file that the remote file maps to.  Simply select the local index.php
file for the repo and you should be good to go.

If testing from the command-line and not a browser:

- Enable xdebug:

    ```sh
    vagrant ssh
    xon
    ```

- Disable xdebug:

    ```sh
    vagrant ssh
    xoff
    ```

## Packaging the box from event with slow connection

If you are at an event with a slow connection it's possible to package the box and copy it on a usb key. This way others don't need to download it.

### Repackage the box before the event

Build the environment on your local machine and then run the command:

    ```sh
    vagrant box repackage laravel/homestead virtualbox 7.1.0
    ```

Then copy the resulting `package.box` file to a USB key and share it at the event as per the instructions for using the packaged box.

### Using the packaged box

1. Copy the box file on your machine
1. Import the box

    ```sh
    vagrant box add joindindev path/to/package.box
    ```

1. Follow the Getting Started instructions but before you run `vagrant up` and the following line to `Homstead.yaml`:
    
    ```yaml
    box: joindindev
    ```

1. Open `vendor/laravel/homestead/scripts/homestead.rb` and comment out the following line:

    ```ruby
    config.vm.box_version = settings['version'] ||= '>= 7.0.0'
    ```

1. Continue where you left of with `vagrant up` "Start the VM".

## Exposing to the web via ngrok

If you want to expose the VM's websites to the web via [ngrok](http://ngrok.com), then you need to sign up with ngrok and register your authtoken with the ngrok command line tool. This is so that you can use ngrok's custom subdomains feature. Each website within the VM is set up to support a prefixed subdomain to which you append your own unique string.

For example, using the custom string `example`, you can run these commands to expose the given site to the Internet:

* api : `ngrok -subdomain apiexample dev.joind.in:80`
* web2: `ngrok -subdomain web2example dev.joind.in:80`

Therefore, running `ngrok -subdomain web2example dev.joind.in:80` will enable anyone on the Internet to access your development version of web2 at http://web2example.ngrok.com.

### Debugging with wireshark

The VM has wireshark installed so that you can view the traffic between the api and web2 (or any other client).

On your local machine, in the joindin-vm directory, you can use this command to start wireshark with it reading traffic on the VM:

```sh
wireshark -k -i <(vagrant ssh -c "sudo dumpcap -P -i any -w - -f 'not tcp port 22'" -- -ntt)
```

Full details are [in this article](http://www.lornajane.net/posts/2014/wireshark-capture-on-remote-server)
