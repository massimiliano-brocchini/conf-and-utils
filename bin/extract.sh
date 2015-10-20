#!/bin/zsh

PATH=/bin:/usr/bin:/sbin:/usr/sbin

#array
list=()
needs_dir_creation=0
dir=''
archive=$1

unrar_list() {
	unrar t $1 | egrep '^Testing.*OK' | tac | while read testing file ok; do
		list+=($file)
	done
}

tar_list() {
	tar tvf $1 | while read permissions user size date time file; do
		list+=($file)
	done
}


unzip_list() {
	found=-1
	unzip -l $1 | head -n -2 | while read size date time file; do
		if [[ "$file" == "----" ]]; then
			found=0
			continue
		fi
		if [[ $found == 0 ]]; then 
			list+=($file)
		fi
	done
}


verify_path() {
	p=`expr match $list[1] "\(\(./\)\?[^/]*\)"`
	for f in $list; do
		c=`expr match $f "\(\(./\)\?[^/]*\)"`
		if [[ "$p" != "$c" ]]; then
			needs_dir_creation=1
			break
		fi
	done

	if [[ $needs_dir_creation == "1" ]]; then
		dir1=${archive##*/}
		dir=${dir1%.tar.gz} #strip tar.gz extension
		if [[ $dir1 == $dir ]]; then #if it is not tar.gz file, strip extension
			dir=${dir1%.*}
		fi
		if [[ -e $dir ]]; then 
			echo "Cannot extract $archive: \n directory $dir already exists"
			exit 1
		fi
		mkdir $dir
	fi
}

case $archive in
	*.zip | *.xpi | *.war)
		unzip_list $archive
		verify_path
		if [[ $needs_dir_creation == "0" ]]; then
			unzip $archive
		else
			unzip -d $dir $archive
		fi
	;;
	*.tar.* | *.tgz)
		tar_list $archive
		verify_path
		if [[ $needs_dir_creation == "0" ]]; then
			tar xvf $archive
		else
			tar -C ./$dir -xvf $archive
		fi
	;;
	*.rar)
		unrar_list $archive
		verify_path
		if [[ $needs_dir_creation == "0" ]]; then
			unrar x $archive
		else
			unrar x -ad $archive
		fi
	;;

esac
