# packer-ubuntu-vagrant-22.04


```
This Project is Built on Below Versions:
----------------------------------------
Packer 1.7.7
VirtualBox 7.0.18
Vagrant 2.4.1
```

```
Previous SSH Issue:
-------------------
We’re using the new AutoInstall method for Ubuntu 20.04.
Previous versions use debian-installer preseeding, but that method didn’t
immediately work with the new ISO.
Subiquity installer, which is the Ubuntu server’s new automated installer

Subiquity is the Ubuntu server’s new automated installer, which was introduced in 18.04.
It is the server counterpart of ubiquity installer used by desktop live CD installation.
Autoinstallation lets you answer all those configuration questions ahead of time with autoinstall config
and lets the installation process run without any external interaction.
The autoinstall config is provided via cloud-init configuration.
Values are taken from the config file if set, else default values are used.

There are multiple ways to provide configuration data for cloud-init.
Typically user config is stored in user-data and cloud specific config in meta-data file.
The list of supported cloud datasources can be found in cloudinit docs.
Since packer builds it locally,
data source is NoCloud in our case and the config files will served to the installer over http.

Previous versions use debian-installer preseeding method,
But now using the new Subiquity AutoInstall method from Ubuntu 20.04 onwards.
The new Ubuntu Server installer starts an SSH server.The credentials are installer:<random_pw>
Packer wrongfully tries to connect to this SSH,
thinking the VM is ready for further provisioning steps - which it is NOT.

We simply change the port packer expects the ssh server to run at to something else AND
during cloud-init late_commands we override the servers port accordingly.
That way once the cloud-init finishes and reboots the VM the
ssh server will run at the new port - now packer picks up on that and
continues provisiong as we are used to.
As a last step durng provision, we remove the conf file,
essentially resettign the ssh server port back to default 22.

means,
If we install the SSH server using the subiquity `ssh` configuration then
port 22 gets opened up to packer _before_ the requisite configuration
has been done to allow Packer to SSH on to the guest O/S.
This results in a failed build. as Packer exceeds its SSH permitted
number of SSH handshake attempts, To ensure this doesn't happen then
we stop the SSH service until right at the end when we re-enable it using a late-command.

early-commands:
    - sudo systemctl stop ssh    
late-commands:
    - sudo systemctl start ssh

Please check on the logic behind communicator setting "pause_before_connecting".
That setting actually does still try to connect ONCE and then waits,
instead of waiting for the specified duration and then and only then trying to connect. Thanks!
```

```
cd ubuntu_22043
packer init .
packer build .

or

# With optional runtime variables, values default to false and 2048
packer build -var 'headless_build=true' -var 'memory_amount=8192' .

vagrant box add --name virtualbox-ubuntu2204 file:///D:/PACKER/UBUNTU-PACKER-22.04/build/ubuntu-22043-server-20240703060231.box
vagrant up
vagrant ssh
```
