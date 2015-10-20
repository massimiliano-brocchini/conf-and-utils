#!/bin/zsh

h=$HOME
u=$USER

sudo $h/bin/file_permissions_get.sh /etc || exit 1
sudo rsync -av --safe-links --delete --exclude '.svn' --exclude 'shadow*' --exclude 'gshadow*' --exclude 'ssh*key*' --exclude 'machine-id*' /etc/  $h/max-repo/$HOST/etc  || exit 1
sudo rsync -av --safe-links --delete --exclude '.svn' --exclude 'initramfs-linux*' --exclude 'vmlinuz-linux' 								/boot/ $h/max-repo/$HOST/boot || exit 1
sudo rsync -av --safe-links --delete --exclude '.svn' --exclude '.subversion' --exclude '.ssh' 												/root/ $h/max-repo/$HOST/root || exit 1

sudo mkdir -p $h/max-repo/$HOST/root/.ssh/
sudo cp /root/.ssh/known_hosts $h/max-repo/$HOST/root/.ssh/ 2> /dev/null
sudo cp /root/.ssh/config      $h/max-repo/$HOST/root/.ssh/ 2> /dev/null

sudo chown -R ${u}:users $h/max-repo/$HOST/etc $h/max-repo/$HOST/boot $h/max-repo/$HOST/root || exit 1

dir=(boot etc root)
for d in $dir; do
	cd $h/max-repo/$HOST/$d || exit 1
	pwd
	svn status | grep '!' | awk '{print $2}' | xargs --no-run-if-empty svn rm
	svn status | grep '?' | awk '{print $2}' | xargs --no-run-if-empty svn add
done
