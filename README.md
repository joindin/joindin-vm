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

    - [joindin-legacy](https://github.com/joindin/joindin-legacy)
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

1. Execute the script that will clone the other 3 repository from your forks

    ```sh
    cd joindin-vm
    php scripts/cloneRepository.php
    ```

    If you are getting Git and PHP warnings and you have previously forked joind.in before the introduction of web2,
    make sure that your fork of `joindin-legacy` is not called `joind.in`.

1. Execute the Homestead `make` command:

    ```sh
    cd joindin-vm
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
    (echo ; echo "192.168.10.10 dev.joind.in api.dev.joind.in legacy.dev.joind.in") | sudo tee -a /etc/hosts
    ```

    If you are on macOS, run this:

    ```sh
    echo "192.168.10.10 dev.joind.in api.dev.joind.in legacy.dev.joind.in" | sudo tee -a /etc/hosts
    ```

    If you are on Windows, run this on the cmd line

    ```bat
    echo 192.168.10.10 dev.joind.in api.dev.joind.in legacy.dev.joind.in >> %SYSTEMDRIVE%\Windows\System32\Drivers\Etc\Hosts
    ```

1. Browse to the sites
    - For the joind.in site: http://dev.joind.in/
    - For the legacy site: http://legacy.dev.joind.in/
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

## Running the tests

To install the testing tools in the VM

1. Copy the file `puppet/hieradata/common.yaml.dist` to `puppet/hieradata/common.yaml`.

    ```sh
    cp puppet/hieradata/common.yaml.dist puppet/hieradata/common.yaml
    ```

1. Edit this file and change the value of `joindin::test::tests` to true.
1. Re provision the VM. If the VM is not on, run `vagrant up`, if it's on, run `vagrant provision`
1. Wait for the testing tools to be installed. This will take a few minutes.
1. Run the joind.in tests with this command from inside the VM

    ```sh
    cd /vagrant/joindin-web2 && phing
    ```

1. Run the joindin-api tests with this command from inside the VM

    ```sh
    cd /vagrant/joindin-api && phing
    ```

1. Run the joindin-legacy tests with this command from inside the VM

    ```sh
    cd /vagrant/joindin-legacy && phing
    ```

## Troubleshooting

### Box stored with the wrong format

If you get this error:

    "The box 'centos-62-64-puppet' is still stored on disk in the Vagrant 1.0.x format. This box must be upgraded in order to work properly with this version of Vagrant.".

You can fix it by running the command `vagrant box repackage centos-62-64-puppet virtualbox` and executing `vagrant up` again.

### Problem with the guest additions version

If you get a warning about a mismatch between your version of the guest addition and the one in the VM. You can make sure that the guest additions in the VM are always up to date with this command:

```sh
vagrant plugin install vagrant-vbguest
```

If Vagrant complains that the command plugin does not exist, it's because your version of Vagrant is too old. You might need to upgrade it for the VM to work correctly.

### Vagrant Provisioning Not Executed

On the latest Vagrant version, sometimes Vagrant stops before running Puppet. If if happens, you can run it manually.

```sh
vagrant provision
```

### Configuration is missing

Update the config files:

```sh
you@you> vagrant ssh
vagrant@vm> cd ~/joindin-vm
vagrant@vm> chmod +x ./scripts/fixConfig.sh
vagrant@vm> ./scripts/fixConfig.sh
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

### Download the box before the event

You can download the box from [http://cdn.19ft.com/joindin-development.2.1.1.box](http://cdn.19ft.com/joindin-development.2.1.1.box). Then copy it on a usb key and share it at the event as per the instructions for using the packaged box.

### Package the box

If you're already at the event and can't download the box, someone who already has it can package it:

1. cd into the joindin-vm directory
2. Package the vagrant box

    ```sh
    vagrant package
    ```

3. Copy the generated file to a usb key.

### Using the packaged box

1. Copy the box file on your machine
2. Import the box

    ```sh
    vagrant box add joindin/development path/to/file
    ```

3. Follow the Getting Started instructions

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
