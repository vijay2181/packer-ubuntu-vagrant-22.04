# packer-ubuntu-vagrant-22.04


```
This Project is Built on Below Versions:

Packer 1.7.7
VirtualBox 7.0.18
Vagrant 2.4.1
```

```
Previous SSH Issue:
-------------------
We’re using the new AutoInstall method for Ubuntu 20.04. Previous versions use debian-installer preseeding, but that method didn’t immediately work with the new ISO.
Subiquity installer, which is the Ubuntu server’s new automated installer 

Previous versions use debian-installer preseeding method, But now using the new Subiquity AutoInstall method from Ubuntu 20.04 onwards. The new Ubuntu Server installer starts an SSH server.The credentials are installer:<random_pw>
Packer wrongfully tries to connect to this SSH, thinking the VM is ready for further provisioning steps - which it is NOT.

We simply change the port packer expects the ssh server to run at to something else AND during cloud-init late_commands we override the servers port accordingly. That way once the cloud-init finishes and reboots the VM the ssh server will run at the new port - now packer picks up on that and continues provisiong as we are used to.
As a last step durng provision, we remove the conf file, essentially resettign the ssh server port back to default 22.
means,
If we install the SSH server using the subiquity `ssh` configuration then port 22 gets opened up to packer _before_ the requisite configuration has been done to allow Packer to SSH on to the guest O/S. This results in a failed build. as Packer exceeds its SSH permitted number of SSH handshake attempts, To ensure this doesn't happen then we stop the SSH service until right at the end when we re-enable it using a late-command.

early-commands:
    - sudo systemctl stop ssh    
late-commands:
    - sudo systemctl start ssh

Please check on the logic behind communicator setting "pause_before_connecting".
That setting actually does still try to connect ONCE and then waits, instead of waiting for the specified duration and then and only then trying to connect. Thanks!
```
