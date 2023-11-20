# Backing up an XFS file system

- [Red Hat Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_file_systems/assembly_backing-up-an-xfs-file-system_managing-file-systems)

Install
- sudo yum install xfsdump –y

Usage
-	sudo xfsdump –l 0 –L “label” –f [backup location] [fs current mount point]
-	sudo xfsdump –l 0 –L “label” –f /mnt/testpart2/backup.xfsdump /mnt/testpart3

# Restoring an XFS file system from backup
- [Red Hat Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_file_systems/assembly_recovering-an-xfs-file-system-from-backup_managing-file-systems)

Xfsrestore command usage
- xfsrestore [-r] [-S session-id] [-L session-label] [-i] -f backup-location restoration-path
- Example backup location:   /mnt/testpart2/backup.xfsdump
- Example restoration-path:   /mnt/testpart3

Full command
- sudo xfsrestore -f /mnt/testpart2/backup.xfsdump /mnt/testpart3
