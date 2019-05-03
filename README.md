# docker-nextepc
Docker-based LTE environement featuring NextEPC as MME, SGW and PGW, and srsLTE using the FauxRF patch to simulate a UE and an eNB.

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

## initial configuration (one time only)

This is simular to the tutorial of NextEPC (https://nextepc.org/docs/tutorial/1-your_first_lte/).

We need to provision the HSS database with the IMSI of the SIM card we are using in our simulated UE. In order to provision it right now we go with the Web interface from NextEPC:
```
docker-compose up -d webui 
```

Then go on http://localhost:3000, user admin, password 1423 then we need to fill the following info:
```
IMSI : 001010000000001
K : c8eba87c1074edd06885cb0486718341
OPc : 17b6c0157895bcaa1efc1cef55033f5f
``` 

And that's it.

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
ue         | Found PLMN:  Id=00101, TAC=1
ue         | Random Access Transmission: seq=50, ra-rnti=0x2
enb        | RACH:  tti=6221, preamble=50, offset=0, temp_crnti=0x46
ue         | RRC Connected
ue         | Random Access Complete.     c-rnti=0x46, ta=0
ue         | Network attach successful. IP: 45.45.0.2
enb        | User 0x46 connected
```

It means the UE has correctly attached the core network.

In order to send some traffic when the UE is attached:
```
docker exec -it ue route add default tun_srsue # define default route
docker exec -it ue ping 8.8.8.8
docker exec -it ue /bin/bash # interactive shell
docker restart ue # reconnect UE
```

In my experience the FauxRF is not really super stable, but enough to generate S1AP and GTP traffic and start learning on LTE networks on an end-to-end fashion.

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

## configuration

 * nextEPC config is exclusively in ./config
 * the IP addresses are declared in the config files and the docker-compose.yml
 * the srsUE/srseNB are declared as environement variables in docker-compose.yml
