#!/bin/bash

if [ -f ./mymainout ]; then
	rm ./mymainout
fi
if [ -f ./mytwelvedaysout ]; then
	rm ./mytwelvedaysout
fi

touch mymainout
touch mytwelvedaysout

./maintest >> mymainout
./twelvedaystest >> mytwelvedaysout

diff ./mymainout ./mainout
diff ./mytwelvedaysout  ./twelvedaysout

echo "if diff didn't output anything then you're good!"
