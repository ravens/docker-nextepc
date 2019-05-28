# docker-nextepc
Docker-based LTE environement featuring NextEPC as MME, SGW and PGW, and srsLTE using the FauxRF patch to simulate a UE and an eNB. Also provided, alternate docker-compose for all-in-one EPC kind of node, and physical UE/eNB lab configuration. 

[![Build Status](https://travis-ci.org/ravens/docker-nextepc.svg?branch=master)](https://travis-ci.org/ravens/docker-nextepc)

## architecture

```
                                                  ┌───────────────┐   ┌───────────────┐                           ┌───────────────┐       
                                                  │               │   │               │                           │               │       
                                                  │               │   │               │                           │               │       
                                                  │  MongoDB      │   │  NextEPC HSS  │                           │  NextEPC PCRF │       
                                                  │               │   │               │                           │               │       
                                                  │               │   │               │                           │               │       
                                                  │               │   │               │                           │               │       
                                                  └─┬─────────────┘   └────┬──────────┘                           └────┬──────────┘       
             ┌──────────────────┐                   │                      │                                           │                  
             │shared memory IPC │                   │                      │                                           │                  
┌────────────┴──┬─────────┬─────┴─────────┐         │   ┌───────────────┐  │┌───────────────┐   ┌───────────────┐      │                  
│               │         │               │         │   │               │  ││               │   │               │      │                  
│               │         │               │         │   │               │  ││               │   │               │      │                  
│  srsUE        │         │  srseNB       ├─────────┼───▶  NextEPC MME  ├──┼▶  NextEPC SGW  │   │  NextEPC PGW  │      │                  
│               │         │               │         │   │               │  ││               │   │               │      │                  
│               │         │               │         │   │               │  ││               ├───▶   TUN+NAT     │      │                  
│      ■━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━━━━━━━╋━━━━━━━━━╋━━━╋━━━━━━━━━━━━━━━╋━━╋╋━━━━━━━━━━━━━━━╋━━━╋━━━━━━■        │      │                  
└───────────────┘         └──────┬────────┘         │   └───────┬───────┘  │└───────┬───────┘   └────────┬──────┘      │                  
                                 │                  │           │          │        │                    │             │                  
                                 │                  │           │          │        │                    │             │                  
                                 │                  │           │          │        │                    │             │                  
                        ─────────▼──────────────────▼───────────▼──────────▼────────▼────────────────────▼─────────────▼─────────────────▶
                        192.168.26.0/24                                                                                                   
```

## setup 

```
docker-compose build --no-cache
```

## running

We just need to run the docker-compose:
```
docker-compose up -d
```

The following service should be running:
```
docker-compose ps
 Name                Command               State           Ports
-------------------------------------------------------------------------
enb       stdbuf -o L srsenb /config ...   Up
hss       /bin/sh /etc/nextepc/run_h ...   Up
mme       /bin/sh /etc/nextepc/run_m ...   Up
mongodb   docker-entrypoint.sh mongod      Up      27017/tcp
pcrf      /bin/sh /etc/nextepc/run_p ...   Up
pgw       /bin/sh /etc/nextepc/run_p ...   Up
sgw       /bin/sh /etc/nextepc/run_s ...   Up
ue        stdbuf -o L srsue /config/ ...   Up
webui     npm run start --prefix /ne ...   Up      0.0.0.0:3000->3000/tcp
```

After a while this should settle done and you should see the following kind of output :
```
e               | Found PLMN:  Id=00101, TAC=1
ue               | Random Access Transmission: seq=46, ra-rnti=0x2
enb              | RACH:  tti=631, preamble=46, offset=0, temp_crnti=0x46
ue               | RRC Connected
ue               | Random Access Complete.     c-rnti=0x46, ta=0
sgw              | 05/25 22:42:54.275: [gtp] INFO: gtp_connect() [192.168.26.20]:2123 (gtp_path.c:77)
sgw              | 05/25 22:42:54.275: [gtp] INFO: gtp_connect() [192.168.26.40]:2123 (gtp_path.c:77)
pgw              | 05/25 22:42:54.276: [gtp] INFO: gtp_connect() [192.168.26.30]:2123 (gtp_path.c:77)
pgw              | 05/25 22:42:54.276: [pgw] INFO: UE IMSI:[001010000000001] APN:[internet] IPv4:[45.45.0.2] IPv6:[] (pgw_context.c:922)
pgw              | 05/25 22:42:54.276: [gtp] INFO: gtp_connect() [192.168.26.30]:2152 (gtp_path.c:77)
sgw              | 05/25 22:42:54.279: [gtp] INFO: gtp_connect() [192.168.26.40]:2152 (gtp_path.c:77)
ue               | Network attach successful. IP: 45.45.0.2
enb              | User 0x46 connected
pgw              | 05/25 22:42:54.276: [gtp] INFO: gtp_connect() [192.168.26.30]:2123 (gtp_path.c:77)
pgw              | 05/25 22:42:54.276: [pgw] INFO: UE IMSI:[001010000000001] APN:[internet] IPv4:[45.45.0.2] IPv6:[] (pgw_context.c:922)
pgw              | 05/25 22:42:54.276: [gtp] INFO: gtp_connect() [192.168.26.30]:2152 (gtp_path.c:77)
sgw              | 05/25 22:42:54.275: [gtp] INFO: gtp_connect() [192.168.26.20]:2123 (gtp_path.c:77)
sgw              | 05/25 22:42:54.275: [gtp] INFO: gtp_connect() [192.168.26.40]:2123 (gtp_path.c:77)
sgw              | 05/25 22:42:54.279: [gtp] INFO: gtp_connect() [192.168.26.40]:2152 (gtp_path.c:77)
sgw              | 05/25 22:42:54.523: [gtp] INFO: gtp_connect() [192.168.26.60]:2152 (gtp_path.c:77)
ue               | (t
ue               | ! 25/5/2019 22:42:54 TZ:0
sgw              | 05/25 22:42:54.523: [gtp] INFO: gtp_connect() [192.168.26.60]:2152 (gtp_path.c:77)
```

It means the UE has correctly attached the core network.

In order to send some traffic when the UE is attached:
```
docker exec -it ue route add default tun_srsue # define default route
docker exec -it ue ping 8.8.8.8
docker exec -it ue /bin/bash # interactive shell
docker restart ue # reconnect UE
```
fauxRF is still not upstream, but its results are promising for CI/CD usage. 

One can get immediatly some cellular traffic, for example at the SGW:
```
docker exec -it sgw tshark -i eth0
   61 14.520414499 192.168.26.20 ? 192.168.26.30 GTPv2 84 Delete Session Request
   62 14.520473219 192.168.26.30 ? 192.168.26.40 GTPv2 84 Delete Session Request
   63 14.522025983 192.168.26.40 ? 192.168.26.30 GTPv2 60 Delete Session Response
   64 14.522073889 192.168.26.30 ? 192.168.26.20 GTPv2 60 Delete Session Response
   65 19.118310518 192.168.26.20 ? 192.168.26.30 GTPv2 205 Create Session Request
   66 19.118397529 192.168.26.30 ? 192.168.26.40 GTPv2 205 Create Session Request
   67 19.120766491 192.168.26.40 ? 192.168.26.30 GTPv2 109 Create Session Response
   68 19.120825323 192.168.26.30 ? 192.168.26.20 GTPv2 109 Create Session Response
   69 19.352360956 192.168.26.20 ? 192.168.26.30 GTPv2 76 Modify Bearer Request
   70 19.352427459 192.168.26.30 ? 192.168.26.20 GTPv2 60 Modify Bearer Response
   77 26.399908106    45.45.0.3 ? 8.8.8.8      GTP <ICMP> 134 Echo (ping) request  id=0x0016, seq=1/256, ttl=64
   78 26.399944051    45.45.0.3 ? 8.8.8.8      GTP <ICMP> 134 Echo (ping) request  id=0x0016, seq=1/256, ttl=64
   79 27.420034537    45.45.0.3 ? 8.8.8.8      GTP <ICMP> 134 Echo (ping) request  id=0x0016, seq=2/512, ttl=64
   80 27.420090837    45.45.0.3 ? 8.8.8.8      GTP <ICMP> 134 Echo (ping) request  id=0x0016, seq=2/512, ttl=64
```

## others options :
 * all-in-one EPC using [docker-compose -f docker-compose-allinone-epc.yml](./docker-compose-allinone-epc.yml) with the simulatoed UE+eNB using srsLTE
 * standalone using the network of the host with [docker-compose -f docker-compose-standalone.yml](./docker-compose-standalone.yml). A [Vagrantfile](./Vagrantfile) and an [Ansible](./playbook-standalone.yml) playbook are provided to simulate a deployment in the cloud.
 * all-in-one EPC with a physical eNB using [docker-compose -f docker-compose-allinone-epc-physical-eNB.yml](./docker-compose-allinone-epc-physical-eNB.yml) - in that case the docker-compose is creating a br-lab device, you just need to add conveniently your physical network to that bridge using something like :
 ```
 ip link set eth0 master br-lab
 ```
A DHCP service using dnsmasq is providing addresses to the physical eNB in that case.


## configuration

The SIM card provisioned in the virtual UE (from srsUE) and the EPC is using the following parameters : 
 * IMSI=001010000000001
 * Ki=c8eba87c1074edd06885cb0486718341
 * OPc=17b6c0157895bcaa1efc1cef55033f5f
 
 Make sure to flash your SIM accordingly when using the physical eNB docker-compose example with your own eNB, using the sysmocom SIM for example.
