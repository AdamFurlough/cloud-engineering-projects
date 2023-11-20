# File Access Policy

- whitelist that allows only permits execution of authorized software
- RHEL 8 ships with a file access policy daemon called "fapolicyd". "fapolicyd" is a userspace daemon that determines access rights to files based on attributes of the process and file. It can be used to either blacklist or whitelist processes or file access. Proceed with caution with enforcing the use of this daemon. Improper configuration may render the system non-functional.


## Configuration

- the fapolicyd service configuration is located in /etc/fapolicyd/
    - fapolicyd.rules contains allow and deny execution rules
    - fapolicyd.conf contains daemon's configuration options. useful for performance-tuning 
    - fapolicyd.trust file contains list of trusted files/binaries for the application whitelisting daemon


## STIG rule

- Link: https://www.stigviewer.com/stig/red_hat_enterprise_linux_8/2020-11-25/finding/V-230523
- Finding ID: V-230523	
- Version: RHEL-08-040135
- Rule ID: SV-230523r599732_rule
- Severity: Medium


## Usage

Verify the RHEL 8 "fapolicyd" is enabled and employs a deny-all, permit-by-exception policy.

Check that "fapolicyd" is installed, running, and in enforcing mode with the following commands:
```sudo yum list installed fapolicyd```

Installed Packages: fapolicyd.x86_64
```sudo systemctl status fapolicyd.service```

fapolicyd.service - File Access Policy Daemon
Loaded: loaded (/usr/lib/systemd/system/fapolicyd.service; enabled; vendor preset: disabled)
Active: active (running)

```sudo grep permissive /etc/fapolicyd/fapolicyd.conf```
permissive = 0

Check that fapolicyd employs a deny-all policy on system mounts with the following commands:
```sudo tail /etc/fapolicyd/fapolicyd.rules```

allow exe=/usr/bin/python3.4 dir=execdirs ftype=text/x-pyton
deny_audit pattern ld_so all
deny all all

```sudo cat /etc/fapolicyd/fapolicyd.mounts```

/dev/shm
/run
/sys/fs/cgroup
/
/home
/boot
/run/user/42
/run/user/1000

If fapolicyd is not running in enforcement mode on all system mounts with a deny-all, permit-by-exception policy, this is a finding.


# Fix Text (F-33167r568316_fix)

Configure RHEL 8 to employ a deny-all, permit-by-exception application whitelisting policy with "fapolicyd" using the following commands:

Install and enable "fapolicyd":
```sudo yum install fapolicyd.x86_64```
```sudo mount | egrep '^tmpfs| ext4| ext3| xfs' | awk '{ printf "%s\n", $3 }' >> /etc/fapolicyd/fapolicyd.mounts```
```sudo systemctl enable --now fapolicyd```

With the "fapolicyd" installed and enabled, configure the daemon to function in permissive mode until the whitelist is built correctly to avoid system lockout. Do this by editing the "/etc/fapolicyd/fapolicyd.conf" file with the following line:
```permissive = 1```

Build the whitelist in the "/etc/fapolicyd/fapolicyd.rules" file ensuring the last rule is "deny all all".

Once it is determined the whitelist is built correctly, set the fapolicyd to enforcing mode by editing the "permissive" line in the /etc/fapolicyd/fapolicyd.conf file.
```permissive = 0 ```

# fapolicy vs SELinux
one way that they differ is that selinux is only concerned with whether file contexts match, whereas fapolicy can also gauge integrity of a file by a known hash or file size; it's kind of like AIDE mixed with selinux in a way. Red hat article describes them as "complementary": https://www.redhat.com/en/blog/stop-unauthorized-applications-rhel-8s-file-access-policy-daemon

# More notes on adding exceptions
https://www.spxlabs.com/blog/2022/3/31/redhat-8-fapolicyd-adding-exceptions-or-adding-trusted-applications

# example tutorial
https://access.redhat.com/discussions/5895661

add location to trust policy
 ```sudo fapolicyd-cli --file add /usr/bin/java && systemctl restart fapolicyd```

check contents ```sudo cat /etc/fapolicyd/fapolicyd.trust```
returns ```/usr/bin/java 12848 6bab3f3fa3baabd38b9e8ba0330cde828c339a75fe7fc5e0cae5b2b15b162d06```
- first column is full path to the file
- second is size of the file in bytes
- third is valid SHA256 hash
