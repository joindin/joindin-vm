joindin-vm
==========

Quick way to get the platform for joind.in development set up

This repository provides a vagrant virtual machine so you can start contributing quickly. Joind.in is a big project, so there a few parts involved. 

## Getting Started
1. Install requirements. (Note: these are not required by joind.in itself, but are required for this quick start guide.)
   - VirtualBox (https://www.virtualbox.org/) (versions 4.0 and 4.1 are currently supported)
   - Ruby (http://www.ruby-lang.org/)
   - Vagrant (http://vagrantup.com/)
1. Fork the following joind.in repository
	- [joind.in](https://github.com/joindin/joind.in)
	- [joindin-api](https://github.com/joindin/joindin-api)
	- [joindin-web2](https://github.com/joindin/joindin-web2)
	- [joindin-vm](https://github.com/joindin/joindin-vm)
1. Clone joindin-vm 

		git clone git@github.com:%%YourGitHubId%%/joindin-vm.git --recursive

1. Execute the script that will clone the other 3 repository from your forks

		php scripts/cloneRepository.php


1. Start the VM

		vagrant up

1. Add hostname to /etc/hosts.
   If you are on Linux, run this:

        echo "\n127.0.0.1 dev.joind.in api.dev.joind.in web2.dev.joind.in" | sudo tee -a /etc/hosts
   
   If you are on OSX, run this:

        echo "127.0.0.1 dev.joind.in api.dev.joind.in web2.dev.joind.in" | sudo tee -a /etc/hosts

   If you are on Windows, run this on the cmd line

        echo 127.0.0.1 dev.joind.in api.dev.joind.in web2.dev.joind.in >> %SYSTEMDRIVE%\Windows\System32\Drivers\Etc\Hosts
1. Browse to the sites
	- For the joind.in site: http://dev.joind.in:8080/
	- For the responsive site: http://web2.dev.joind.in:8080/
	- For the API: http://api.dev.joind.in:8080/
1. You can log to joind.in test site with those credentials for an admin account:
		* Username: imaadmin
		* Password: password
1. For other users, [look at the dbgen documentation.](https://github.com/joindin/joindin-api/tree/master/tools/dbgen#usernames-and-passwords)

*Notes:*

- HTTP and SSH ports on the VM are forwarded to localhost (22 -> 2222, 80 -> 8080)
- The joind.in directory you cloned will be mounted inside the VM at `/vagrant`
- You can develop by editing the files you cloned in the IDE of you choice.
- The database is running inside the VM. You can get to with the following commands:

         you@you> vagrant ssh
         vagrant@vm> sudo -i
         root@vm> mysql joindin -uroot

- To stop the VM so that you can work on it later, issue the following command 
  from the host machine:

         vagrant halt

- To delete the VM completely, issue the following command from the host machine:

         vagrant destroy 


## Running the tests
To install the testing tools in the VM  

1. Edit the file `puppet/manifests/params.pp`. Change the value of $tests to true.  
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




