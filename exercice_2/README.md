# Sniffing

## Content
- [Sniffing](#sniffing)
  - [Content](#content)
  - [Work environment](#work-environment)
  - [Work Process](#work-process)
    - [dsniff](#dsniff)
    - [How to run](#how-to-run)
    - [Result](#result)
  - [Interpretation](#interpretation)
  - [Conclusion](#conclusion)

## Work environment
The work environment is consisted of:
- three services
  - client:
    - purpose: connect to server using `telnet` protocol
    - ip: 10.10.10.3
  - server:
    - purpose: a prototype of server
    - ip: 10.10.10.2
  - sniffer
    - purpose: execute dsniff attack
    - tools: dsniff
    - ip: 10.10.10.4
- environment configuration in `.env` contains:
  - ip addresses configuration
- `docker-compose.yml` configuration

## Work Process
### dsniff
> dsniff is a collection of tools for network auditing and penetration testing. dsniff, filesnarf, mailsnarf, msgsnarf, urlsnarf, and webspy passively monitor a network for interesting data (passwords, e-mail, files, etc.). arpspoof, dnsspoof, and macof facilitate the interception of network traffic normally unavailable to an attacker (e.g, due to layer-2 switching). sshmitm and webmitm implement active monkey-in-the-middle attacks against redirected SSH and HTTPS sessions by exploiting weak bindings in ad-hoc PKI. [monkey.org]

### How to run
- execute docker-compose: `docker-compose up`
- access to client bash `docker exec -it client bash`
- acess to sniffer bash `docker exec -it sniffer bash`
- The telnet server is already configured inside the `server container`

### Result
- Test connection to server from client
``` bash
[MohamedAmin@samet ]$ sudo docker exec -it client bash
[root@f8370b23d19c /]# ping server
PING server (172.20.0.2) 56(84) bytes of data.
64 bytes from server.exercice_2_frontend (172.20.0.2): icmp_seq=1 ttl=64 time=0.130 ms
64 bytes from server.exercice_2_frontend (172.20.0.2): icmp_seq=2 ttl=64 time=0.081 ms
64 bytes from server.exercice_2_frontend (172.20.0.2): icmp_seq=3 ttl=64 time=0.079 ms
64 bytes from server.exercice_2_frontend (172.20.0.2): icmp_seq=4 ttl=64 time=0.107 ms
^C
--- server ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 54ms
rtt min/avg/max/mdev = 0.079/0.099/0.130/0.022 ms
```

- Test connection to server from sniffer
``` bash
[MohamedAmin@samet ]$ sudo docker exec -it sniffer bash
[root@a1d83a680d35 /]# ping server
PING server (172.20.0.2) 56(84) bytes of data.
64 bytes from server.exercice_2_frontend (172.20.0.2): icmp_seq=1 ttl=64 time=0.102 ms
64 bytes from server.exercice_2_frontend (172.20.0.2): icmp_seq=2 ttl=64 time=0.206 ms
64 bytes from server.exercice_2_frontend (172.20.0.2): icmp_seq=3 ttl=64 time=0.108 ms
64 bytes from server.exercice_2_frontend (172.20.0.2): icmp_seq=4 ttl=64 time=0.073 ms
64 bytes from server.exercice_2_frontend (172.20.0.2): icmp_seq=5 ttl=64 time=0.177 ms
^C
--- server ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 127ms
rtt min/avg/max/mdev = 0.073/0.133/0.206/0.050 ms
```
- Then the sniffer will execute `dsniff -m` to listent to the network
``` bash
[root@a1d83a680d35 /]# dsniff -m
dsniff: listening on eth0
```
- On the `client`, we try to connect to the `server` via `telnet` protocol. We execute some commands and then exit.
``` bash
[root@f8370b23d19c /]# telnet server
Trying 10.10.2
Connected to 10.10.10.2

login: root
password:
# ...
```

## Interpretation
- After quitting `telnet` session, the `sniffer` listening to the network will show all the commands and information written et communicated between the the `server` and the `client`.
- Using `arpspoof`, the `sniffer` had access to sensible information like passwords and threats privacy of the user.

## Conclusion
- The sniffer may have access to sensible information like:
  - login
  - passwords
- This may heavily threaten the privacy of the user
- As counter meaurement:
  - use `switch` rather than `hub`
  - use crypted protocols for sensible information like passwords
  - use sniffing detector




[monkey.org]: (https://www.monkey.org/~dugsong/dsniff/)
