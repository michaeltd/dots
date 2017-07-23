#!/bin/env /bin/bash
#/home/paperjam/git/go-ethereum/build/bin/geth --fast --cache=512 console --mine --minerthreads=1 --etherbase=0x0000000000000000000000000000000000000000
#function keepParamAlive {
# Take a parameter and respawn it periodicaly if it crashes. check interval is second param seconds
while [ true ]; do
    # Endless loop.
    pid=`pgrep -x geth`
    # Get a pid.
    if [[ -z "${pid}" ]]; then
    	# If there is no proc associated with it,
    	#/home/paperjam/git/go-ethereum/build/bin/geth --fast --cache=512 console --mine --minerthreads=1 --etherbase=0x0000000000000000000000000000000000000000
    	/home/paperjam/git/go-ethereum/build/bin/geth console --cache=64 --jitvm --fast --mine --minerthreads=1 --etherbase=0x0000000000000000000000000000000000000000 2>> ~/.ethereum/debug.log
    	# Start Param to background.
    else
    	sleep 120
    	# wait $second parameter's ''seconds
    fi
done
#}
