# Spoofing


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
- `goal.bash`: script to execute machine_1 and pirate commands
- `docker-compose.yml` configuration
  

## Work Process
### arpspoof
arpspoof mounts an ARP spoofing attack against a host on the local network. This results in traffic from the attacked host to the default gateway (and all non-LAN hosts) and back going through the local computer and can thus be captured with tools like Wireshark. arpspoof will also forward this traffic, so Windows does NOT have to be configured as a router.[1]

### How to run
- execute docker-compose: `docker-compose up`
- access to machine_1 bash: `docker exec -it machine_1 bash`
- access to pirate bash: `docker exec -it pirate bash`
- then execute in sequence these commands:
  - machine_1: ``
  - pirate: ``

### Result
- before executing the attack:
![before_attack](demonstration/before_attack.png)

- after executing the attack:
![after_attack](demonstration/after_attack.png)

```
[MohamedAmin@samet TP1]$ sudo docker exec -it pirate bash
[root@3186b137c19b /]# hping3 --flood -p 80 -S pirate
HPING pirate (eth0 10.10.10.4): S set, 40 headers + 0 data bytes
hping in flood mode, no replies will be shown
```

## Interpretation
- The pirate sends sequence of requests to the server in high frequency.
- The server has to interprete each of these requests and thats makes it busy
- CPU status of the server becomes very high after executing the attack
- If the server has lower specifications, it will be fully charged and it may not have the opporunity to manage requests from real users

## Conclusion
- Every accessible server may be target of Flooding attack
- As counter measurment to Flooding attack, detect earlier the DoS attack and prevent massive SynFlooding by blocking attackers addresses.
- Blocking and detecting DoS attack may be really easy. But in case of attack from multiple devices or zombie clients (DDos), it may be really hard to distinguish the real clients from the fake ones.




[1]: https://github.com/alandau/arpspoof