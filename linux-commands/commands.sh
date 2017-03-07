#!/bin/bash
x=1
echo $x
# Get Kernel and OS details
uname -a
# Get current IP address
ip a s eth0
ip addr show eth0
# Check free disk space
df -ha
# Check services
service udev status # check if service is running
systemctl status udev # newer version for checking
# Check size of a directory
du -sh /home/stefan/random
# Check open ports on machine
sudo netstat -tulpn
# Check CPU usage for a process
ps aux | grep subl # or top
# How to mount volumes
#mount /dev/sda-fake /mnt
mount # get mounted devices
# Get swap and UUID on partitions
cat /etc/fstab

# Note for using bash build system on sublime text add the following:
# {
#     "cmd"       : ["bash", "$file"],
#     "selector"  : "source.shell"
# }
