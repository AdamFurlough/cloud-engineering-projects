# Shrink root partition on a RHEL EC2 server

Goal: Need to shrink root volume on Server1, will use Server2 to work on the volume

1.	Stop Server1
2.	Detach EBS volume from Server1
3.	Attach EBS volume to Server2
4.	Make directory to mount transient root volume: # mkdir /mnt/server1root
5.	Mount transient root volume: # mount -t xfs -o nouuid /dev/xvdf4 /mnt/server1root
6.	Check UUID of transient root volume and save it for later: $ lsblk -f
7.	Install xfsdump: # yum install xfsdump -y                              
8.	Make directory for backup: # mkdir /mnt/backup
9.	Make backup: # xfsdump -f /mnt/backup/backup.xfsdump /mnt/server1root    
10.	Unmount transient root volume: # umount /dev/xvdf4
11.	Delete partition and create two new, smaller ones using fdisk
    - fdisk /dev/xvdf
      - d (delete)
      - 4 (delete partition 4)
      -	n (create new partition)
      -	4 (create new partition 4)
      -	Default start sector
      -	+5GB for ending sector
      -	n (create new partition)
      -	5 (create new partition 5)
      -	Default start sector
      -	Default end sector
      -	w (write out)
12.	Make new file systems for all new partitions: # mkfs.xfs -f /dev/xvdf4
13.	Set UUID back to what is was before: # xfs_admin  -U 0027cd81-ffab-44f9-aea0-34d1e8e1a4c9 /dev/xvdf4
14.	Check UUID: $ lsblk -f
15.	Remount transient root volume: # mount -t xfs -o nouuid /dev/xvdf4 /mnt/server1root
16.	Find xfsrestore session id: # xfsrestore -I | grep session
17.	# xfsrestore -f /mnt/backup/backup.xfsdump -S a316e7e3-9c08-4bb2-9ee9-cf55defd9a82 /mnt/server1root
18.	Restore from backup: # xfsrestore -f /mnt/backup/backup.xfsdump /mnt/server1root
19.	Unmount transient root volume: # umount /dev/xvdf4
20.	Stop Server2
21.	Detach EBS volume from Server2
22.	Reattach to Server1 (be sure to set device name to /dev/sda1)
23.	Start Server1 and test: $ lsblk -f
          
## Cleanup (optional)
·	If you created an additional partition don’t forget to add it to fstab
·	Uninstall xfsdump tool on Server1: # yum remove xfsdump
·	Delete backup file on Server1 “/mnt/backup/backup.xfsdump”
·	Remove Server1 mountpoints “/mnt/server1root” and “/mnt/backup”
