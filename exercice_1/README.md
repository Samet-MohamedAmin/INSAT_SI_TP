# Cracking
In this exercice, we are going to test password cracking attack with the well known john the ripper program.

## Work Environment
The work environment is consisted of `fedora:29` image containing:
- installed `john` program
- the target password files inside `/pass`
- the password list inside `password.lst`
- `goal.bash` as executable script inside `/bin` directory

## Work Process
### john the ripper
John the Ripper is a free password cracking software tool. Initially developed for the Unix operating system, it now runs on fifteen different platforms.[1]

We are going to use john program for cracking three password files.

### How to run
1. `docker built . -t si_tp_ex_1` to create our working image from `dockerfile`
2. `docker run -d si_tp_ex_1` to create a running container.
3. `docker attach <container_id>` where `<container_id>` is the produced id from the previous command
4. then all we have to do is to run `goal.bash`

### Result

```
[root@6814dc0c2ad1 /]# goal.bash
[INFO]: *** STEP 1 ***
[INFO]: running john configuration on password files
[INFO]: running john configuration on /pass/pass1
Created directory: /root/.john
Loaded 1 password hash (md5crypt [MD5 32/64 X2])
Press 'q' or Ctrl-C to abort, almost any other key for status
admin            (admin)
1g 0:00:00:00 100% 1/3 2.040g/s 4.081p/s 4.081c/s 4.081C/s admin..Admin
Use the "--show" option to display all of the cracked passwords reliably
Session completed
[INFO]: running john configuration on /pass/pass2
Loaded 1 password hash (md5crypt [MD5 32/64 X2])
Press 'q' or Ctrl-C to abort, almost any other key for status
1234             (admin)
1g 0:00:00:01 100% 2/3 1.000g/s 850.0p/s 850.0c/s 850.0C/s 1234..qwerty
Use the "--show" option to display all of the cracked passwords reliably
Session completed
[INFO]: running john configuration on /pass/pass3
Loaded 1 password hash (md5crypt [MD5 32/64 X2])
Press 'q' or Ctrl-C to abort, almost any other key for status
t1               (admin)
1g 0:00:05:13 3/3 0.003193g/s 12692p/s 12692c/s 12692C/s t1..n4
Use the "--show" option to display all of the cracked passwords reliably
Session completed
[INFO]: "pass3" configuration takes a lot of time

[INFO]: *** STEP 2 ***
[INFO]: /pass/pass1 result:
admin:admin

1 password hash cracked, 0 left
press <enter>

[INFO]: /pass/pass2 result:
admin:1234

1 password hash cracked, 0 left
press <enter>

[INFO]: /pass/pass3 result:
admin:t1

1 password hash cracked, 0 left
press <enter>

[INFO]: trying to crack "pass3" using the password list file "/list/password.lst"
Loaded 1 password hash (md5crypt [MD5 32/64 X2])
No password hashes left to crack (see FAQ)
```

## Interpretation
### Step 1
The first part consisted of configuring john.
The result from the first two password files comes very fast.
- pass1: `1g 0:00:00:00 100% 1/3 2.040g/s 4.081p/s 4.081c/s 4.081C/s admin..Admin`
- pass2: `1g 0:00:00:01 100% 2/3 1.000g/s 850.0p/s 850.0c/s 850.0C/s 1234..qwerty`  

Whereas, the result of the third password file need much more time because it is not a common used password to guess although it is so simple password of two characters.
- pass3: `1g 0:00:05:13 3/3 0.003193g/s 12692p/s 12692c/s 12692C/s t1..n4`


### Step 2
The second step consisted of viewing the result for the cracking process.
- pass1: `admin:admin`
- pass2: `admin:1234`
- pass3: `admin:t4`

### Step 3
The last step consisted of guessing the password using combinations from custom list of passwords.
This may be really helpful if we have personal inforamtion of the user.

## Conclusion
- Cracking passwords is possible even if we have no information about the user.
- Guessing the passsword becomes really fast if the password is composed of common words or related to personal information.
- As counter mesurment to password cracking :
  - Add two factor authentication
  - Force users to use hard passwords composed of uppercase letters, lowercase letters, digits, dots, ...
  - Use certified reliable password manager.


[1]: https://en.wikipedia.org/wiki/John_the_Ripper

