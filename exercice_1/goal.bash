#! /bin/bash


echo '[INFO]: *** STEP 1 ***'
echo '[INFO]: running john configuration on:'

echo '[INFO]: /pass/pass1'
john /pass/pass1
echo '[INFO]: /pass/pass2'
john /pass/pass2
echo '[INFO]: /pass/pass3'
john /pass/pass3

echo '[INFO]: "pass3" configuration takes a lot of time'
echo

echo '[INFO]: *** STEP 2 ***'
echo '[INFO]: /pass/pass1 result:'
john --show /pass/pass1
read -p 'press <enter>'; echo

echo '[INFO]: /pass/pass2 result:'
john --show /pass/pass2
read -p 'press <enter>'; echo

echo '[INFO]: /pass/pass3 result:'
john --show /pass/pass3
read -p 'press <enter>'; echo

echo '[INFO]: *** step 3 ***'
echo '[INFO]: trying to crack "pass3" using the password list file "/list/password.lst"'
john --wordlist=/list/password.lst --rules /pass/pass3



