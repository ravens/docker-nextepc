# docker-nextepc
Docker-based LTE environement featuring NextEPC as MME, SGW and PGW, and srsLTE using the FauxRF patch to simulate a UE and an eNB.

## architecture



## setup 

```
docker-compose build --no-cache
```

## initial configuration (one time only)

This is simular to the tutorial of NextEPC (https://nextepc.org/docs/tutorial/1-your_first_lte/).

We need to provision the HSS database with the IMSI of the SIM card we are using in our simulated UE. In order to provision it right now we go with the Web interface from NextEPC:
```
docker-compose up webui -d
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
