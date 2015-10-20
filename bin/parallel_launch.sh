#!/bin/zsh
# didn't knew GNU parallel existed...

if [[ $# -lt 2 ]]; then
	echo "Description: given a list of tasks executes them with the specified degree of parallelism"
	echo "Usage: `basename $0` <degree of parallelism> <file with task list> [<sleep time in sec>]"
	exit 1
fi

CORE_NUM=$1
TASKS=$2
SLEEP=${3:-300}

if [[ ! -f "$TASKS" ]]; then
	echo "File $TASKS does not exist"
	exit 1
fi

FINGERPRINT=`mktemp --suffix=plaunch`

cat "$TASKS" | while read cmd; do
	FREE_CORES=$(( CORE_NUM - `ps auxww | grep $FINGERPRINT | grep -v grep | wc -l` ))
	while [[ $FREE_CORES -le 0 ]]; do
		sleep $SLEEP
		FREE_CORES=$(( CORE_NUM - `ps auxww | grep $FINGERPRINT | grep -v grep | wc -l` ))
	done
	/bin/zsh -c "$cmd ; echo > $FINGERPRINT" &
done

# exit from script only when all tasks are completed
BUSY_CORES=`ps auxww | grep $FINGERPRINT | grep -v grep | wc -l`
while [[ $BUSY_CORES -gt 0 ]]; do
	sleep $SLEEP
	BUSY_CORES=`ps auxww | grep $FINGERPRINT | grep -v grep | wc -l`
done
