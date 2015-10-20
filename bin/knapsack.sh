#!/bin/zsh

zmodload zsh/mathfunc

if [[ $# -ne 3 ]]; then
	echo "Description: copy content of a directory into several fixed sized directories called buckets"
	echo "Usage: `basename $0` <source dir> <dest dir> <bucket size> "
    echo "        <bucket size>: default unit KB, otherwise use one of the following suffixes M,MB,G,GB,K,KB"
	echo "e.g. : `basename $0` foto dvd 4300M"
	echo "        copy 'foto' directory into 'dvd/bucketX' directories each having about 4.3GB of maximum size"
	exit 1
fi

source_dir=$1
dest_dir=$2
bucket_size=$3

# {{{ manage human readable format for bucket size
pos=0
echo "$bucket_size\n1K\n1M\n1G" | sort -h | while read l; do
	if [[ $bucket_size == $l ]]; then
		break
	else
		(( pos++ ))
	fi
done
if [[ $pos > 0  ]]; then
	bucket_size=`echo $bucket_size | egrep -o \[.0-9\]\+`
	bucket_size=$(( floor($(( bucket_size * 1024 ** (pos-1) ))) ))
	integer bucket_size
fi
# }}}

typeset -A  size

total_size=`/bin/du -s $source_dir | awk {'print $1'}`
integer num_buckets
num_buckets=$(( ceil($(( $total_size.0/$bucket_size.0  ))) ))

mkdir -p $dest_dir/bucket{1..$num_buckets}

for i in {1..$num_buckets}; do
	size[$i]=0
done

distribute() {
	local dir=$1
	local index=1

	find  $dir -mindepth 1 -maxdepth 1 ! -type l -exec /bin/du -s {} \; | /usr/bin/sort -rn | while read s x; do

		while (( $size[$index]+$s > $bucket_size && $index <= $num_buckets )) {
			(( index++ ))
		}

		# we didn't find a bucket with enough space available: let's split $x
		if [[ $index > $num_buckets ]]; then

			if [[ -d $x ]]; then
				distribute $x 
	
			elif [[ -f $x ]]; then	#single big file: we split it and move it to as many buckets as needed
				echo "\nSplitting $x"
				/usr/bin/split --bytes=$(( (bucket_size-size[1])*1024 )) -d $x ${x}.splitted_part.
				ct=1
				find `dirname $x` -maxdepth 1 -name '*.splitted_part.*'  -exec /bin/du -s {} \;| while read fsize f; do
					echo "\nCopying $f -> $dest_dir/bucket$ct"
					/bin/cp --parents $f $dest_dir/bucket${ct}
					/bin/rm $f
					size[$ct]=$(( size[$ct]+fsize ))
					(( ct++ ))
				done
			fi

		else

			echo "\nCopying $x -> $dest_dir/bucket$index"
			/bin/cp --parents -r $x $dest_dir/bucket$index

			size[$index]=$(( size[$index]+s ))

		fi
		index=1

	done

}

distribute $source_dir

#file and symlinks lists copied in every bucket
find $source_dir -type l > $dest_dir/bucket1/symlink_list
find $dest_dir > $dest_dir/bucket1/file_list
find $source_dir -printf "%m %U %G " -ls | sed -e 's#[[:blank:]]\+# #g' | cut -d ' ' -f 1,2,3,14 > $dest_dir/bucket1/permission_list

for i in {2..$num_buckets}; do
	/bin/cp $dest_dir/bucket1/file_list 	   $dest_dir/bucket$i
	/bin/cp $dest_dir/bucket1/symlink_list     $dest_dir/bucket$i
	/bin/cp $dest_dir/bucket1/permission_list  $dest_dir/bucket$i
done
