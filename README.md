joindin-vm
==========

Quick way to get the platform for joind.in development set up

This repository provides a vagrant virtual machine so you can start contributing quickly. Joind.in is a big project, so there a few parts involved. 

## Getting Started
1. Install requirements. (Note: these are not required by joind.in itself, but are required for this quick start guide.)
   - VirtualBox and the VirtualBox Extension Pack (https://www.virtualbox.org/) (version 4.0 or later)
   - Ruby (http://www.ruby-lang.org/)
   - Vagrant (http://vagrantup.com/) version 1.5+
1. Fork the following joind.in repositories:
	- [joind.in](https://github.com/joindin/joind.in)
	- [joindin-api](https://github.com/joindin/joindin-api)
	- [joindin-web2](https://github.com/joindin/joindin-web2)
	- [joindin-vm](https://github.com/joindin/joindin-vm)
1. Clone joindin-vm 

		git clone git@github.com:%%YourGitHubId%%/joindin-vm.git --recursive

1. Execute the script that will clone the other 3 repository from your forks

		cd joindin-vm
		php scripts/cloneRepository.php


1. Start the VM

		vagrant up


1. If you don't have the [hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
   Vagrant plugin, then add hostname to /etc/hosts.
   
       If you are on Linux, run this:

            (echo ; echo "10.223.175.44 dev.joind.in api.dev.joind.in web2.dev.joind.in") | sudo tee -a /etc/hosts
       
       If you are on OSX, run this:

            echo "10.223.175.44 dev.joind.in api.dev.joind.in web2.dev.joind.in" | sudo tee -a /etc/hosts

       If you are on Windows, run this on the cmd line

            echo 10.223.175.44 dev.joind.in api.dev.joind.in web2.dev.joind.in >> %SYSTEMDRIVE%\Windows\System32\Drivers\Etc\Hosts

1. Browse to the sites
	- For the joind.in site: http://dev.joind.in/
	- For the responsive site: http://web2.dev.joind.in/
	- For the API: http://api.dev.joind.in/

1. You can log to joind.in test site with those credentials for an admin account:
		* Username: imaadmin
		* Password: password

1. For other users, [look at the dbgen documentation.](https://github.com/joindin/joindin-api/tree/master/tools/dbgen#usernames-and-passwords)

*Notes:*

- The joind.in directory you cloned will be mounted inside the VM at `/vagrant`
- You can develop by editing the files you cloned in the IDE of you choice.
- The database is running inside the VM. You can get to it with the following commands:

         you@you> vagrant ssh
         vagrant@vm> mysql joindin -uroot
         
- The database is also forwarded on port 3307 to your host, so you can also use:
  
        you@you> mysql -u joindin -h 10.223.175.44 -P 3306 -ppassword joindin

- To stop the VM so that you can work on it later, issue the following command 
  from the host machine:

         vagrant halt

- To delete the VM completely, issue the following command from the host machine:

         vagrant destroy 


## Running the tests
To install the testing tools in the VM  

1. Copy the file `puppet/hieradata/common.yaml.dist` to
   `puppet/hieradata/common.yaml`.

        cp puppet/hieradata/common.yaml.dist puppet/hieradata/common.yaml
1. Edit this file and change the value of `joindin::test::tests` to true.
1. Re provision the VM. If the VM is not on, run `vagrant up`, if it's on, run `vagrant provision`  
1. Wait for the testing tools to be installed. This will take a few minutes.  
1. Run the joind.in tests with this command from inside the VM  
```
        cd /vagrant/joind.in && phing
```  
1. Run the joindin-api tests with this command from inside the VM  
```
        cd /vagrant/joindin-api && phing
```  
1. Run the joindin-web2 tests with this command from inside the VM  
```
        cd /vagrant/joindin-web2 && phing
```  

## Troubleshooting 

### Box stored with the wrong format
If you get this error:  

        "The box 'centos-62-64-puppet' is still stored on disk in the Vagrant 1.0.x format. This box must be upgraded in order to work properly with this version of Vagrant.".   

You can fix it by running the command `vagrant box repackage centos-62-64-puppet virtualbox` and executing `vagrant up` again.

### Problem with the guest additions version
If you get a warning about a mismatch between your version of the guest addition and the one in the VM. You can make sure that the guest additions in the VM are always up to date with this command:

        vagrant plugin install vagrant-vbguest
        
If Vagrant complains that the command plugin does not exist, it's because your version of Vagrant is too old. You might need to upgrade it for the VM to work correctly.

### Vagrant Provisioning Not Executed
On the latest Vagrant version, sometimes Vagrant stops before running Puppet. If if happens, you can run it manually. 

        vagrant provision

## Mailcatcher

We use mailcatcher to grab emails before they leave the VM, and present them to you in a web interface so you can see what the system would be sending.  To check the mails that have been sent, visit [http://dev.joind.in:1080/](http://dev.joind.in:1080/) on your host machine.


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


## Packaging the box from event with slow connection

If you are at an event with a slow connection it's possible to package the box and copy it on a usb key. This way others don't need to download it.

### Download the box before the event
You can download the box from [http://cdn.19ft.com/joindin-development.1.0.0.box](http://cdn.19ft.com/joindin-development.1.0.0.box). Then copy it on a usb key and share it at the event as per the instructions for using the packaged box.


### Package the box
If you're already at the event and can't download the box, someone who already has it can package it:

1. cd into the joindin-vm directory
2. Package the vagrant box

        vagrant package

3. Copy the generated file to a usb key.

### Using the packaged box

1. Copy the box file on your machine
2. Import the box

        vagrant box add joindin/development path/to/file

3. Follow the Getting Started instructions

