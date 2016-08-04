```
# https://stackoverflow.com/questions/1030169/easy-way-pull-latest-of-all-submodules
git pull --recurse-submodules
git submodule update --recursive

git submodule update --recursive --remote
```

Starting from bare metal, these commands were used to upgrade the system from Ubuntu 14.04.1 to 16.04.1:
```
# Upgrade all packages because `do-release-upgrade` assumes they are current.
apt-get update && apt-get dist-upgrade -yqq

# At this point the boot partition was too small to hold any more kernels.
# apt-get autoremove is configured by default to keep the last 2 kernels,
# but there is not enough space for 3 and I have not yet figured out how to
# repartition a running system.

# Optional: I was not comfortable with deleting the version of the kernel that
# was running, so I restarted the system to load the latest kernel.
shutdown -r now

# Commands such as `purge-old-kernels --keep 1` can remove old kernels,
# but they pull in too many dependencies so I settled for removing them manually.
apt-get purge -y linux-image-<OLD_VERSION>-generic

# Upgrade to the next Long Term Support release. An LTS release is not considered
# stable by `do-release-upgrade` until the *.*.1 release.
# See the man page for flags to check and install development releases.
do-release-upgrade
```

An attempt was made to automate the distribution release upgrade with ansible.
It is possible to run `do-release-upgrade -f DistUpgradeViewNonInteractive`,
but the default option for all prompts is 'no'.
From a bare metal upgrade, the desired response is 'yes'. See `man apt.conf`.

This command was used to initialize since users/sshd were not configured:
`ansible-playbook --limit chirabisu.xyz --diff -u root -k`

Afterwards, this command was used for updates:
`ansible-playbook --limit chirabisu.xyz --diff -K`


TODO: Check out http://ksplice.oracle.com/try/ for online kernel upgrades
http://www.ksplice.com/doc/ksplice.pdf
