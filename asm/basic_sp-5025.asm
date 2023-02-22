;----------------------------------------------------
; Project: BASIC_SP-5025.MZF
; Main File: BASIC_SP-5025.MZF.ASM
; Date: 09/05/2021 10:03:22
;
; Created with SUC vbDISX.
;
;----------------------------------------------------
; With repeat autotrace from execute address
; With added unused space analysis 
;      includes find word tables (selected the 2 highest blocks)
;      includes find all words with preceding JPs or CALL  opcode value
;
; Followed by more unused space analysis for text
;      includes keyword table search
;      includes text search

; Followed by more unused space analysis for text
; Finally more unused space analysis for unused block start address link search


             ORG  01200H

                 XOR   A                    ;1200 AF                                                                           
                 LD    (L3D26),A            ;1201 32263D                                                                       
                 LD    (0FFFFH),A           ;1204 32FFFF                                                                       
                 LD    HL,043FFH            ;1207 21FF43                                                                       
                 LD    D,208                ;120A 16D0                                                                         
L120C:           INC   HL                   ;120C 23                                                                           
                 LD    A,H                  ;120D 7C                                                                           
                 CP    D                    ;120E BA                                                                           
                 JR    Z,L121B              ;120F 280A                                                                         
                 LD    A,255                ;1211 3EFF                                                                         
                 LD    (HL),A               ;1213 77                                                                           
                 SUB   (HL)                 ;1214 96                                                                           
                 JR    NZ,L121B             ;1215 2004                                                                         
                 LD    (HL),A               ;1217 77                                                                           
                 CP    (HL)                 ;1218 BE                                                                           
                 JR    Z,L120C              ;1219 28F1                                                                         
L121B:           LD    (04561H),HL          ;121B 226145                                                                       
                 LD    (04563H),HL          ;121E 226345                                                                       
                 LD    SP,HL                ;1221 F9                                                                           
                 CALL  CRLF2                ;1222 CD0600                                                                       
                 LD    DE,L12E2             ;1225 11E212                                                                       
                 CALL  MESSAGE              ;1228 CD1500                                                                       
                 CALL  L1832                ;122B CD3218                                                                       
                 LD    BC,L000A             ;122E 010A00                                                                       
                 CALL  L173F                ;1231 CD3F17                                                                       
                 LD    DE,L4400             ;1234 110044                                                                       
                 PUSH  DE                   ;1237 D5                                                                           
                 CALL  L16F7                ;1238 CDF716                                                                       
                 POP   DE                   ;123B D1                                                                           
                 CALL  L1357                ;123C CD5713                                                                       
                 LD    DE,L1326             ;123F 112613                                                                       
                 CALL  MESSAGE              ;1242 CD1500                                                                       
                 XOR   A                    ;1245 AF                                                                           
                 LD    D,A                  ;1246 57                                                                           
                 LD    E,A                  ;1247 5F                                                                           
                 CALL  SETCLOCK             ;1248 CD3300                                                                       
L124B:           LD    DE,L12FE             ;124B 11FE12                                                                       
                 CALL  MUSIC                ;124E CD3000                                                                       
                 LD    DE,L12F9             ;1251 11F912                                                                       
                 CALL  L1357                ;1254 CD5713                                                                       
L1257:           LD    A,(L4565)            ;1257 3A6545                                                                       
                 OR    A                    ;125A B7                                                                           
                 JP    Z,L1274              ;125B CA7412                                                                       
                 LD    HL,(L47FF)           ;125E 2AFF47                                                                       
                 LD    A,H                  ;1261 7C                                                                           
                 OR    L                    ;1262 B5                                                                           
                 JP    Z,L1278              ;1263 CA7812                                                                       
                 LD    BC,CRLF2             ;1266 010600                                                                       
                 LD    DE,L4566             ;1269 116645                                                                       
                 LD    HL,L47FD             ;126C 21FD47                                                                       
                 CALL  L1799                ;126F CD9917                                                                       
                 JR    L1278                ;1272 1804                                                                         

L1274:           LD    HL,(04563H)          ;1274 2A6345                                                                       
                 LD    SP,HL                ;1277 F9                                                                           
L1278:           CALL  L184E                ;1278 CD4E18                                                                       
                 CALL  CRLF                 ;127B CD0900                                                                       
                 LD    DE,L4400             ;127E 110044                                                                       
                 CALL  USER                 ;1281 CD0300                                                                       
                 CALL  L13CE                ;1284 CDCE13                                                                       
                 CALL  L1443                ;1287 CD4314                                                                       
                 LD    HL,(L4457)           ;128A 2A5744                                                                       
                 LD    A,L                  ;128D 7D                                                                           
                 OR    H                    ;128E B4                                                                           
                 JR    NZ,L12A0             ;128F 200F                                                                         
                 LD    HL,L4459             ;1291 215944                                                                       
                 LD    (L4801),HL           ;1294 220148                                                                       
                 CALL  L168B                ;1297 CD8B16                                                                       
                 DEC   C                    ;129A 0D                                                                           
                 POP   HL                   ;129B E1                                                                           
                 ADD   HL,DE                ;129C 19                                                                           
                 JP    L1278                ;129D C37812                                                                       

L12A0:           CALL  L1987                ;12A0 CD8719                                                                       
                 CALL  L13C1                ;12A3 CDC113                                                                       
                 CALL  L17A5                ;12A6 CDA517                                                                       
                 CP    (HL)                 ;12A9 BE                                                                           
                 LD    (DE),A               ;12AA 12                                                                           
                 JR    NZ,L12BE             ;12AB 2011                                                                         
                 CALL  L17E8                ;12AD CDE817                                                                       
                 EX    DE,HL                ;12B0 EB                                                                           
                 CALL  L1766                ;12B1 CD6617                                                                       
                 CALL  L1651                ;12B4 CD5116                                                                       
                 CALL  L189C                ;12B7 CD9C18                                                                       
                 EX    DE,HL                ;12BA EB                                                                           
                 CALL  L17E0                ;12BB CDE017                                                                       
L12BE:           LD    A,(L4459)            ;12BE 3A5944                                                                       
                 CP    13                   ;12C1 FE0D                                                                         
                 JP    Z,L1257              ;12C3 CA5712                                                                       
                 CALL  L17A8                ;12C6 CDA817                                                                       
                 RL    D                    ;12C9 CB12                                                                         
                 LD    (L4455),HL           ;12CB 225544                                                                       
                 EX    DE,HL                ;12CE EB                                                                           
                 LD    HL,L4455             ;12CF 215544                                                                       
                 CALL  L17E8                ;12D2 CDE817                                                                       
                 CALL  L1796                ;12D5 CD9617                                                                       
                 CALL  L189C                ;12D8 CD9C18                                                                       
                 EX    DE,HL                ;12DB EB                                                                           
                 CALL  L17E0                ;12DC CDE017                                                                       
                 JP    L1257                ;12DF C35712                                                                       

L12E2:           DB    " * SHARP BAS"       ;12E2 202A20534841525020424153                                                     
                 DB    "IC SP-5025"         ;12EE 49432053502D35303235                                                         
                 DB    0DH                  ;12F8 0D                                                                           
L12F9:           DB    "READY"              ;12F9 5245414459                                                                   
L12FE:           DB    0DH                  ;12FE 0D                                                                           
L12FF:           DB    " ERR"               ;12FF 20455252                                                                     
                 DB    4FH,52H,0DH          ;1303 4F520D                                                                       
L1306:           DB    " IN"                ;1306 20494E                                                                       
                 DB    0DH                  ;1309 0D                                                                           
L130A:           DB    "SYNTAX"             ;130A 53594E544158                                                                 
                 DB    0DH                  ;1310 0D                                                                           
L1311:           DB    "MEMORY"             ;1311 4D454D4F5259                                                                 
                 DB    0DH                  ;1317 0D                                                                           
L1318:           DB    "DATA"               ;1318 44415441                                                                     
                 DB    0DH                  ;131C 0D                                                                           
L131D:           DB    "MISMATCH"           ;131D 4D49534D41544348                                                             
                 DB    0DH                  ;1325 0D                                                                           
L1326:           DB    " BYTES"             ;1326 204259544553                                                                 
                 DB    0DH                  ;132C 0D                                                                           
L132D:           DB    "BREAK"              ;132D 425245414B                                                                   
                 DB    0DH                  ;1332 0D                                                                           
L1333:           DB    "16FOR"              ;1333 3136464F52                                                                   
                 DB    0DH                  ;1338 0D                                                                           
L1339:           DB    "16GOSUB"            ;1339 3136474F535542                                                               
                 DB    0DH                  ;1340 0D                                                                           
L1341:           DB    "6FN"                ;1341 36464E                                                                       
                 DB    0DH                  ;1344 0D                                                                           
L1345:           DB    "CONT"               ;1345 434F4E54                                                                     
                 DB    0DH                  ;1349 0D                                                                           
L134A:           DB    "FILE"               ;134A 46494C45                                                                     
                 DB    0DH                  ;134E 0D                                                                           
L134F:           DB    "OVERLAY"            ;134F 4F5645524C4159                                                               
                 DB    0DH                  ;1356 0D                                                                           
L1357:           CALL  CRLF                 ;1357 CD0900                                                                       
                 JP    MESSAGE              ;135A C31500                                                                       

L135D:           CALL  L187C                ;135D CD7C18                                                                       
                 CALL  L1357                ;1360 CD5713                                                                       
                 LD    DE,L12FF             ;1363 11FF12                                                                       
L1366:           CALL  MESSAGE              ;1366 CD1500                                                                       
                 LD    HL,(L47FF)           ;1369 2AFF47                                                                       
                 LD    A,L                  ;136C 7D                                                                           
                 OR    H                    ;136D B4                                                                           
                 JP    Z,L124B              ;136E CA4B12                                                                       
                 LD    DE,L4400             ;1371 110044                                                                       
                 PUSH  DE                   ;1374 D5                                                                           
                 CALL  L16F7                ;1375 CDF716                                                                       
                 LD    DE,L1306             ;1378 110613                                                                       
                 CALL  MESSAGE              ;137B CD1500                                                                       
                 POP   DE                   ;137E D1                                                                           
                 CALL  MESSAGE              ;137F CD1500                                                                       
                 JP    L124B                ;1382 C34B12                                                                       

L1385:           CALL  CRLF                 ;1385 CD0900                                                                       
                 LD    DE,L132D             ;1388 112D13                                                                       
                 JP    L1366                ;138B C36613                                                                       

L138E:           LD    DE,L130A             ;138E 110A13                                                                       
                 JR    L1396                ;1391 1803                                                                         

L1393:           LD    DE,L1311             ;1393 111113                                                                       
L1396:           JR    L139B                ;1396 1803                                                                         

L1398:           LD    DE,L1318             ;1398 111813                                                                       
L139B:           JR    L13A0                ;139B 1803                                                                         

L139D:           LD    DE,L131D             ;139D 111D13                                                                       
L13A0:           JR    L13A5                ;13A0 1803                                                                         

L13A2:           LD    DE,L1333             ;13A2 113313                                                                       
L13A5:           JR    L13AA                ;13A5 1803                                                                         

L13A7:           LD    DE,L1339             ;13A7 113913                                                                       
L13AA:           JR    L13AF                ;13AA 1803                                                                         

L13AC:           LD    DE,L1341             ;13AC 114113                                                                       
L13AF:           JR    L13B4                ;13AF 1803                                                                         

L13B1:           LD    DE,L134A             ;13B1 114A13                                                                       
L13B4:           JR    L13B9                ;13B4 1803                                                                         

L13B6:           LD    DE,L134F             ;13B6 114F13                                                                       
L13B9:           JR    L13BE                ;13B9 1803                                                                         

L13BB:           LD    DE,L1345             ;13BB 114513                                                                       
L13BE:           JP    L135D                ;13BE C35D13                                                                       

L13C1:           XOR   A                    ;13C1 AF                                                                           
                 JR    L13C6                ;13C2 1802                                                                         

L13C4:           LD    A,1                  ;13C4 3E01                                                                         
L13C6:           JR    L13CA                ;13C6 1802                                                                         

L13C8:           LD    A,2                  ;13C8 3E02                                                                         
L13CA:           LD    (L4565),A            ;13CA 326545                                                                       
                 RET                        ;13CD C9                                                                           

L13CE:           LD    HL,L4400             ;13CE 210044                                                                       
                 CALL  L16F1                ;13D1 CDF116                                                                       
                 EX    DE,HL                ;13D4 EB                                                                           
                 LD    (L4457),HL           ;13D5 225744                                                                       
                 LD    HL,L4459             ;13D8 215944                                                                       
                 LD    C,0                  ;13DB 0E00                                                                         
                 EX    DE,HL                ;13DD EB                                                                           
                 CALL  L162D                ;13DE CD2D16                                                                       
L13E1:           CALL  L1491                ;13E1 CD9114                                                                       
                 RET   Z                    ;13E4 C8                                                                           
                 DEC   DE                   ;13E5 1B                                                                           
                 CP    63                   ;13E6 FE3F                                                                         
                 JR    NZ,L13F0             ;13E8 2006                                                                         
                 LD    A,133                ;13EA 3E85                                                                         
                 LD    (DE),A               ;13EC 12                                                                           
                 INC   DE                   ;13ED 13                                                                           
                 JR    L13E1                ;13EE 18F1                                                                         

L13F0:           DEC   HL                   ;13F0 2B                                                                           
                 EX    DE,HL                ;13F1 EB                                                                           
                 PUSH  HL                   ;13F2 E5                                                                           
                 LD    HL,L14D8             ;13F3 21D814                                                                       
                 LD    B,128                ;13F6 0680                                                                         
L13F8:           PUSH  DE                   ;13F8 D5                                                                           
L13F9:           CALL  L162D                ;13F9 CD2D16                                                                       
                 EX    DE,HL                ;13FC EB                                                                           
                 CALL  L162D                ;13FD CD2D16                                                                       
                 EX    DE,HL                ;1400 EB                                                                           
                 CP    (HL)                 ;1401 BE                                                                           
                 INC   HL                   ;1402 23                                                                           
                 INC   DE                   ;1403 13                                                                           
                 JR    Z,L13F9              ;1404 28F3                                                                         
                 DEC   HL                   ;1406 2B                                                                           
                 CP    255                  ;1407 FEFF                                                                         
                 JP    Z,L1415              ;1409 CA1514                                                                       
                 ADD   A,128                ;140C C680                                                                         
                 JP    C,L138E              ;140E DA8E13                                                                       
                 CP    (HL)                 ;1411 BE                                                                           
                 JP    Z,L1427              ;1412 CA2714                                                                       
L1415:           INC   B                    ;1415 04                                                                           
                 LD    A,220                ;1416 3EDC                                                                         
                 CP    B                    ;1418 B8                                                                           
                 JP    Z,L143B              ;1419 CA3B14                                                                       
                 LD    A,127                ;141C 3E7F                                                                         
L141E:           CP    (HL)                 ;141E BE                                                                           
                 INC   HL                   ;141F 23                                                                           
                 JP    NC,L141E             ;1420 D21E14                                                                       
                 POP   DE                   ;1423 D1                                                                           
                 JP    L13F8                ;1424 C3F813                                                                       

L1427:           POP   AF                   ;1427 F1                                                                           
                 POP   HL                   ;1428 E1                                                                           
                 LD    (HL),B               ;1429 70                                                                           
                 INC   HL                   ;142A 23                                                                           
                 EX    DE,HL                ;142B EB                                                                           
                 LD    A,B                  ;142C 78                                                                           
                 CP    130                  ;142D FE82                                                                         
                 JP    NC,L13E1             ;142F D2E113                                                                       
                 CALL  L14C5                ;1432 CDC514                                                                       
                 CP    58                   ;1435 FE3A                                                                         
                 JP    Z,L13E1              ;1437 CAE113                                                                       
                 RET                        ;143A C9                                                                           

L143B:           POP   DE                   ;143B D1                                                                           
                 POP   HL                   ;143C E1                                                                           
                 INC   DE                   ;143D 13                                                                           
                 INC   HL                   ;143E 23                                                                           
                 EX    DE,HL                ;143F EB                                                                           
                 JP    L13E1                ;1440 C3E113                                                                       

L1443:           LD    HL,(L4457)           ;1443 2A5744                                                                       
                 LD    DE,L4400             ;1446 110044                                                                       
                 LD    C,178                ;1449 0EB2                                                                         
                 CALL  L16F9                ;144B CDF916                                                                       
                 LD    A,32                 ;144E 3E20                                                                         
                 LD    (DE),A               ;1450 12                                                                           
                 INC   DE                   ;1451 13                                                                           
                 LD    HL,L4459             ;1452 215944                                                                       
L1455:           CALL  L1491                ;1455 CD9114                                                                       
                 RET   Z                    ;1458 C8                                                                           
                 SUB   128                  ;1459 D680                                                                         
                 JP    M,L1455              ;145B FA5514                                                                       
                 DEC   C                    ;145E 0D                                                                           
                 PUSH  AF                   ;145F F5                                                                           
                 DEC   DE                   ;1460 1B                                                                           
                 PUSH  HL                   ;1461 E5                                                                           
                 LD    HL,L14D8             ;1462 21D814                                                                       
L1465:           OR    A                    ;1465 B7                                                                           
                 JP    Z,L1475              ;1466 CA7514                                                                       
                 PUSH  AF                   ;1469 F5                                                                           
                 LD    A,127                ;146A 3E7F                                                                         
L146C:           CP    (HL)                 ;146C BE                                                                           
                 INC   HL                   ;146D 23                                                                           
                 JR    NC,L146C             ;146E 30FC                                                                         
                 POP   AF                   ;1470 F1                                                                           
                 DEC   A                    ;1471 3D                                                                           
                 JP    L1465                ;1472 C36514                                                                       

L1475:           CALL  L14BA                ;1475 CDBA14                                                                       
                 OR    A                    ;1478 B7                                                                           
                 JP    P,L1475              ;1479 F27514                                                                       
                 DEC   DE                   ;147C 1B                                                                           
                 AND   127                  ;147D E67F                                                                         
                 LD    (DE),A               ;147F 12                                                                           
                 INC   DE                   ;1480 13                                                                           
                 POP   HL                   ;1481 E1                                                                           
                 POP   AF                   ;1482 F1                                                                           
                 CP    2                    ;1483 FE02                                                                         
                 JP    NC,L1455             ;1485 D25514                                                                       
                 CALL  L14C5                ;1488 CDC514                                                                       
                 CP    58                   ;148B FE3A                                                                         
                 JP    Z,L1455              ;148D CA5514                                                                       
                 RET                        ;1490 C9                                                                           

L1491:           CALL  L14BA                ;1491 CDBA14                                                                       
                 RET   Z                    ;1494 C8                                                                           
                 CALL  L14A5                ;1495 CDA514                                                                       
                 JR    Z,L1491              ;1498 28F7                                                                         
                 CP    34                   ;149A FE22                                                                         
                 RET   NZ                   ;149C C0                                                                           
                 CALL  L14B1                ;149D CDB114                                                                       
                 CP    13                   ;14A0 FE0D                                                                         
                 JR    NZ,L1491             ;14A2 20ED                                                                         
                 RET                        ;14A4 C9                                                                           

L14A5:           CP    32                   ;14A5 FE20                                                                         
                 RET   Z                    ;14A7 C8                                                                           
                 CP    255                  ;14A8 FEFF                                                                         
                 RET   Z                    ;14AA C8                                                                           
                 CP    40                   ;14AB FE28                                                                         
                 RET   Z                    ;14AD C8                                                                           
                 CP    41                   ;14AE FE29                                                                         
                 RET                        ;14B0 C9                                                                           

L14B1:           CALL  L14BA                ;14B1 CDBA14                                                                       
                 RET   Z                    ;14B4 C8                                                                           
                 CP    34                   ;14B5 FE22                                                                         
                 JR    NZ,L14B1             ;14B7 20F8                                                                         
                 RET                        ;14B9 C9                                                                           

L14BA:           LD    A,(HL)               ;14BA 7E                                                                           
                 LD    (DE),A               ;14BB 12                                                                           
                 INC   HL                   ;14BC 23                                                                           
                 INC   DE                   ;14BD 13                                                                           
                 INC   C                    ;14BE 0C                                                                           
                 JP    Z,L1398              ;14BF CA9813                                                                       
                 CP    13                   ;14C2 FE0D                                                                         
                 RET                        ;14C4 C9                                                                           

L14C5:           CALL  L14BA                ;14C5 CDBA14                                                                       
                 RET   Z                    ;14C8 C8                                                                           
                 CP    58                   ;14C9 FE3A                                                                         
                 RET   Z                    ;14CB C8                                                                           
                 CP    34                   ;14CC FE22                                                                         
                 JR    NZ,L14C5             ;14CE 20F5                                                                         
                 CALL  L14B1                ;14D0 CDB114                                                                       
                 CP    13                   ;14D3 FE0D                                                                         
                 JR    NZ,L14C5             ;14D5 20EE                                                                         
                 RET                        ;14D7 C9                                                                           

L14D8:           DB    "RE"                 ;14D8 5245                                                                         
                 DB    BRC                  ;14DA CD                                                                           
                 DB    "DAT"                ;14DB 444154                                                                       
                 DB    0C1H                 ;14DE C1                                                                           
                 DB    "LIS"                ;14DF 4C4953                                                                       
                 DB    0D4H                 ;14E2 D4                                                                           
                 DB    "RU"                 ;14E3 5255                                                                         
                 DB    TLC                  ;14E5 CE                                                                           
                 DB    "NE"                 ;14E6 4E45                                                                         
                 DB    0D7H                 ;14E8 D7                                                                           
                 DB    "PRIN"               ;14E9 5052494E                                                                     
                 DB    0D4H                 ;14ED D4                                                                           
                 DB    "LE"                 ;14EE 4C45                                                                         
                 DB    0D4H                 ;14F0 D4                                                                           
                 DB    "FO"                 ;14F1 464F                                                                         
                 DB    TCT                  ;14F3 D2                                                                           
                 DB    "I"                  ;14F4 49                                                                           
                 DB    0C6H                 ;14F5 C6                                                                           
                 DB    "GOT"                ;14F6 474F54                                                                       
                 DB    0CFH                 ;14F9 CF                                                                           
                 DB    "REA"                ;14FA 524541                                                                       
                 DB    0C4H                 ;14FD C4                                                                           
                 DB    "GOSU"               ;14FE 474F5355                                                                     
                 DB    0C2H                 ;1502 C2                                                                           
                 DB    "RETUR"              ;1503 5245545552                                                                   
                 DB    TLC                  ;1508 CE                                                                           
                 DB    "NEX"                ;1509 4E4558                                                                       
                 DB    0D4H                 ;150C D4                                                                           
                 DB    "STO"                ;150D 53544F                                                                       
                 DB    TRC                  ;1510 D0                                                                           
                 DB    "EN"                 ;1511 454E                                                                         
                 DB    0C4H                 ;1513 C4                                                                           
                 DB    "O"                  ;1514 4F                                                                           
                 DB    TLC                  ;1515 CE                                                                           
                 DB    "LOA"                ;1516 4C4F41                                                                       
                 DB    0C4H                 ;1519 C4                                                                           
                 DB    "SAV"                ;151A 534156                                                                       
                 DB    0C5H                 ;151D C5                                                                           
                 DB    "VERIF"              ;151E 5645524946                                                                   
                 DB    0D9H                 ;1523 D9                                                                           
                 DB    "POK"                ;1524 504F4B                                                                       
                 DB    0C5H                 ;1527 C5                                                                           
                 DB    "DI"                 ;1528 4449                                                                         
                 DB    BRC                  ;152A CD                                                                           
                 DB    "DEF F"              ;152B 4445462046                                                                   
                 DB    TLC                  ;1530 CE                                                                           
                 DB    "INPU"               ;1531 494E5055                                                                     
                 DB    0D4H                 ;1535 D4                                                                           
                 DB    "RESTOR"             ;1536 524553544F52                                                                 
                 DB    0C5H                 ;153C C5                                                                           
                 DB    "CL"                 ;153D 434C                                                                         
                 DB    TCT                  ;153F D2                                                                           
                 DB    "MUSI"               ;1540 4D555349                                                                     
                 DB    0C3H                 ;1544 C3                                                                           
                 DB    "TEMP"               ;1545 54454D50                                                                     
                 DB    0CFH                 ;1549 CF                                                                           
                 DB    "USR"                ;154A 555352                                                                       
                 DB    0A8H                 ;154D A8                                                                           
                 DB    "WOPE"               ;154E 574F5045                                                                     
                 DB    TLC                  ;1552 CE                                                                           
                 DB    "ROPE"               ;1553 524F5045                                                                     
                 DB    TLC                  ;1557 CE                                                                           
                 DB    "CLOS"               ;1558 434C4F53                                                                     
                 DB    0C5H                 ;155C C5                                                                           
                 DB    "BY"                 ;155D 4259                                                                         
                 DB    0C5H                 ;155F C5                                                                           
                 DB    "LIMI"               ;1560 4C494D49                                                                     
                 DB    0D4H                 ;1564 D4                                                                           
                 DB    "CON"                ;1565 434F4E                                                                       
                 DB    0D4H                 ;1568 D4                                                                           
                 DB    "SE"                 ;1569 5345                                                                         
                 DB    0D4H                 ;156B D4                                                                           
                 DB    "RESE"               ;156C 52455345                                                                     
                 DB    0D4H                 ;1570 D4                                                                           
                 DB    "GE"                 ;1571 4745                                                                         
                 DB    0D4H                 ;1573 D4                                                                           
                 DB    "INP"                ;1574 494E50                                                                       
                 DB    0A3H                 ;1577 A3                                                                           
                 DB    "OUT"                ;1578 4F5554                                                                       
                 DB    0A3H,0FFH,0FFH,0FFH  ;157B A3FFFFFF                                                                     
                 DB    0FFH,0FFH            ;157F FFFF                                                                         
                 DB    "THE"                ;1581 544845                                                                       
                 DB    TLC                  ;1584 CE                                                                           
                 DB    "T"                  ;1585 54                                                                           
                 DB    0CFH                 ;1586 CF                                                                           
                 DB    "STE"                ;1587 535445                                                                       
                 DB    TRC                  ;158A D0                                                                           
                 DB    ">"                  ;158B 3E                                                                           
                 DB    0BCH                 ;158C BC                                                                           
                 DB    "<"                  ;158D 3C                                                                           
                 DB    0BEH                 ;158E BE                                                                           
                 DB    "="                  ;158F 3D                                                                           
                 DB    0BCH                 ;1590 BC                                                                           
                 DB    "<"                  ;1591 3C                                                                           
                 DB    0BDH                 ;1592 BD                                                                           
                 DB    "="                  ;1593 3D                                                                           
                 DB    0BEH                 ;1594 BE                                                                           
                 DB    ">"                  ;1595 3E                                                                           
                 DB    0BDH,0BDH,0BEH,0BCH  ;1596 BDBDBEBC                                                                     
                 DB    "AN"                 ;159A 414E                                                                         
                 DB    0C4H                 ;159C C4                                                                           
                 DB    "O"                  ;159D 4F                                                                           
                 DB    TCT                  ;159E D2                                                                           
                 DB    "NO"                 ;159F 4E4F                                                                         
                 DB    0D4H,0ABH,0ADH,0AAH  ;15A1 D4ABADAA                                                                     
                 DB    0AFH                 ;15A5 AF                                                                           
                 DB    "LEFT$"              ;15A6 4C45465424                                                                   
                 DB    0A8H                 ;15AB A8                                                                           
                 DB    "RIGHT$"             ;15AC 524947485424                                                                 
                 DB    0A8H                 ;15B2 A8                                                                           
                 DB    "MID$"               ;15B3 4D494424                                                                     
                 DB    0A8H                 ;15B7 A8                                                                           
                 DB    "LEN"                ;15B8 4C454E                                                                       
                 DB    0A8H                 ;15BB A8                                                                           
                 DB    "CHR$"               ;15BC 43485224                                                                     
                 DB    0A8H                 ;15C0 A8                                                                           
                 DB    "STR$"               ;15C1 53545224                                                                     
                 DB    0A8H                 ;15C5 A8                                                                           
                 DB    "ASC"                ;15C6 415343                                                                       
                 DB    0A8H                 ;15C9 A8                                                                           
                 DB    "VAL"                ;15CA 56414C                                                                       
                 DB    0A8H                 ;15CD A8                                                                           
                 DB    "PEEK"               ;15CE 5045454B                                                                     
                 DB    0A8H                 ;15D2 A8                                                                           
                 DB    "TAB"                ;15D3 544142                                                                       
                 DB    0A8H                 ;15D6 A8                                                                           
                 DB    "SPC"                ;15D7 535043                                                                       
                 DB    0A8H                 ;15DA A8                                                                           
                 DB    "SIZ"                ;15DB 53495A                                                                       
                 DB    0C5H,0FFH,0FFH,0FFH  ;15DE C5FFFFFF                                                                     
                 DB    0DEH                 ;15E2 DE                                                                           
                 DB    "RND"                ;15E3 524E44                                                                       
                 DB    0A8H                 ;15E6 A8                                                                           
                 DB    "SIN"                ;15E7 53494E                                                                       
                 DB    0A8H                 ;15EA A8                                                                           
                 DB    "COS"                ;15EB 434F53                                                                       
                 DB    0A8H                 ;15EE A8                                                                           
                 DB    "TAN"                ;15EF 54414E                                                                       
                 DB    0A8H                 ;15F2 A8                                                                           
                 DB    "ATN"                ;15F3 41544E                                                                       
                 DB    0A8H                 ;15F6 A8                                                                           
                 DB    "EXP"                ;15F7 455850                                                                       
                 DB    0A8H                 ;15FA A8                                                                           
                 DB    "INT"                ;15FB 494E54                                                                       
                 DB    0A8H                 ;15FE A8                                                                           
                 DB    "LOG"                ;15FF 4C4F47                                                                       
                 DB    0A8H                 ;1602 A8                                                                           
                 DB    "LN"                 ;1603 4C4E                                                                         
                 DB    0A8H                 ;1605 A8                                                                           
                 DB    "ABS"                ;1606 414253                                                                       
                 DB    0A8H                 ;1609 A8                                                                           
                 DB    "SGN"                ;160A 53474E                                                                       
                 DB    0A8H                 ;160D A8                                                                           
                 DB    "SQR"                ;160E 535152                                                                       
                 DB    0A8H,0FFH,0FFH       ;1611 A8FFFF                                                                       
L1614:           DB    0C1H,00H,00H,00H     ;1614 C1000000                                                                     
                 DB    80H                  ;1618 80                                                                           
L1619:           DB    80H,00H,00H,00H      ;1619 80000000                                                                     
                 DB    00H                  ;161D 00                                                                           
L161E:           DB    "A"                  ;161E 41                                                                           
                 DB    00H,00H,00H,80H      ;161F 00000080                                                                     
L1623:           DB    0C2H,0A1H,0DAH,0FH   ;1623 C2A1DA0F                                                                     
                 DB    0C9H                 ;1627 C9                                                                           
                 DB    "*"                  ;1628 2A                                                                           
                 DB    01H                  ;1629 01                                                                           
                 DB    "H+"                 ;162A 482B                                                                         
L162C:           DB    "#"                  ;162C 23                                                                           
L162D:           DB    "~"                  ;162D 7E                                                                           
                 DB    0FEH                 ;162E FE                                                                           
                 DB    " "                  ;162F 20                                                                           
                 DB    0C0H,18H,0F9H        ;1630 C018F9                                                                       
L1633:           DB    0F5H                 ;1633 F5                                                                           
                 DB    ">"                  ;1634 3E                                                                           
                 DB    0DH                  ;1635 0D                                                                           
L1636:           DB    0BEH                 ;1636 BE                                                                           
                 DB    "# "                 ;1637 2320                                                                         
                 DB    0FCH,0F1H,0C9H       ;1639 FCF1C9                                                                       
L163C:           DB    "#"                  ;163C 23                                                                           
L163D:           DB    BRC                  ;163D CD                                                                           
                 DB    ")"                  ;163E 29                                                                           
                 DB    18H,0C8H,0FEH,22H    ;163F 18C8FE22                                                                     
                 DB    " "                  ;1643 20                                                                           
                 DB    0F7H                 ;1644 F7                                                                           
L1645:           DB    BRC                  ;1645 CD                                                                           
                 DB    ","                  ;1646 2C                                                                           
                 DB    16H,0FEH             ;1647 16FE                                                                         
                 DB    0DH                  ;1649 0D                                                                           
                 DB    0C8H,0FEH,22H        ;164A C8FE22                                                                       
                 DB    " "                  ;164D 20                                                                           
                 DB    0F6H,18H,0EBH        ;164E F618EB                                                                       
L1651:           DB    "y/Ox/G"             ;1651 792F4F782F47                                                                 
                 DB    03H,0C9H             ;1657 03C9                                                                         
L1659:           DB    BRC                  ;1659 CD                                                                           
                 DB    "-"                  ;165A 2D                                                                           
                 DB    CSN,0D6H             ;165B 16D6                                                                         
                 DB    "0"                  ;165D 30                                                                           
                 DB    0FEH,0AH             ;165E FE0A                                                                         
                 DB    "~"                  ;1660 7E                                                                           
                 DB    0C9H                 ;1661 C9                                                                           
L1662:           DB    "|"                  ;1662 7C                                                                           
                 DB    92H,0C0H             ;1663 92C0                                                                         
                 DB    "}"                  ;1665 7D                                                                           
                 DB    93H,0C9H             ;1666 93C9                                                                         
L1668:           DB    "{"                  ;1668 7B                                                                           
                 DB    95H                  ;1669 95                                                                           
                 DB    "oz"                 ;166A 6F7A                                                                         
                 DB    9CH                  ;166C 9C                                                                           
                 DB    "g"                  ;166D 67                                                                           
                 DB    0C9H                 ;166E C9                                                                           
L166F:           DB    0E1H                 ;166F E1                                                                           
L1670:           DB    0E3H                 ;1670 E3                                                                           
L1671:           DB    0F5H                 ;1671 F5                                                                           
                 DB    "~#fo"               ;1672 7E23666F                                                                     
                 DB    0F1H,0E3H,0C9H       ;1676 F1E3C9                                                                       
L1679:           DB    0E1H                 ;1679 E1                                                                           
L167A:           DB    0E3H                 ;167A E3                                                                           
                 DB    "##"                 ;167B 2323                                                                         
                 DB    0E3H,0C9H            ;167D E3C9                                                                         
L167F:           DB    "*DF#####"           ;167F 2A44462323232323                                                             
                 DB    0C9H                 ;1687 C9                                                                           
L1688:           DB    "*"                  ;1688 2A                                                                           
                 DB    01H                  ;1689 01                                                                           
                 DB    "H"                  ;168A 48                                                                           
L168B:           DB    BRC                  ;168B CD                                                                           
                 DB    "-"                  ;168C 2D                                                                           
                 DB    CSN,0E3H,0BEH        ;168D 16E3BE                                                                       
                 DB    "#"                  ;1690 23                                                                           
                 DB    0C2H                 ;1691 C2                                                                           
                 DB    "q"                  ;1692 71                                                                           
                 DB    CSN                  ;1693 16                                                                           
                 DB    "#"                  ;1694 23                                                                           
                 DB    18H,0BH              ;1695 180B                                                                         
L1697:           DB    "*"                  ;1697 2A                                                                           
                 DB    01H                  ;1698 01                                                                           
                 DB    "H"                  ;1699 48                                                                           
L169A:           DB    BRC                  ;169A CD                                                                           
                 DB    "-"                  ;169B 2D                                                                           
                 DB    CSN,0E3H,0BEH,0C2H   ;169C 16E3BEC2                                                                     
                 DB    8EH,CMR              ;16A0 8E13                                                                         
L16A2:           DB    "#"                  ;16A2 23                                                                           
                 DB    0E3H,0C3H            ;16A3 E3C3                                                                         
                 DB    ","                  ;16A5 2C                                                                           
                 DB    CSN                  ;16A6 16                                                                           
L16A7:           DB    0AFH,0BCH            ;16A7 AFBC                                                                         
                 DB    "("                  ;16A9 28                                                                           
                 DB    05H,0EBH,0BCH,0C2H   ;16AA 05EBBCC2                                                                     
                 DB    "p"                  ;16AE 70                                                                           
                 DB    CSN                  ;16AF 16                                                                           
L16B0:           DB    "}l"                 ;16B0 7D6C                                                                         
L16B2:           DB    0B7H                 ;16B2 B7                                                                           
                 DB    " "                  ;16B3 20                                                                           
                 DB    04H,0EBH,0C3H        ;16B4 04EBC3                                                                       
                 DB    "z"                  ;16B7 7A                                                                           
                 DB    CSN                  ;16B8 16                                                                           
L16B9:           DB    LCT                  ;16B9 CB                                                                           
                 DB    "?0"                 ;16BA 3F30                                                                         
                 DB    04H,19H,0DAH         ;16BC 0419DA                                                                       
                 DB    "p"                  ;16BF 70                                                                           
                 DB    CSN                  ;16C0 16                                                                           
L16C1:           DB    LCT                  ;16C1 CB                                                                           
                 DB    "#"                  ;16C2 23                                                                           
                 DB    LCT,CMU,0C3H,0B2H    ;16C3 CB12C3B2                                                                     
                 DB    CSN                  ;16C7 16                                                                           
L16C8:           DB    BRC,0A7H,CSN,98H     ;16C8 CDA71698                                                                     
                 DB    CMR,0C9H             ;16CC 13C9                                                                         
L16CE:           DB    CMD,00H,00H          ;16CE 110000                                                                       
L16D1:           DB    BRC                  ;16D1 CD                                                                           
                 DB    "Y"                  ;16D2 59                                                                           
                 DB    CSN,TCT              ;16D3 16D2                                                                         
                 DB    "z"                  ;16D5 7A                                                                           
                 DB    CSN,0E5H             ;16D6 16E5                                                                         
                 DB    "!"                  ;16D8 21                                                                           
                 DB    0AH,00H,BRC,0A7H     ;16D9 0A00CDA7                                                                     
                 DB    CSN                  ;16DD 16                                                                           
                 DB    "o"                  ;16DE 6F                                                                           
                 DB    CSN,0E1H             ;16DF 16E1                                                                         
                 DB    "~"                  ;16E1 7E                                                                           
                 DB    0E6H,0FH,83H         ;16E2 E60F83                                                                       
                 DB    "_z"                 ;16E5 5F7A                                                                         
                 DB    TLC,00H              ;16E7 CE00                                                                         
                 DB    "W"                  ;16E9 57                                                                           
                 DB    0DAH                 ;16EA DA                                                                           
                 DB    "p"                  ;16EB 70                                                                           
                 DB    CSN                  ;16EC 16                                                                           
                 DB    "#"                  ;16ED 23                                                                           
                 DB    0C3H,BCT,CSN         ;16EE C3D116                                                                       
L16F1:           DB    BRC,TLC,CSN,8EH      ;16F1 CDCE168E                                                                     
                 DB    CMR,0C9H             ;16F5 13C9                                                                         
L16F7:           DB    0EH,00H              ;16F7 0E00                                                                         
L16F9:           DB    "> "                 ;16F9 3E20                                                                         
                 DB    CMU,CMR,0D5H,06H     ;16FB 1213D506                                                                     
                 DB    00H,CMD,10H          ;16FF 001110                                                                       
                 DB    "'"                  ;1702 27                                                                           
                 DB    BRC,22H,17H,CMD      ;1703 CD221711                                                                     
                 DB    0E8H,03H,BRC,22H     ;1707 E803CD22                                                                     
                 DB    17H,CMD              ;170B 1711                                                                         
                 DB    "d"                  ;170D 64                                                                           
                 DB    00H,BRC,22H,17H      ;170E 00CD2217                                                                     
                 DB    CMD,0AH,00H,BRC      ;1712 110A00CD                                                                     
                 DB    22H,17H              ;1716 2217                                                                         
                 DB    "}"                  ;1718 7D                                                                           
                 DB    BCT,0F6H             ;1719 D1F6                                                                         
                 DB    "0"                  ;171B 30                                                                           
                 DB    CMU,CMR              ;171C 1213                                                                         
                 DB    ">"                  ;171E 3E                                                                           
                 DB    0DH                  ;171F 0D                                                                           
                 DB    CMU,0C9H             ;1720 12C9                                                                         
L1722:           DB    ">"                  ;1722 3E                                                                           
                 DB    0FFH                 ;1723 FF                                                                           
L1724:           DB    "<"                  ;1724 3C                                                                           
                 DB    0B7H,0EDH            ;1725 B7ED                                                                         
                 DB    "R0"                 ;1727 5230                                                                         
                 DB    0FAH,19H,0B7H        ;1729 FA19B7                                                                       
                 DB    " "                  ;172C 20                                                                           
                 DB    03H,0B0H,0C8H,0AFH   ;172D 03B0C8AF                                                                     
L1731:           DB    04H,0F6H             ;1731 04F6                                                                         
                 DB    "0"                  ;1733 30                                                                           
                 DB    BCT,0E3H             ;1734 D1E3                                                                         
                 DB    "w#"                 ;1736 7723                                                                         
                 DB    0E3H,0D5H,0CH,0C9H   ;1738 E3D50CC9                                                                     
L173C:           DB    01H,00H,00H          ;173C 010000                                                                       
L173F:           DB    "*DF"                ;173F 2A4446                                                                       
L1742:           DB    09H,0DAH,93H,CMR     ;1742 09DA9313                                                                     
                 DB    0EBH                 ;1746 EB                                                                           
                 DB    "!"                  ;1747 21                                                                           
                 DB    9CH,0FFH             ;1748 9CFF                                                                         
                 DB    "9"                  ;174A 39                                                                           
                 DB    0AFH,0EDH            ;174B AFED                                                                         
                 DB    "R"                  ;174D 52                                                                           
                 DB    TRC,0C3H,93H,CMR     ;174E D0C39313                                                                     
L1752:           PUSH  HL                   ;1752 E5                                                                           
                 PUSH  DE                   ;1753 D5                                                                           
                 CALL  L173F                ;1754 CD3F17                                                                       
                 POP   DE                   ;1757 D1                                                                           
                 POP   HL                   ;1758 E1                                                                           
                 RET                        ;1759 C9                                                                           

L175A:           LD    E,(HL)               ;175A 5E                                                                           
                 INC   HL                   ;175B 23                                                                           
                 LD    D,(HL)               ;175C 56                                                                           
                 INC   HL                   ;175D 23                                                                           
                 LD    A,(HL)               ;175E 7E                                                                           
                 INC   HL                   ;175F 23                                                                           
                 LD    H,(HL)               ;1760 66                                                                           
                 LD    L,A                  ;1761 6F                                                                           
                 EX    DE,HL                ;1762 EB                                                                           
                 LD    A,L                  ;1763 7D                                                                           
                 OR    H                    ;1764 B4                                                                           
                 RET                        ;1765 C9                                                                           

L1766:           PUSH  BC                   ;1766 C5                                                                           
                 PUSH  HL                   ;1767 E5                                                                           
                 PUSH  DE                   ;1768 D5                                                                           
                 EX    DE,HL                ;1769 EB                                                                           
                 ADD   HL,BC                ;176A 09                                                                           
                 EX    DE,HL                ;176B EB                                                                           
                 CALL  L167F                ;176C CD7F16                                                                       
                 LD    A,L                  ;176F 7D                                                                           
                 SUB   E                    ;1770 93                                                                           
                 LD    C,A                  ;1771 4F                                                                           
                 LD    A,H                  ;1772 7C                                                                           
                 SBC   A,D                  ;1773 9A                                                                           
                 LD    B,A                  ;1774 47                                                                           
                 INC   BC                   ;1775 03                                                                           
                 POP   HL                   ;1776 E1                                                                           
                 PUSH  HL                   ;1777 E5                                                                           
                 EX    DE,HL                ;1778 EB                                                                           
                 JP    L179C                ;1779 C39C17                                                                       

L177C:           CALL  L1752                ;177C CD5217                                                                       
                 PUSH  BC                   ;177F C5                                                                           
                 PUSH  HL                   ;1780 E5                                                                           
                 PUSH  DE                   ;1781 D5                                                                           
                 CALL  L167F                ;1782 CD7F16                                                                       
                 PUSH  HL                   ;1785 E5                                                                           
                 ADD   HL,BC                ;1786 09                                                                           
                 EX    (SP),HL              ;1787 E3                                                                           
                 LD    A,L                  ;1788 7D                                                                           
                 SUB   E                    ;1789 93                                                                           
                 LD    C,A                  ;178A 4F                                                                           
                 LD    A,H                  ;178B 7C                                                                           
                 SBC   A,D                  ;178C 9A                                                                           
                 LD    B,A                  ;178D 47                                                                           
                 INC   BC                   ;178E 03                                                                           
                 POP   DE                   ;178F D1                                                                           
                 LDDR                       ;1790 EDB8                                                                         
L1792:           POP   DE                   ;1792 D1                                                                           
                 POP   HL                   ;1793 E1                                                                           
                 POP   BC                   ;1794 C1                                                                           
                 RET                        ;1795 C9                                                                           

L1796:           CALL  L177C                ;1796 CD7C17                                                                       
L1799:           PUSH  BC                   ;1799 C5                                                                           
                 PUSH  HL                   ;179A E5                                                                           
                 PUSH  DE                   ;179B D5                                                                           
L179C:           LD    A,C                  ;179C 79                                                                           
                 OR    B                    ;179D B0                                                                           
                 JR    Z,L17A2              ;179E 2802                                                                         
                 LDIR                       ;17A0 EDB0                                                                         
L17A2:           JP    L1792                ;17A2 C39217                                                                       

L17A5:           LD    (L462E),HL           ;17A5 222E46                                                                       
L17A8:           LD    HL,L4806             ;17A8 210648                                                                       
L17AB:           PUSH  HL                   ;17AB E5                                                                           
                 CALL  L175A                ;17AC CD5A17                                                                       
                 JP    Z,L166F              ;17AF CA6F16                                                                       
                 PUSH  HL                   ;17B2 E5                                                                           
                 LD    HL,(L462E)           ;17B3 2A2E46                                                                       
                 CALL  L1662                ;17B6 CD6216                                                                       
                 POP   HL                   ;17B9 E1                                                                           
                 JP    Z,L1679              ;17BA CA7916                                                                       
                 JP    C,L1679              ;17BD DA7916                                                                       
                 POP   AF                   ;17C0 F1                                                                           
                 JP    L17AB                ;17C1 C3AB17                                                                       

L17C4:           PUSH  HL                   ;17C4 E5                                                                           
                 LD    E,(HL)               ;17C5 5E                                                                           
                 INC   HL                   ;17C6 23                                                                           
                 LD    D,(HL)               ;17C7 56                                                                           
                 LD    A,E                  ;17C8 7B                                                                           
                 OR    D                    ;17C9 B2                                                                           
                 JP    Z,L166F              ;17CA CA6F16                                                                       
                 LD    HL,(L4630)           ;17CD 2A3046                                                                       
                 CALL  L1662                ;17D0 CD6216                                                                       
                 POP   HL                   ;17D3 E1                                                                           
                 INC   HL                   ;17D4 23                                                                           
                 INC   HL                   ;17D5 23                                                                           
                 JP    L167A                ;17D6 C37A16                                                                       

L17D9:           ADD   HL,BC                ;17D9 09                                                                           
                 EX    DE,HL                ;17DA EB                                                                           
                 POP   HL                   ;17DB E1                                                                           
                 LD    (HL),E               ;17DC 73                                                                           
                 INC   HL                   ;17DD 23                                                                           
                 LD    (HL),D               ;17DE 72                                                                           
                 EX    DE,HL                ;17DF EB                                                                           
L17E0:           PUSH  HL                   ;17E0 E5                                                                           
                 CALL  L175A                ;17E1 CD5A17                                                                       
                 JR    NZ,L17D9             ;17E4 20F3                                                                         
                 POP   HL                   ;17E6 E1                                                                           
                 RET                        ;17E7 C9                                                                           

L17E8:           PUSH  HL                   ;17E8 E5                                                                           
                 LD    BC,L0004             ;17E9 010400                                                                       
                 ADD   HL,BC                ;17EC 09                                                                           
                 CALL  L17F6                ;17ED CDF617                                                                       
                 INC   BC                   ;17F0 03                                                                           
                 POP   HL                   ;17F1 E1                                                                           
                 RET                        ;17F2 C9                                                                           

L17F3:           LD    BC,COLDSTART         ;17F3 010000                                                                       
L17F6:           PUSH  HL                   ;17F6 E5                                                                           
                 LD    A,13                 ;17F7 3E0D                                                                         
L17F9:           CP    (HL)                 ;17F9 BE                                                                           
                 INC   HL                   ;17FA 23                                                                           
                 INC   BC                   ;17FB 03                                                                           
                 JR    NZ,L17F9             ;17FC 20FB                                                                         
                 DEC   BC                   ;17FE 0B                                                                           
                 POP   HL                   ;17FF E1                                                                           
                 RET                        ;1800 C9                                                                           

L1801:           LD    A,E                  ;1801 7B                                                                           
                 EX    DE,HL                ;1802 EB                                                                           
                 LD    HL,(L4642)           ;1803 2A4246                                                                       
                 INC   A                    ;1806 3C                                                                           
L1807:           DEC   A                    ;1807 3D                                                                           
                 CALL  NZ,L1633             ;1808 C43316                                                                       
                 JR    NZ,L1807             ;180B 20FA                                                                         
                 EX    DE,HL                ;180D EB                                                                           
                 RET                        ;180E C9                                                                           

L180F:           LD    A,D                  ;180F 7A                                                                           
                 OR    A                    ;1810 B7                                                                           
                 RET   NZ                   ;1811 C0                                                                           
                 JR    L1817                ;1812 1803                                                                         

L1814:           LD    A,D                  ;1814 7A                                                                           
                 OR    A                    ;1815 B7                                                                           
                 RET   Z                    ;1816 C8                                                                           
L1817:           JP    L139D                ;1817 C39D13                                                                       

L181A:           LD    HL,(L4644)           ;181A 2A4446                                                                       
                 EX    DE,HL                ;181D EB                                                                           
L181E:           LD    BC,L0005             ;181E 010500                                                                       
                 LDIR                       ;1821 EDB0                                                                         
                 RET                        ;1823 C9                                                                           

L1824:           LD    HL,(L4644)           ;1824 2A4446                                                                       
                 JR    L181E                ;1827 18F5                                                                         

L1829:           CALL  L162D                ;1829 CD2D16                                                                       
                 CP    13                   ;182C FE0D                                                                         
                 RET   Z                    ;182E C8                                                                           
                 CP    58                   ;182F FE3A                                                                         
                 RET                        ;1831 C9                                                                           

L1832:           LD    HL,COLDSTART         ;1832 210000                                                                       
                 LD    (L4632),HL           ;1835 223246                                                                       
                 LD    HL,L4806             ;1838 210648                                                                       
                 CALL  L1896                ;183B CD9618                                                                       
                 LD    (L4634),HL           ;183E 223446                                                                       
                 XOR   A                    ;1841 AF                                                                           
                 LD    (L29B8),A            ;1842 32B829                                                                       
                 CALL  L13C1                ;1845 CDC113                                                                       
                 CALL  L1857                ;1848 CD5718                                                                       
                 CALL  L187C                ;184B CD7C18                                                                       
L184E:           LD    HL,L47FD             ;184E 21FD47                                                                       
                 CALL  L1896                ;1851 CD9618                                                                       
                 JP    L1896                ;1854 C39618                                                                       

L1857:           LD    HL,(L4634)           ;1857 2A3446                                                                       
                 LD    B,9                  ;185A 0609                                                                         
L185C:           CALL  L1896                ;185C CD9618                                                                       
                 DJNZ  L185C                ;185F 10FB                                                                         
                 LD    DE,L4636             ;1861 113646                                                                       
                 LD    HL,(L4634)           ;1864 2A3446                                                                       
                 EX    DE,HL                ;1867 EB                                                                           
                 LD    B,7                  ;1868 0607                                                                         
L186A:           INC   DE                   ;186A 13                                                                           
                 INC   DE                   ;186B 13                                                                           
                 LD    (HL),E               ;186C 73                                                                           
                 INC   HL                   ;186D 23                                                                           
                 LD    (HL),D               ;186E 72                                                                           
                 INC   HL                   ;186F 23                                                                           
                 DJNZ  L186A                ;1870 10F8                                                                         
L1872:           LD    HL,(L4642)           ;1872 2A4246                                                                       
                 CALL  L1896                ;1875 CD9618                                                                       
                 LD    (L4644),HL           ;1878 224446                                                                       
                 RET                        ;187B C9                                                                           

L187C:           LD    HL,L47F0             ;187C 21F047                                                                       
                 LD    (L464A),HL           ;187F 224A46                                                                       
                 LD    HL,L4787             ;1882 218747                                                                       
                 LD    (L4648),HL           ;1885 224846                                                                       
                 LD    HL,L466A             ;1888 216A46                                                                       
                 LD    (L4646),HL           ;188B 224646                                                                       
                 LD    HL,L4803             ;188E 210348                                                                       
                 CALL  L1896                ;1891 CD9618                                                                       
                 LD    (HL),A               ;1894 77                                                                           
                 RET                        ;1895 C9                                                                           

L1896:           XOR   A                    ;1896 AF                                                                           
L1897:           LD    (HL),A               ;1897 77                                                                           
                 INC   HL                   ;1898 23                                                                           
                 LD    (HL),A               ;1899 77                                                                           
                 INC   HL                   ;189A 23                                                                           
                 RET                        ;189B C9                                                                           

L189C:           PUSH  HL                   ;189C E5                                                                           
                 LD    A,E                  ;189D 7B                                                                           
                 EX    AF,AF'               ;189E 08                                                                           
                 LD    A,D                  ;189F 7A                                                                           
                 LD    HL,L4644             ;18A0 214446                                                                       
L18A3:           LD    E,(HL)               ;18A3 5E                                                                           
                 INC   HL                   ;18A4 23                                                                           
                 LD    D,(HL)               ;18A5 56                                                                           
                 CP    D                    ;18A6 BA                                                                           
                 JP    C,L18B3              ;18A7 DAB318                                                                       
                 JP    NZ,L18BF             ;18AA C2BF18                                                                       
                 EX    AF,AF'               ;18AD 08                                                                           
                 CP    E                    ;18AE BB                                                                           
                 JP    NC,L18BE             ;18AF D2BE18                                                                       
                 EX    AF,AF'               ;18B2 08                                                                           
L18B3:           EX    DE,HL                ;18B3 EB                                                                           
                 ADD   HL,BC                ;18B4 09                                                                           
                 EX    DE,HL                ;18B5 EB                                                                           
                 LD    (HL),D               ;18B6 72                                                                           
                 DEC   HL                   ;18B7 2B                                                                           
                 LD    (HL),E               ;18B8 73                                                                           
                 DEC   HL                   ;18B9 2B                                                                           
                 DEC   HL                   ;18BA 2B                                                                           
                 JP    L18A3                ;18BB C3A318                                                                       

L18BE:           EX    AF,AF'               ;18BE 08                                                                           
L18BF:           LD    D,A                  ;18BF 57                                                                           
                 EX    AF,AF'               ;18C0 08                                                                           
                 LD    E,A                  ;18C1 5F                                                                           
                 POP   HL                   ;18C2 E1                                                                           
                 RET                        ;18C3 C9                                                                           

L18C4:           CALL  L162D                ;18C4 CD2D16                                                                       
L18C7:           LD    BC,COLDSTART         ;18C7 010000                                                                       
                 LD    DE,L0D2C             ;18CA 112C0D                                                                       
                 CP    34                   ;18CD FE22                                                                         
                 JR    NZ,L18D3             ;18CF 2002                                                                         
                 LD    E,A                  ;18D1 5F                                                                           
                 INC   HL                   ;18D2 23                                                                           
L18D3:           PUSH  HL                   ;18D3 E5                                                                           
L18D4:           LD    A,(HL)               ;18D4 7E                                                                           
                 CP    D                    ;18D5 BA                                                                           
                 JR    Z,L18E0              ;18D6 2808                                                                         
                 CP    E                    ;18D8 BB                                                                           
                 INC   HL                   ;18D9 23                                                                           
                 JR    Z,L18E0              ;18DA 2804                                                                         
                 INC   BC                   ;18DC 03                                                                           
                 JR    L18D4                ;18DD 18F5                                                                         

L18DF:           PUSH  HL                   ;18DF E5                                                                           
L18E0:           EX    (SP),HL              ;18E0 E3                                                                           
                 EX    DE,HL                ;18E1 EB                                                                           
                 LD    HL,(L4642)           ;18E2 2A4246                                                                       
                 XOR   A                    ;18E5 AF                                                                           
L18E6:           PUSH  AF                   ;18E6 F5                                                                           
                 LD    A,(HL)               ;18E7 7E                                                                           
                 OR    A                    ;18E8 B7                                                                           
                 JR    Z,L18F2              ;18E9 2807                                                                         
                 CALL  L1633                ;18EB CD3316                                                                       
                 POP   AF                   ;18EE F1                                                                           
                 INC   A                    ;18EF 3C                                                                           
                 JR    L18E6                ;18F0 18F4                                                                         

L18F2:           EX    DE,HL                ;18F2 EB                                                                           
                 INC   BC                   ;18F3 03                                                                           
                 CALL  L1796                ;18F4 CD9617                                                                       
                 PUSH  HL                   ;18F7 E5                                                                           
                 LD    HL,(L4644)           ;18F8 2A4446                                                                       
                 ADD   HL,BC                ;18FB 09                                                                           
                 LD    (L4644),HL           ;18FC 224446                                                                       
                 POP   HL                   ;18FF E1                                                                           
                 EX    DE,HL                ;1900 EB                                                                           
                 DEC   BC                   ;1901 0B                                                                           
                 ADD   HL,BC                ;1902 09                                                                           
                 LD    (HL),13              ;1903 360D                                                                         
                 POP   AF                   ;1905 F1                                                                           
                 LD    E,A                  ;1906 5F                                                                           
                 LD    D,1                  ;1907 1601                                                                         
                 POP   HL                   ;1909 E1                                                                           
                 JP    L162D                ;190A C32D16                                                                       

L190D:           CALL  L162D                ;190D CD2D16                                                                       
                 CP    13                   ;1910 FE0D                                                                         
                 JP    Z,L1670              ;1912 CA7016                                                                       
                 PUSH  HL                   ;1915 E5                                                                           
                 DEC   HL                   ;1916 2B                                                                           
L1917:           INC   HL                   ;1917 23                                                                           
                 CALL  L162D                ;1918 CD2D16                                                                       
                 CP    43                   ;191B FE2B                                                                         
                 JR    NZ,L1921             ;191D 2002                                                                         
                 LD    A,188                ;191F 3EBC                                                                         
L1921:           CP    45                   ;1921 FE2D                                                                         
                 JR    NZ,L1927             ;1923 2002                                                                         
                 LD    A,189                ;1925 3EBD                                                                         
L1927:           LD    (HL),A               ;1927 77                                                                           
                 CALL  L193D                ;1928 CD3D19                                                                       
                 JR    Z,L1917              ;192B 28EA                                                                         
                 CP    69                   ;192D FE45                                                                         
                 JR    Z,L1917              ;192F 28E6                                                                         
                 CP    13                   ;1931 FE0D                                                                         
                 JP    NZ,L166F             ;1933 C26F16                                                                       
                 POP   HL                   ;1936 E1                                                                           
                 CALL  L22AF                ;1937 CDAF22                                                                       
                 JP    L167A                ;193A C37A16                                                                       

L193D:           CALL  L1659                ;193D CD5916                                                                       
                 JR    NC,L1944             ;1940 3002                                                                         
                 CP    (HL)                 ;1942 BE                                                                           
                 RET                        ;1943 C9                                                                           

L1944:           CP    46                   ;1944 FE2E                                                                         
                 RET   Z                    ;1946 C8                                                                           
                 CP    189                  ;1947 FEBD                                                                         
                 RET   Z                    ;1949 C8                                                                           
                 CP    188                  ;194A FEBC                                                                         
                 RET                        ;194C C9                                                                           

L194D:           PUSH  HL                   ;194D E5                                                                           
                 LD    HL,(L4644)           ;194E 2A4446                                                                       
                 LD    DE,COLDSTART         ;1951 110000                                                                       
                 LD    A,(HL)               ;1954 7E                                                                           
                 OR    A                    ;1955 B7                                                                           
                 JP    P,L1398              ;1956 F29813                                                                       
                 CP    193                  ;1959 FEC1                                                                         
                 JP    C,L1974              ;195B DA7419                                                                       
                 SUB   209                  ;195E D6D1                                                                         
                 JP    NC,L1398             ;1960 D29813                                                                       
L1963:           LD    E,3                  ;1963 1E03                                                                         
                 ADD   HL,DE                ;1965 19                                                                           
                 LD    E,(HL)               ;1966 5E                                                                           
                 INC   HL                   ;1967 23                                                                           
                 LD    D,(HL)               ;1968 56                                                                           
                 JP    L1970                ;1969 C37019                                                                       

L196C:           SRL   D                    ;196C CB3A                                                                         
                 RR    E                    ;196E CB1B                                                                         
L1970:           INC   A                    ;1970 3C                                                                           
                 JP    NZ,L196C             ;1971 C26C19                                                                       
L1974:           POP   HL                   ;1974 E1                                                                           
                 RET                        ;1975 C9                                                                           

L1976:           LD    HL,L456C             ;1976 216C45                                                                       
                 JR    L197E                ;1979 1803                                                                         

L197B:           LD    HL,L4570             ;197B 217045                                                                       
L197E:           LD    (HL),C               ;197E 71                                                                           
                 INC   HL                   ;197F 23                                                                           
                 LD    (HL),B               ;1980 70                                                                           
                 INC   HL                   ;1981 23                                                                           
                 LD    (HL),E               ;1982 73                                                                           
                 INC   HL                   ;1983 23                                                                           
                 LD    (HL),D               ;1984 72                                                                           
                 INC   HL                   ;1985 23                                                                           
                 RET                        ;1986 C9                                                                           

L1987:           XOR   A                    ;1987 AF                                                                           
                 LD    (L4577),A            ;1988 327745                                                                       
                 RET                        ;198B C9                                                                           

L198C:           EXX                        ;198C D9                                                                           
                 LD    BC,L0005             ;198D 010500                                                                       
                 CALL  L19A0                ;1990 CDA019                                                                       
                 CALL  L22AF                ;1993 CDAF22                                                                       
                 CALL  L1814                ;1996 CD1418                                                                       
                 CALL  L194D                ;1999 CD4D19                                                                       
                 EXX                        ;199C D9                                                                           
                 LD    BC,LFFFB             ;199D 01FBFF                                                                       
L19A0:           LD    HL,(L4644)           ;19A0 2A4446                                                                       
                 ADD   HL,BC                ;19A3 09                                                                           
                 LD    (L4644),HL           ;19A4 224446                                                                       
                 EXX                        ;19A7 D9                                                                           
                 RET                        ;19A8 C9                                                                           

L19A9:           CALL  L198C                ;19A9 CD8C19                                                                       
                 LD    A,D                  ;19AC 7A                                                                           
                 OR    A                    ;19AD B7                                                                           
                 RET   Z                    ;19AE C8                                                                           
                 JP    L1398                ;19AF C39813                                                                       

L19B2:           LD    HL,(L4801)           ;19B2 2A0148                                                                       
L19B5:           CALL  L162D                ;19B5 CD2D16                                                                       
L19B8:           CP    13                   ;19B8 FE0D                                                                         
                 JP    Z,L19C7              ;19BA CAC719                                                                       
                 CALL  L169A                ;19BD CD9A16                                                                       
                 LD    A,(L0122)            ;19C0 3A2201                                                                       
                 LD    C,B                  ;19C3 48                                                                           
                 JP    L19E1                ;19C4 C3E119                                                                       

L19C7:           LD    HL,(L47FD)           ;19C7 2AFD47                                                                       
                 XOR   A                    ;19CA AF                                                                           
                 OR    H                    ;19CB B4                                                                           
                 JP    Z,L124B              ;19CC CA4B12                                                                       
L19CF:           LD    DE,L47FD             ;19CF 11FD47                                                                       
                 LD    BC,L0004             ;19D2 010400                                                                       
                 LDIR                       ;19D5 EDB0                                                                         
                 LD    (L4801),HL           ;19D7 220148                                                                       
                 LD    A,(L47FE)            ;19DA 3AFE47                                                                       
                 OR    A                    ;19DD B7                                                                           
                 JP    Z,L1B2D              ;19DE CA2D1B                                                                       
L19E1:           LD    HL,PORT0             ;19E1 2100E0                                                                       
                 LD    (HL),248             ;19E4 36F8                                                                         
                 INC   HL                   ;19E6 23                                                                           
                 LD    A,(HL)               ;19E7 7E                                                                           
                 INC   A                    ;19E8 3C                                                                           
                 JP    Z,L19F7              ;19E9 CAF719                                                                       
                 CALL  BREAK                ;19EC CD1E00                                                                       
                 JR    NZ,L19F7             ;19EF 2006                                                                         
                 CALL  L13C8                ;19F1 CDC813                                                                       
                 JP    L1385                ;19F4 C38513                                                                       

L19F7:           LD    HL,(L4642)           ;19F7 2A4246                                                                       
                 XOR   A                    ;19FA AF                                                                           
                 LD    (HL),A               ;19FB 77                                                                           
                 INC   HL                   ;19FC 23                                                                           
                 LD    (HL),A               ;19FD 77                                                                           
                 INC   HL                   ;19FE 23                                                                           
                 LD    (L4644),HL           ;19FF 224446                                                                       
                 LD    HL,(L4801)           ;1A02 2A0148                                                                       
                 LD    A,(HL)               ;1A05 7E                                                                           
                 OR    A                    ;1A06 B7                                                                           
                 JP    P,L1B3F              ;1A07 F23F1B                                                                       
                 CP    170                  ;1A0A FEAA                                                                         
                 JP    NC,L138E             ;1A0C D28E13                                                                       
                 LD    DE,L1A1F             ;1A0F 111F1A                                                                       
L1A12:           INC   HL                   ;1A12 23                                                                           
                 EX    DE,HL                ;1A13 EB                                                                           
                 ADD   A,A                  ;1A14 87                                                                           
                 LD    C,A                  ;1A15 4F                                                                           
                 LD    B,0                  ;1A16 0600                                                                         
                 ADD   HL,BC                ;1A18 09                                                                           
                 LD    C,(HL)               ;1A19 4E                                                                           
                 INC   HL                   ;1A1A 23                                                                           
                 LD    B,(HL)               ;1A1B 46                                                                           
                 EX    DE,HL                ;1A1C EB                                                                           
                 PUSH  BC                   ;1A1D C5                                                                           
                 RET                        ;1A1E C9                                                                           

L1A1F:           DW    L1B27                ;1A1F 271B                                                                         
                 DW    L1B27                ;1A21 271B                                                                         
                 DW    L1A76                ;1A23 761A                                                                         
                 DW    L1CCB                ;1A25 CB1C                                                                         
                 DW    L1A6F                ;1A27 6F1A                                                                         
                 DW    L1C2F                ;1A29 2F1C                                                                         
                 DW    L1B3F                ;1A2B 3F1B                                                                         
                 DW    L1D5C                ;1A2D 5C1D                                                                         
                 DW    L2182                ;1A2F 8221                                                                         
                 DW    L1CDB                ;1A31 DB1C                                                                         
                 DW    L1FAF                ;1A33 AF1F                                                                         
                 DW    L1CF6                ;1A35 F61C                                                                         
                 DW    L1D2A                ;1A37 2A1D                                                                         
                 DW    L1DF4                ;1A39 F41D                                                                         
                 DW    L1B36                ;1A3B 361B                                                                         
                 DW    L1B2D                ;1A3D 2D1B                                                                         
                 DW    L1FF6                ;1A3F F61F                                                                         
                 DW    L2A36                ;1A41 362A                                                                         
                 DW    L29BB                ;1A43 BB29                                                                         
                 DW    L298F                ;1A45 8F29                                                                         
                 DW    L2166                ;1A47 6621                                                                         
                 DW    L2050                ;1A49 5020                                                                         
                 DW    L21B0                ;1A4B B021                                                                         
                 DW    L1E7C                ;1A4D 7C1E                                                                         
                 DW    L1B24                ;1A4F 241B                                                                         
                 DW    L2177                ;1A51 7721                                                                         
                 DW    L2226                ;1A53 2622                                                                         
                 DW    L2246                ;1A55 4622                                                                         
                 DW    L28B2                ;1A57 B228                                                                         
                 DW    L2BA7                ;1A59 A72B                                                                         
                 DW    L2BD7                ;1A5B D72B                                                                         
                 DW    L2C05                ;1A5D 052C                                                                         
                 DW    L2854                ;1A5F 5428                                                                         
                 DW    L28C2                ;1A61 C228                                                                         
                 DW    L28FC                ;1A63 FC28                                                                         
                 DW    L292A                ;1A65 2A29                                                                         
                 DW    L292E                ;1A67 2E29                                                                         
                 DW    L2857                ;1A69 5728                                                                         
                 DW    L2CD8                ;1A6B D82C                                                                         
                 DW    L2D2E                ;1A6D 2E2D                                                                         
L1A6F:           CALL  L1832                ;1A6F CD3218                                                                       
                 JP    L124B                ;1A72 C34B12                                                                       

L1A75:           DB    0FEH                 ;1A75 FE                                                                           
L1A76:           LD    A,(L29B8)            ;1A76 3AB829                                                                       
                 OR    A                    ;1A79 B7                                                                           
                 JP    NZ,L124B             ;1A7A C24B12                                                                       
                 LD    B,A                  ;1A7D 47                                                                           
                 CALL  L168B                ;1A7E CD8B16                                                                       
                 CP    A                    ;1A81 BF                                                                           
                 ADC   A,H                  ;1A82 8C                                                                           
                 LD    A,(DE)               ;1A83 1A                                                                           
                 CALL  L169A                ;1A84 CD9A16                                                                       
                 LD    D,B                  ;1A87 50                                                                           
                 CALL  L3C85                ;1A88 CD853C                                                                       
                 INC   B                    ;1A8B 04                                                                           
                 LD    A,B                  ;1A8C 78                                                                           
                 LD    (L1A75),A            ;1A8D 32751A                                                                       
                 PUSH  HL                   ;1A90 E5                                                                           
                 CALL  L1B08                ;1A91 CD081B                                                                       
                 LD    HL,L457E             ;1A94 217E45                                                                       
                 CALL  L1896                ;1A97 CD9618                                                                       
                 DEC   A                    ;1A9A 3D                                                                           
                 CALL  L1897                ;1A9B CD9718                                                                       
                 POP   HL                   ;1A9E E1                                                                           
                 CALL  L168B                ;1A9F CD8B16                                                                       
                 DEC   C                    ;1AA2 0D                                                                           
                 PUSH  HL                   ;1AA3 E5                                                                           
                 LD    A,(DE)               ;1AA4 1A                                                                           
                 LD    HL,L4806             ;1AA5 210648                                                                       
L1AA8:           PUSH  HL                   ;1AA8 E5                                                                           
                 CALL  L175A                ;1AA9 CD5A17                                                                       
                 POP   HL                   ;1AAC E1                                                                           
                 JP    Z,L124B              ;1AAD CA4B12                                                                       
                 CALL  L17E8                ;1AB0 CDE817                                                                       
                 LD    DE,L4455             ;1AB3 115544                                                                       
                 CALL  L1799                ;1AB6 CD9917                                                                       
                 LD    HL,(L457E)           ;1AB9 2A7E45                                                                       
                 EX    DE,HL                ;1ABC EB                                                                           
                 LD    HL,(L4457)           ;1ABD 2A5744                                                                       
                 CALL  L1662                ;1AC0 CD6216                                                                       
                 JP    C,L1ADF              ;1AC3 DADF1A                                                                       
                 EX    DE,HL                ;1AC6 EB                                                                           
                 LD    HL,(L4580)           ;1AC7 2A8045                                                                       
                 CALL  L1662                ;1ACA CD6216                                                                       
                 JP    C,L1ADF              ;1ACD DADF1A                                                                       
                 CALL  L1443                ;1AD0 CD4314                                                                       
                 LD    DE,L4400             ;1AD3 110044                                                                       
                 CALL  L1B12                ;1AD6 CD121B                                                                       
                 CALL  BREAK                ;1AD9 CD1E00                                                                       
                 JP    Z,L124B              ;1ADC CA4B12                                                                       
L1ADF:           LD    HL,(L4455)           ;1ADF 2A5544                                                                       
                 JP    L1AA8                ;1AE2 C3A81A                                                                       

                 DB    0CDH,0F1H,16H,0EDH   ;1AE5 CDF116ED  Link 1AE5 found at , $1AA3                                         
                 DB    53H,7EH,45H,0CDH     ;1AE9 537E45CD                                                                     
                 DB    8BH,16H,0DH,0F9H     ;1AED 8B160DF9                                                                     
                 DB    1AH,0EBH,22H,80H     ;1AF1 1AEB2280                                                                     
                 DB    45H,0C3H,0A5H,1AH    ;1AF5 45C3A51A                                                                     
                 DB    0CDH,9AH,16H,0BDH    ;1AF9 CD9A16BD                                                                     
                 DB    0FEH,0DH,0CAH,0A5H   ;1AFD FE0DCAA5                                                                     
                 DB    1AH,0CDH,0F1H,16H    ;1B01 1ACDF116                                                                     
                 DB    0C3H,0F2H,1AH        ;1B05 C3F21A                                                                       
L1B08:           LD    A,(L1A75)            ;1B08 3A751A                                                                       
                 OR    A                    ;1B0B B7                                                                           
                 JP    Z,CRLF               ;1B0C CA0900                                                                       
                 JP    L3BA1                ;1B0F C3A13B                                                                       

L1B12:           LD    A,(L1A75)            ;1B12 3A751A                                                                       
                 OR    A                    ;1B15 B7                                                                           
                 JR    NZ,L1B1E             ;1B16 2006                                                                         
                 CALL  STRING               ;1B18 CD1800                                                                       
                 JP    CRLF                 ;1B1B C30900                                                                       

L1B1E:           CALL  L3C05                ;1B1E CD053C                                                                       
                 JP    L3BA1                ;1B21 C3A13B                                                                       

L1B24:           CALL  L1987                ;1B24 CD8719                                                                       
L1B27:           CALL  L163D                ;1B27 CD3D16                                                                       
                 JP    L19B8                ;1B2A C3B819                                                                       

L1B2D:           CALL  L13C4                ;1B2D CDC413                                                                       
                 LD    (L4801),HL           ;1B30 220148                                                                       
                 JP    L124B                ;1B33 C34B12                                                                       

L1B36:           CALL  L13C4                ;1B36 CDC413                                                                       
L1B39:           LD    (L4801),HL           ;1B39 220148                                                                       
                 JP    L1385                ;1B3C C38513                                                                       

L1B3F:           PUSH  HL                   ;1B3F E5                                                                           
L1B40:           CALL  L1829                ;1B40 CD2918                                                                       
                 JP    Z,L138E              ;1B43 CA8E13                                                                       
                 CP    182                  ;1B46 FEB6                                                                         
                 INC   HL                   ;1B48 23                                                                           
                 JR    NZ,L1B40             ;1B49 20F5                                                                         
                 CALL  L22AF                ;1B4B CDAF22                                                                       
                 LD    (L4801),HL           ;1B4E 220148                                                                       
                 CALL  L1976                ;1B51 CD7619                                                                       
                 POP   HL                   ;1B54 E1                                                                           
                 CALL  L2613                ;1B55 CD1326                                                                       
                 CALL  L2436                ;1B58 CD3624                                                                       
                 CALL  L169A                ;1B5B CD9A16                                                                       
                 OR    (HL)                 ;1B5E B6                                                                           
                 CALL  L197B                ;1B5F CD7B19                                                                       
                 CALL  L1B6A                ;1B62 CD6A1B                                                                       
                 SBC   A,L                  ;1B65 9D                                                                           
                 INC   DE                   ;1B66 13                                                                           
                 JP    L19B2                ;1B67 C3B219                                                                       

L1B6A:           LD    HL,L456F             ;1B6A 216F45                                                                       
                 LD    B,(HL)               ;1B6D 46                                                                           
                 INC   HL                   ;1B6E 23                                                                           
                 LD    C,(HL)               ;1B6F 4E                                                                           
                 INC   HL                   ;1B70 23                                                                           
                 LD    A,(HL)               ;1B71 7E                                                                           
                 LD    DE,(L4572)           ;1B72 ED5B7245                                                                     
                 OR    A                    ;1B76 B7                                                                           
                 JP    NZ,L1B84             ;1B77 C2841B                                                                       
                 OR    B                    ;1B7A B0                                                                           
                 JP    NZ,L1670             ;1B7B C27016                                                                       
                 CALL  L1824                ;1B7E CD2418                                                                       
                 JP    L167A                ;1B81 C37A16                                                                       

L1B84:           XOR   A                    ;1B84 AF                                                                           
                 OR    B                    ;1B85 B0                                                                           
                 JP    Z,L1670              ;1B86 CA7016                                                                       
                 LD    HL,L4559             ;1B89 215945                                                                       
                 XOR   A                    ;1B8C AF                                                                           
                 LD    B,A                  ;1B8D 47                                                                           
                 SBC   HL,DE                ;1B8E ED52                                                                         
                 JP    Z,L1BC0              ;1B90 CAC01B                                                                       
                 LD    HL,(L456C)           ;1B93 2A6C45                                                                       
                 PUSH  HL                   ;1B96 E5                                                                           
                 XOR   A                    ;1B97 AF                                                                           
                 SBC   HL,BC                ;1B98 ED42                                                                         
                 LD    B,H                  ;1B9A 44                                                                           
                 LD    C,L                  ;1B9B 4D                                                                           
                 JR    C,L1BA3              ;1B9C 3805                                                                         
                 CALL  L177C                ;1B9E CD7C17                                                                       
                 JR    L1BAB                ;1BA1 1808                                                                         

L1BA3:           PUSH  BC                   ;1BA3 C5                                                                           
                 CALL  L1651                ;1BA4 CD5116                                                                       
                 CALL  L1766                ;1BA7 CD6617                                                                       
                 POP   BC                   ;1BAA C1                                                                           
L1BAB:           CALL  L189C                ;1BAB CD9C18                                                                       
                 LD    HL,(L456E)           ;1BAE 2A6E45                                                                       
                 EX    DE,HL                ;1BB1 EB                                                                           
                 CALL  L1801                ;1BB2 CD0118                                                                       
                 EX    DE,HL                ;1BB5 EB                                                                           
                 POP   BC                   ;1BB6 C1                                                                           
                 LD    A,C                  ;1BB7 79                                                                           
                 OR    A                    ;1BB8 B7                                                                           
                 JR    Z,L1BBD              ;1BB9 2802                                                                         
                 LDIR                       ;1BBB EDB0                                                                         
L1BBD:           JP    L167A                ;1BBD C37A16                                                                       

L1BC0:           LD    HL,(L456E)           ;1BC0 2A6E45                                                                       
                 EX    DE,HL                ;1BC3 EB                                                                           
                 CALL  L1801                ;1BC4 CD0118                                                                       
                 EX    DE,HL                ;1BC7 EB                                                                           
                 LD    DE,L4557             ;1BC8 115745                                                                       
                 PUSH  DE                   ;1BCB D5                                                                           
                 LD    B,3                  ;1BCC 0603                                                                         
L1BCE:           LD    C,2                  ;1BCE 0E02                                                                         
L1BD0:           CALL  L1659                ;1BD0 CD5916                                                                       
                 JP    NC,L1398             ;1BD3 D29813                                                                       
                 LD    (DE),A               ;1BD6 12                                                                           
                 INC   DE                   ;1BD7 13                                                                           
                 INC   HL                   ;1BD8 23                                                                           
                 DEC   C                    ;1BD9 0D                                                                           
                 JR    NZ,L1BD0             ;1BDA 20F4                                                                         
                 LD    A,13                 ;1BDC 3E0D                                                                         
                 LD    (DE),A               ;1BDE 12                                                                           
                 INC   DE                   ;1BDF 13                                                                           
                 DEC   B                    ;1BE0 05                                                                           
                 JR    NZ,L1BCE             ;1BE1 20EB                                                                         
                 CALL  L168B                ;1BE3 CD8B16                                                                       
                 DEC   C                    ;1BE6 0D                                                                           
                 SBC   A,B                  ;1BE7 98                                                                           
                 INC   DE                   ;1BE8 13                                                                           
                 POP   HL                   ;1BE9 E1                                                                           
                 CALL  L198C                ;1BEA CD8C19                                                                       
                 LD    B,0                  ;1BED 0600                                                                         
                 LD    A,E                  ;1BEF 7B                                                                           
                 CP    24                   ;1BF0 FE18                                                                         
                 JP    NC,L1398             ;1BF2 D29813                                                                       
                 SUB   12                   ;1BF5 D60C                                                                         
                 JR    C,L1BFB              ;1BF7 3802                                                                         
                 LD    E,A                  ;1BF9 5F                                                                           
                 INC   B                    ;1BFA 04                                                                           
L1BFB:           LD    A,B                  ;1BFB 78                                                                           
                 PUSH  AF                   ;1BFC F5                                                                           
                 PUSH  HL                   ;1BFD E5                                                                           
                 LD    HL,L0E10             ;1BFE 21100E                                                                       
                 CALL  L16C8                ;1C01 CDC816                                                                       
                 POP   HL                   ;1C04 E1                                                                           
                 PUSH  DE                   ;1C05 D5                                                                           
                 INC   HL                   ;1C06 23                                                                           
                 CALL  L198C                ;1C07 CD8C19                                                                       
                 LD    A,E                  ;1C0A 7B                                                                           
                 CP    60                   ;1C0B FE3C                                                                         
                 JP    NC,L1398             ;1C0D D29813                                                                       
                 PUSH  HL                   ;1C10 E5                                                                           
                 LD    HL,L003C             ;1C11 213C00                                                                       
                 CALL  L16C8                ;1C14 CDC816                                                                       
                 POP   HL                   ;1C17 E1                                                                           
                 EX    (SP),HL              ;1C18 E3                                                                           
                 ADD   HL,DE                ;1C19 19                                                                           
                 EX    (SP),HL              ;1C1A E3                                                                           
                 INC   HL                   ;1C1B 23                                                                           
                 CALL  L198C                ;1C1C CD8C19                                                                       
                 LD    A,E                  ;1C1F 7B                                                                           
                 CP    60                   ;1C20 FE3C                                                                         
                 JP    NC,L1398             ;1C22 D29813                                                                       
                 POP   HL                   ;1C25 E1                                                                           
                 ADD   HL,DE                ;1C26 19                                                                           
                 EX    DE,HL                ;1C27 EB                                                                           
                 POP   AF                   ;1C28 F1                                                                           
                 CALL  SETCLOCK             ;1C29 CD3300                                                                       
                 JP    L167A                ;1C2C C37A16                                                                       

L1C2F:           LD    B,0                  ;1C2F 0600                                                                         
                 CALL  L168B                ;1C31 CD8B16                                                                       
                 CP    A                    ;1C34 BF                                                                           
                 LD    B,L                  ;1C35 45                                                                           
                 INC   E                    ;1C36 1C                                                                           
                 INC   HL                   ;1C37 23                                                                           
                 INC   B                    ;1C38 04                                                                           
                 CP    84                   ;1C39 FE54                                                                         
                 JP    Z,L1C45              ;1C3B CA451C                                                                       
                 CP    80                   ;1C3E FE50                                                                         
                 JP    NZ,L138E             ;1C40 C28E13                                                                       
                 LD    B,128                ;1C43 0680                                                                         
L1C45:           LD    A,B                  ;1C45 78                                                                           
                 LD    (L457D),A            ;1C46 327D45                                                                       
                 CALL  L1829                ;1C49 CD2918                                                                       
                 JP    NZ,L1C60             ;1C4C C2601C                                                                       
                 LD    A,(L457D)            ;1C4F 3A7D45                                                                       
                 LD    BC,L19B5             ;1C52 01B519                                                                       
                 PUSH  BC                   ;1C55 C5                                                                           
                 CP    1                    ;1C56 FE01                                                                         
                 RET   Z                    ;1C58 C8                                                                           
                 OR    A                    ;1C59 B7                                                                           
                 JP    Z,CRLF2              ;1C5A CA0600                                                                       
                 JP    L3BA6                ;1C5D C3A63B                                                                       

L1C60:           CALL  L168B                ;1C60 CD8B16                                                                       
                 DEC   SP                   ;1C63 3B                                                                           
                 LD    H,(HL)               ;1C64 66                                                                           
                 INC   E                    ;1C65 1C                                                                           
                 CALL  L168B                ;1C66 CD8B16                                                                       
                 INC   L                    ;1C69 2C                                                                           
                 LD    A,L                  ;1C6A 7D                                                                           
                 INC   E                    ;1C6B 1C                                                                           
                 LD    A,(L457D)            ;1C6C 3A7D45                                                                       
                 LD    BC,L1C7D             ;1C6F 017D1C                                                                       
                 PUSH  BC                   ;1C72 C5                                                                           
                 CP    1                    ;1C73 FE01                                                                         
                 RET   Z                    ;1C75 C8                                                                           
                 OR    A                    ;1C76 B7                                                                           
                 JP    Z,TAB                ;1C77 CA0F00                                                                       
                 JP    L3C4A                ;1C7A C34A3C                                                                       

L1C7D:           DB    0CDH,29H,18H,0CAH    ;1C7D CD2918CA  Link 1C7D found at , $1C6A, $1C70                                  
                 DB    0B5H,19H,0FEH,3BH    ;1C81 B519FE3B                                                                     
                 DB    28H,02H,0FEH,2CH     ;1C85 2802FE2C                                                                     
                 DB    0CAH,60H,1CH,0CDH    ;1C89 CA601CCD                                                                     
                 DB    0AFH,22H,0E5H,7AH    ;1C8D AF22E57A                                                                     
                 DB    0B7H,0C2H,0C5H,1CH   ;1C91 B7C2C51C                                                                     
                 DB    2AH,44H,46H,11H      ;1C95 2A444611                                                                     
                 DB    00H,44H,0D5H,0CDH    ;1C99 0044D5CD                                                                     
                 DB    2DH,32H,0D1H,3AH     ;1C9D 2D32D13A                                                                     
                 DB    7DH,45H,01H,0B3H     ;1CA1 7D4501B3                                                                     
                 DB    1CH,0C5H,0FEH,01H    ;1CA5 1CC5FE01                                                                     
                 DB    0CAH,4EH,2CH,0B7H    ;1CA9 CA4E2CB7                                                                     
                 DB    0CAH,27H,3DH,0C3H    ;1CAD CA273DC3                                                                     
                 DB    0B6H,3BH,0E1H,0CDH   ;1CB1 B63BE1CD                                                                     
                 DB    29H,18H,28H,06H      ;1CB5 29182806                                                                     
                 DB    0FEH,3BH,28H,02H     ;1CB9 FE3B2802                                                                     
                 DB    0FEH,2CH,0CAH,49H    ;1CBD FE2CCA49                                                                     
                 DB    1CH,0C3H,8EH,13H     ;1CC1 1CC38E13                                                                     
                 DB    0CDH,01H,18H,0C3H    ;1CC5 CD0118C3                                                                     
                 DB    0A0H,1CH             ;1CC9 A01C                                                                         
L1CCB:           CALL  L1987                ;1CCB CD8719                                                                       
                 XOR   A                    ;1CCE AF                                                                           
                 LD    (L457A),A            ;1CCF 327A45                                                                       
                 LD    (L4565),A            ;1CD2 326545                                                                       
                 CALL  L1659                ;1CD5 CD5916                                                                       
                 JP    NC,L1CEA             ;1CD8 D2EA1C                                                                       
L1CDB:           CALL  L16F1                ;1CDB CDF116                                                                       
L1CDE:           EX    DE,HL                ;1CDE EB                                                                           
                 CALL  L17A5                ;1CDF CDA517                                                                       
                 ADC   A,(HL)               ;1CE2 8E                                                                           
                 INC   DE                   ;1CE3 13                                                                           
                 JP    NZ,L138E             ;1CE4 C28E13                                                                       
                 JP    L19CF                ;1CE7 C3CF19                                                                       

L1CEA:           CALL  L1857                ;1CEA CD5718                                                                       
                 CALL  L187C                ;1CED CD7C18                                                                       
                 LD    HL,L4806             ;1CF0 210648                                                                       
                 JP    L19CF                ;1CF3 C3CF19                                                                       

L1CF6:           CALL  L16F1                ;1CF6 CDF116                                                                       
L1CF9:           LD    (L4801),HL           ;1CF9 220148                                                                       
                 EX    DE,HL                ;1CFC EB                                                                           
                 CALL  L17A5                ;1CFD CDA517                                                                       
                 ADC   A,(HL)               ;1D00 8E                                                                           
                 INC   DE                   ;1D01 13                                                                           
                 JP    NZ,L138E             ;1D02 C28E13                                                                       
                 EXX                        ;1D05 D9                                                                           
                 LD    HL,L4805             ;1D06 210548                                                                       
                 LD    A,(HL)               ;1D09 7E                                                                           
                 CP    15                   ;1D0A FE0F                                                                         
                 JP    Z,L13A7              ;1D0C CAA713                                                                       
                 INC   (HL)                 ;1D0F 34                                                                           
                 DEC   HL                   ;1D10 2B                                                                           
                 DEC   HL                   ;1D11 2B                                                                           
                 LD    DE,(L464A)           ;1D12 ED5B4A46                                                                     
                 DEC   DE                   ;1D16 1B                                                                           
                 LD    BC,L0007             ;1D17 010700                                                                       
                 LDDR                       ;1D1A EDB8                                                                         
                 INC   DE                   ;1D1C 13                                                                           
                 LD    (L464A),DE           ;1D1D ED534A46                                                                     
                 LD    C,7                  ;1D21 0E07                                                                         
                 ADD   HL,BC                ;1D23 09                                                                           
                 LD    (HL),0               ;1D24 3600                                                                         
                 EXX                        ;1D26 D9                                                                           
                 JP    L19CF                ;1D27 C3CF19                                                                       

L1D2A:           LD    HL,L4805             ;1D2A 210548                                                                       
                 XOR   A                    ;1D2D AF                                                                           
                 CP    (HL)                 ;1D2E BE                                                                           
                 JP    Z,L138E              ;1D2F CA8E13                                                                       
                 DEC   (HL)                 ;1D32 35                                                                           
L1D33:           LD    HL,L4803             ;1D33 210348                                                                       
                 LD    A,(HL)               ;1D36 7E                                                                           
                 OR    A                    ;1D37 B7                                                                           
                 JP    Z,L1D4B              ;1D38 CA4B1D                                                                       
                 DEC   (HL)                 ;1D3B 35                                                                           
                 INC   HL                   ;1D3C 23                                                                           
                 DEC   (HL)                 ;1D3D 35                                                                           
                 LD    HL,(L4648)           ;1D3E 2A4846                                                                       
                 LD    BC,L0013             ;1D41 011300                                                                       
                 ADD   HL,BC                ;1D44 09                                                                           
                 LD    (L4648),HL           ;1D45 224846                                                                       
                 JP    L1D33                ;1D48 C3331D                                                                       

L1D4B:           LD    HL,(L464A)           ;1D4B 2A4A46                                                                       
                 LD    DE,L47FD             ;1D4E 11FD47                                                                       
                 LD    BC,L0007             ;1D51 010700                                                                       
                 LDIR                       ;1D54 EDB0                                                                         
                 LD    (L464A),HL           ;1D56 224A46                                                                       
                 JP    L19B2                ;1D59 C3B219                                                                       

L1D5C:           CALL  L2613                ;1D5C CD1326                                                                       
                 CALL  L169A                ;1D5F CD9A16                                                                       
                 OR    (HL)                 ;1D62 B6                                                                           
                 PUSH  DE                   ;1D63 D5                                                                           
                 CALL  L1DEB                ;1D64 CDEB1D                                                                       
                 POP   HL                   ;1D67 E1                                                                           
                 LD    (L47F0),HL           ;1D68 22F047                                                                       
                 EX    DE,HL                ;1D6B EB                                                                           
                 CALL  L2441                ;1D6C CD4124                                                                       
                 CALL  L1824                ;1D6F CD2418                                                                       
                 CALL  L1697                ;1D72 CD9716                                                                       
                 XOR   (HL)                 ;1D75 AE                                                                           
                 CALL  L1DEB                ;1D76 CDEB1D                                                                       
                 LD    DE,L47F8             ;1D79 11F847                                                                       
                 CALL  L1824                ;1D7C CD2418                                                                       
                 CALL  L1688                ;1D7F CD8816                                                                       
                 XOR   A                    ;1D82 AF                                                                           
                 ADC   A,L                  ;1D83 8D                                                                           
                 DEC   E                    ;1D84 1D                                                                           
                 CALL  L1DEB                ;1D85 CDEB1D                                                                       
                 LD    HL,(L4644)           ;1D88 2A4446                                                                       
                 JR    L1D90                ;1D8B 1803                                                                         

                 DB    21H,14H,16H          ;1D8D 211416                                                                       
L1D90:           LD    DE,L47F2             ;1D90 11F247                                                                       
                 LD    A,(HL)               ;1D93 7E                                                                           
                 LD    (L47F7),A            ;1D94 32F747                                                                       
                 LD    BC,L0005             ;1D97 010500                                                                       
                 LDIR                       ;1D9A EDB0                                                                         
                 LD    HL,(L4648)           ;1D9C 2A4846                                                                       
                 LD    DE,(L47F0)           ;1D9F ED5BF047                                                                     
                 LD    A,(L4803)            ;1DA3 3A0348                                                                       
                 INC   A                    ;1DA6 3C                                                                           
L1DA7:           DEC   A                    ;1DA7 3D                                                                           
                 JP    Z,L1DCC              ;1DA8 CACC1D                                                                       
                 EX    AF,AF'               ;1DAB 08                                                                           
                 LD    A,(HL)               ;1DAC 7E                                                                           
                 SUB   E                    ;1DAD 93                                                                           
                 LD    B,A                  ;1DAE 47                                                                           
                 INC   HL                   ;1DAF 23                                                                           
                 LD    A,(HL)               ;1DB0 7E                                                                           
                 SUB   D                    ;1DB1 92                                                                           
                 OR    B                    ;1DB2 B0                                                                           
                 LD    BC,VIDEO             ;1DB3 011200                                                                       
                 ADD   HL,BC                ;1DB6 09                                                                           
                 JP    Z,L1DBE              ;1DB7 CABE1D                                                                       
                 EX    AF,AF'               ;1DBA 08                                                                           
                 JP    L1DA7                ;1DBB C3A71D                                                                       

L1DBE:           LD    (L4648),HL           ;1DBE 224846                                                                       
                 EX    AF,AF'               ;1DC1 08                                                                           
                 DEC   A                    ;1DC2 3D                                                                           
                 LD    HL,L4803             ;1DC3 210348                                                                       
                 LD    B,(HL)               ;1DC6 46                                                                           
                 LD    (HL),A               ;1DC7 77                                                                           
                 SUB   B                    ;1DC8 90                                                                           
                 INC   HL                   ;1DC9 23                                                                           
                 ADD   A,(HL)               ;1DCA 86                                                                           
                 LD    (HL),A               ;1DCB 77                                                                           
L1DCC:           LD    HL,L4804             ;1DCC 210448                                                                       
                 LD    A,(HL)               ;1DCF 7E                                                                           
                 CP    15                   ;1DD0 FE0F                                                                         
                 JP    Z,L13A2              ;1DD2 CAA213                                                                       
                 INC   (HL)                 ;1DD5 34                                                                           
                 DEC   HL                   ;1DD6 2B                                                                           
                 INC   (HL)                 ;1DD7 34                                                                           
                 DEC   HL                   ;1DD8 2B                                                                           
                 LD    DE,(L4648)           ;1DD9 ED5B4846                                                                     
                 LD    BC,L0013             ;1DDD 011300                                                                       
                 DEC   DE                   ;1DE0 1B                                                                           
                 LDDR                       ;1DE1 EDB8                                                                         
                 INC   DE                   ;1DE3 13                                                                           
                 EX    DE,HL                ;1DE4 EB                                                                           
                 LD    (L4648),HL           ;1DE5 224846                                                                       
                 JP    L19B2                ;1DE8 C3B219                                                                       

L1DEB:           CALL  L22AF                ;1DEB CDAF22                                                                       
                 LD    (L4801),HL           ;1DEE 220148                                                                       
                 JP    L1814                ;1DF1 C31418                                                                       

L1DF4:           LD    A,(L4803)            ;1DF4 3A0348                                                                       
                 OR    A                    ;1DF7 B7                                                                           
                 JP    Z,L138E              ;1DF8 CA8E13                                                                       
                 CALL  L25CD                ;1DFB CDCD25                                                                       
                 LD    (L4801),HL           ;1DFE 220148                                                                       
                 LD    HL,(L4648)           ;1E01 2A4846                                                                       
                 CALL  NC,L1E77             ;1E04 D4771E                                                                       
L1E07:           LD    A,E                  ;1E07 7B                                                                           
                 SUB   (HL)                 ;1E08 96                                                                           
                 INC   HL                   ;1E09 23                                                                           
                 LD    B,A                  ;1E0A 47                                                                           
                 LD    A,D                  ;1E0B 7A                                                                           
                 SUB   (HL)                 ;1E0C 96                                                                           
                 OR    B                    ;1E0D B0                                                                           
                 JP    Z,L1E28              ;1E0E CA281E                                                                       
                 EXX                        ;1E11 D9                                                                           
                 LD    HL,L4803             ;1E12 210348                                                                       
                 LD    A,(HL)               ;1E15 7E                                                                           
                 DEC   A                    ;1E16 3D                                                                           
                 JP    Z,L138E              ;1E17 CA8E13                                                                       
                 LD    (HL),A               ;1E1A 77                                                                           
                 INC   HL                   ;1E1B 23                                                                           
                 DEC   (HL)                 ;1E1C 35                                                                           
                 EXX                        ;1E1D D9                                                                           
                 LD    BC,VIDEO             ;1E1E 011200                                                                       
                 ADD   HL,BC                ;1E21 09                                                                           
                 LD    (L4648),HL           ;1E22 224846                                                                       
                 JP    L1E07                ;1E25 C3071E                                                                       

L1E28:           INC   HL                   ;1E28 23                                                                           
                 CALL  L2441                ;1E29 CD4124                                                                       
                 PUSH  DE                   ;1E2C D5                                                                           
                 PUSH  HL                   ;1E2D E5                                                                           
                 CALL  L2D4D                ;1E2E CD4D2D                                                                       
                 POP   HL                   ;1E31 E1                                                                           
                 POP   DE                   ;1E32 D1                                                                           
                 LD    BC,L0005             ;1E33 010500                                                                       
                 ADD   HL,BC                ;1E36 09                                                                           
                 LD    A,(HL)               ;1E37 7E                                                                           
                 INC   HL                   ;1E38 23                                                                           
                 PUSH  HL                   ;1E39 E5                                                                           
                 OR    A                    ;1E3A B7                                                                           
                 JP    P,L1E57              ;1E3B F2571E                                                                       
                 EX    DE,HL                ;1E3E EB                                                                           
                 CALL  L33EE                ;1E3F CDEE33                                                                       
                 POP   HL                   ;1E42 E1                                                                           
                 LD    BC,L0005             ;1E43 010500                                                                       
                 JP    C,L1E62              ;1E46 DA621E                                                                       
L1E49:           ADD   HL,BC                ;1E49 09                                                                           
                 LD    DE,L47FD             ;1E4A 11FD47                                                                       
                 INC   C                    ;1E4D 0C                                                                           
                 LDIR                       ;1E4E EDB0                                                                         
                 LD    HL,(L4801)           ;1E50 2A0148                                                                       
                 LD    A,(HL)               ;1E53 7E                                                                           
                 JP    L19B8                ;1E54 C3B819                                                                       

L1E57:           CALL  L33EE                ;1E57 CDEE33                                                                       
                 POP   HL                   ;1E5A E1                                                                           
                 LD    BC,L0005             ;1E5B 010500                                                                       
                 CCF                        ;1E5E 3F                                                                           
                 JP    C,L1E49              ;1E5F DA491E                                                                       
L1E62:           LD    C,11                 ;1E62 0E0B                                                                         
                 ADD   HL,BC                ;1E64 09                                                                           
                 LD    (L4648),HL           ;1E65 224846                                                                       
                 LD    HL,L4803             ;1E68 210348                                                                       
                 DEC   (HL)                 ;1E6B 35                                                                           
                 INC   HL                   ;1E6C 23                                                                           
                 DEC   (HL)                 ;1E6D 35                                                                           
                 CALL  L1688                ;1E6E CD8816                                                                       
                 INC   L                    ;1E71 2C                                                                           
                 OR    D                    ;1E72 B2                                                                           
                 ADD   HL,DE                ;1E73 19                                                                           
                 JP    L1DF4                ;1E74 C3F41D                                                                       

L1E77:           LD    E,(HL)               ;1E77 5E                                                                           
                 INC   HL                   ;1E78 23                                                                           
                 LD    D,(HL)               ;1E79 56                                                                           
                 DEC   HL                   ;1E7A 2B                                                                           
                 RET                        ;1E7B C9                                                                           

L1E7C:           CALL  L2C39                ;1E7C CD392C                                                                       
                 PUSH  HL                   ;1E7F E5                                                                           
                 LD    HL,(L47FF)           ;1E80 2AFF47                                                                       
                 LD    A,L                  ;1E83 7D                                                                           
                 OR    H                    ;1E84 B4                                                                           
                 JP    Z,L138E              ;1E85 CA8E13                                                                       
                 XOR   A                    ;1E88 AF                                                                           
                 LD    (L4574),A            ;1E89 327445                                                                       
                 POP   HL                   ;1E8C E1                                                                           
                 LD    (L4801),HL           ;1E8D 220148                                                                       
                 PUSH  HL                   ;1E90 E5                                                                           
                 CALL  L162D                ;1E91 CD2D16                                                                       
                 CP    34                   ;1E94 FE22                                                                         
                 LD    DE,L1EAF             ;1E96 11AF1E                                                                       
                 JP    NZ,L1EA9             ;1E99 C2A91E                                                                       
                 CALL  L2383                ;1E9C CD8323                                                                       
                 CALL  L169A                ;1E9F CD9A16                                                                       
                 DEC   SP                   ;1EA2 3B                                                                           
                 LD    (L4801),HL           ;1EA3 220148                                                                       
                 CALL  L1801                ;1EA6 CD0118                                                                       
L1EA9:           CALL  L1EC1                ;1EA9 CDC11E                                                                       
                 JP    L1F06                ;1EAC C3061F                                                                       

L1EAF:           DB    "? "                 ;1EAF 3F20                                                                         
                 DB    0DH                  ;1EB1 0D                                                                           
L1EB2:           XOR   A                    ;1EB2 AF                                                                           
                 LD    (CHARCOUNT),A        ;1EB3 329411                                                                       
                 RET                        ;1EB6 C9                                                                           

L1EB7:           LD    A,(L457D)            ;1EB7 3A7D45                                                                       
                 OR    A                    ;1EBA B7                                                                           
                 CALL  Z,CRLF               ;1EBB CC0900                                                                       
                 LD    DE,L1EAF             ;1EBE 11AF1E                                                                       
L1EC1:           LD    A,(L457D)            ;1EC1 3A7D45                                                                       
                 OR    A                    ;1EC4 B7                                                                           
                 CALL  Z,MESSAGE            ;1EC5 CC1500                                                                       
                 CALL  NZ,L1EB2             ;1EC8 C4B21E                                                                       
                 LD    DE,L4455             ;1ECB 115544                                                                       
                 LD    A,(CHARCOUNT)        ;1ECE 3A9411                                                                       
                 CALL  L2C7A                ;1ED1 CD7A2C                                                                       
                 CALL  USER                 ;1ED4 CD0300                                                                       
                 EX    DE,HL                ;1ED7 EB                                                                           
                 LD    A,(L457D)            ;1ED8 3A7D45                                                                       
                 OR    A                    ;1EDB B7                                                                           
                 JP    NZ,L1EF8             ;1EDC C2F81E                                                                       
                 LD    A,27                 ;1EDF 3E1B                                                                         
                 CP    (HL)                 ;1EE1 BE                                                                           
                 JP    Z,L1EFC              ;1EE2 CAFC1E                                                                       
                 LD    A,13                 ;1EE5 3E0D                                                                         
L1EE7:           CP    (HL)                 ;1EE7 BE                                                                           
                 JP    Z,L1EB7              ;1EE8 CAB71E                                                                       
                 INC   HL                   ;1EEB 23                                                                           
                 DEC   C                    ;1EEC 0D                                                                           
                 JR    NZ,L1EE7             ;1EED 20F8                                                                         
                 CALL  L168B                ;1EEF CD8B16                                                                       
                 DEC   C                    ;1EF2 0D                                                                           
                 RET   M                    ;1EF3 F8                                                                           
                 LD    E,195                ;1EF4 1EC3                                                                         
                 OR    A                    ;1EF6 B7                                                                           
                 LD    E,34                 ;1EF7 1E22                                                                         
                 LD    (HL),L               ;1EF9 75                                                                           
                 LD    B,L                  ;1EFA 45                                                                           
                 RET                        ;1EFB C9                                                                           

L1EFC:           LD    A,129                ;1EFC 3E81                                                                         
                 LD    (L4565),A            ;1EFE 326545                                                                       
                 POP   AF                   ;1F01 F1                                                                           
                 POP   HL                   ;1F02 E1                                                                           
                 JP    L1B39                ;1F03 C3391B                                                                       

L1F06:           LD    HL,(L4801)           ;1F06 2A0148                                                                       
                 CALL  L1829                ;1F09 CD2918                                                                       
                 JP    Z,L1FA4              ;1F0C CAA41F                                                                       
                 CALL  L2613                ;1F0F CD1326                                                                       
                 CALL  L2436                ;1F12 CD3624                                                                       
                 CALL  L1829                ;1F15 CD2918                                                                       
                 JR    Z,L1F1E              ;1F18 2804                                                                         
                 CALL  L169A                ;1F1A CD9A16                                                                       
                 INC   L                    ;1F1D 2C                                                                           
L1F1E:           LD    (L4801),HL           ;1F1E 220148                                                                       
                 CALL  L197B                ;1F21 CD7B19                                                                       
                 LD    HL,(L4575)           ;1F24 2A7545                                                                       
                 CALL  L168B                ;1F27 CD8B16                                                                       
                 INC   L                    ;1F2A 2C                                                                           
                 DEC   L                    ;1F2B 2D                                                                           
                 RRA                        ;1F2C 1F                                                                           
                 LD    (L4575),HL           ;1F2D 227545                                                                       
                 LD    A,(L457D)            ;1F30 3A7D45                                                                       
                 OR    A                    ;1F33 B7                                                                           
                 JP    NZ,L1F3D             ;1F34 C23D1F                                                                       
                 CALL  L1829                ;1F37 CD2918                                                                       
                 CALL  Z,L1F9A              ;1F3A CC9A1F                                                                       
L1F3D:           LD    HL,(L4575)           ;1F3D 2A7545                                                                       
                 CALL  L18C4                ;1F40 CDC418                                                                       
                 LD    A,(L4574)            ;1F43 3A7445                                                                       
                 OR    A                    ;1F46 B7                                                                           
                 JP    Z,L1F4D              ;1F47 CA4D1F                                                                       
                 LD    (L4578),HL           ;1F4A 227845                                                                       
L1F4D:           LD    (L4575),HL           ;1F4D 227545                                                                       
                 LD    A,(L4571)            ;1F50 3A7145                                                                       
                 OR    A                    ;1F53 B7                                                                           
                 CALL  Z,L1F72              ;1F54 CC721F                                                                       
                 CALL  L1976                ;1F57 CD7619                                                                       
                 CALL  L1B6A                ;1F5A CD6A1B                                                                       
                 SBC   A,L                  ;1F5D 9D                                                                           
                 INC   DE                   ;1F5E 13                                                                           
                 LD    A,(L457D)            ;1F5F 3A7D45                                                                       
                 OR    A                    ;1F62 B7                                                                           
                 JP    Z,L1F06              ;1F63 CA061F                                                                       
                 LD    HL,(L4801)           ;1F66 2A0148                                                                       
                 CALL  L1829                ;1F69 CD2918                                                                       
                 CALL  NZ,L1EC1             ;1F6C C4C11E                                                                       
                 JP    L1F06                ;1F6F C3061F                                                                       

L1F72:           CALL  L1801                ;1F72 CD0118                                                                       
                 EX    DE,HL                ;1F75 EB                                                                           
                 CALL  L190D                ;1F76 CD0D19                                                                       
                 LD    A,H                  ;1F79 7C                                                                           
                 RRA                        ;1F7A 1F                                                                           
                 RET                        ;1F7B C9                                                                           

                 DB    0F1H,3AH,74H,45H     ;1F7C F13A7445  Link 1F7C found at , $1F79                                         
                 DB    0B7H,0C2H,98H,13H    ;1F80 B7C29813                                                                     
                 DB    3AH,7DH,45H,0B7H     ;1F84 3A7D45B7                                                                     
                 DB    0C2H,98H,13H,11H     ;1F88 C2981311                                                                     
                 DB    18H,13H,0CDH,57H     ;1F8C 1813CD57                                                                     
                 DB    13H,11H,0FFH,12H     ;1F90 1311FF12                                                                     
                 DB    0CDH,15H,00H,0C3H    ;1F94 CD1500C3                                                                     
                 DB    8CH,1EH              ;1F98 8C1E                                                                         
L1F9A:           LD    A,(L4574)            ;1F9A 3A7445                                                                       
                 OR    A                    ;1F9D B7                                                                           
                 JP    Z,L1EB7              ;1F9E CAB71E                                                                       
                 JP    L1FD4                ;1FA1 C3D41F                                                                       

L1FA4:           LD    A,(L4574)            ;1FA4 3A7445                                                                       
                 OR    A                    ;1FA7 B7                                                                           
                 JP    NZ,L19B2             ;1FA8 C2B219                                                                       
                 POP   AF                   ;1FAB F1                                                                           
                 JP    L19B2                ;1FAC C3B219                                                                       

L1FAF:           LD    (L4801),HL           ;1FAF 220148                                                                       
                 LD    A,(L4577)            ;1FB2 3A7745                                                                       
                 OR    A                    ;1FB5 B7                                                                           
                 CALL  Z,L1FCA              ;1FB6 CCCA1F                                                                       
                 LD    HL,(L4578)           ;1FB9 2A7845                                                                       
                 LD    (L4575),HL           ;1FBC 227545                                                                       
                 XOR   A                    ;1FBF AF                                                                           
                 LD    (L457D),A            ;1FC0 327D45                                                                       
                 INC   A                    ;1FC3 3C                                                                           
                 LD    (L4574),A            ;1FC4 327445                                                                       
                 JP    L1F06                ;1FC7 C3061F                                                                       

L1FCA:           INC   A                    ;1FCA 3C                                                                           
                 LD    (L4577),A            ;1FCB 327745                                                                       
                 LD    HL,L4806             ;1FCE 210648                                                                       
                 JP    L1FE0                ;1FD1 C3E01F                                                                       

L1FD4:           LD    HL,(L4575)           ;1FD4 2A7545                                                                       
                 CALL  L163D                ;1FD7 CD3D16                                                                       
                 INC   HL                   ;1FDA 23                                                                           
                 CP    58                   ;1FDB FE3A                                                                         
                 JP    Z,L1FE9              ;1FDD CAE91F                                                                       
L1FE0:           LD    A,(HL)               ;1FE0 7E                                                                           
                 INC   HL                   ;1FE1 23                                                                           
                 OR    (HL)                 ;1FE2 B6                                                                           
                 JP    Z,L1385              ;1FE3 CA8513                                                                       
                 INC   HL                   ;1FE6 23                                                                           
                 INC   HL                   ;1FE7 23                                                                           
                 INC   HL                   ;1FE8 23                                                                           
L1FE9:           CALL  L168B                ;1FE9 CD8B16                                                                       
                 ADD   A,C                  ;1FEC 81                                                                           
                 RST   10H   ;16            ;1FED D7                                                                           
                 RRA                        ;1FEE 1F                                                                           
                 LD    (L4578),HL           ;1FEF 227845                                                                       
                 LD    (L4575),HL           ;1FF2 227545                                                                       
                 RET                        ;1FF5 C9                                                                           

L1FF6:           CALL  L22AF                ;1FF6 CDAF22                                                                       
                 CALL  L1814                ;1FF9 CD1418                                                                       
                 LD    DE,(L4644)           ;1FFC ED5B4446                                                                     
                 LD    A,(DE)               ;2000 1A                                                                           
                 LD    DE,COLDSTART         ;2001 110000                                                                       
                 CP    193                  ;2004 FEC1                                                                         
                 JP    C,L2019              ;2006 DA1920                                                                       
                 SUB   209                  ;2009 D6D1                                                                         
                 JP    NC,L2019             ;200B D21920                                                                       
                 LD    BC,L2019             ;200E 011920                                                                       
                 PUSH  BC                   ;2011 C5                                                                           
                 PUSH  HL                   ;2012 E5                                                                           
                 LD    HL,(L4644)           ;2013 2A4446                                                                       
                 JP    L1963                ;2016 C36319                                                                       

L2019:           LD    A,(HL)               ;2019 7E                                                                           
                 INC   HL                   ;201A 23                                                                           
                 SUB   137                  ;201B D689                                                                         
                 JR    Z,L2024              ;201D 2805                                                                         
                 CP    2                    ;201F FE02                                                                         
                 JP    NZ,L138E             ;2021 C28E13                                                                       
L2024:           EX    AF,AF'               ;2024 08                                                                           
                 LD    A,E                  ;2025 7B                                                                           
L2026:           OR    A                    ;2026 B7                                                                           
                 JP    Z,L1B27              ;2027 CA271B                                                                       
                 LD    A,D                  ;202A 7A                                                                           
                 OR    A                    ;202B B7                                                                           
                 JP    NZ,L1B27             ;202C C2271B                                                                       
L202F:           DEC   E                    ;202F 1D                                                                           
                 JP    Z,L2042              ;2030 CA4220                                                                       
L2033:           CALL  L1829                ;2033 CD2918                                                                       
                 JP    Z,L19B8              ;2036 CAB819                                                                       
                 CP    44                   ;2039 FE2C                                                                         
                 INC   HL                   ;203B 23                                                                           
                 JP    NZ,L2033             ;203C C23320                                                                       
                 JP    L202F                ;203F C32F20                                                                       

L2042:           CALL  L16F1                ;2042 CDF116                                                                       
                 CALL  L163D                ;2045 CD3D16                                                                       
                 EX    AF,AF'               ;2048 08                                                                           
                 OR    A                    ;2049 B7                                                                           
                 JP    NZ,L1CF9             ;204A C2F91C                                                                       
                 JP    L1CDE                ;204D C3DE1C                                                                       

L2050:           CALL  L2613                ;2050 CD1326                                                                       
                 LD    BC,COLDSTART         ;2053 010000                                                                       
                 CP    36                   ;2056 FE24                                                                         
                 JR    NZ,L205C             ;2058 2002                                                                         
                 INC   HL                   ;205A 23                                                                           
                 INC   B                    ;205B 04                                                                           
L205C:           CALL  L169A                ;205C CD9A16                                                                       
                 JR    Z,L202E              ;205F 28CD                                                                         
                 EXX                        ;2061 D9                                                                           
                 JR    NZ,L2026             ;2062 20C2                                                                         
                 OR    L                    ;2064 B5                                                                           
                 JR    NZ,L204C             ;2065 20E5                                                                         
                 LD    HL,(L20D7)           ;2067 2AD720                                                                       
                 LD    E,H                  ;206A 5C                                                                           
                 LD    D,A                  ;206B 57                                                                           
                 LD    H,A                  ;206C 67                                                                           
                 INC   HL                   ;206D 23                                                                           
                 INC   DE                   ;206E 13                                                                           
                 CALL  L16A7                ;206F CDA716                                                                       
                 SUB   E                    ;2072 93                                                                           
                 INC   DE                   ;2073 13                                                                           
                 LD    A,(L20D6)            ;2074 3AD620                                                                       
                 OR    A                    ;2077 B7                                                                           
                 POP   HL                   ;2078 E1                                                                           
                 PUSH  DE                   ;2079 D5                                                                           
                 PUSH  HL                   ;207A E5                                                                           
                 JR    NZ,L2085             ;207B 2008                                                                         
                 LD    HL,L0005             ;207D 210500                                                                       
                 CALL  L16A7                ;2080 CDA716                                                                       
                 SUB   E                    ;2083 93                                                                           
                 INC   DE                   ;2084 13                                                                           
L2085:           LD    HL,L0004             ;2085 210400                                                                       
                 ADD   HL,DE                ;2088 19                                                                           
                 JP    C,L1393              ;2089 DA9313                                                                       
                 LD    B,H                  ;208C 44                                                                           
                 LD    C,L                  ;208D 4D                                                                           
                 POP   DE                   ;208E D1                                                                           
                 CALL  L177C                ;208F CD7C17                                                                       
                 CALL  L189C                ;2092 CD9C18                                                                       
                 LD    HL,(L4630)           ;2095 2A3046                                                                       
                 EX    DE,HL                ;2098 EB                                                                           
                 LD    (HL),E               ;2099 73                                                                           
                 INC   HL                   ;209A 23                                                                           
                 LD    (HL),D               ;209B 72                                                                           
                 INC   HL                   ;209C 23                                                                           
                 LD    DE,(L20D7)           ;209D ED5BD720                                                                     
                 LD    (HL),E               ;20A1 73                                                                           
                 INC   HL                   ;20A2 23                                                                           
                 LD    (HL),D               ;20A3 72                                                                           
                 INC   HL                   ;20A4 23                                                                           
                 POP   BC                   ;20A5 C1                                                                           
                 LD    A,(L20D6)            ;20A6 3AD620                                                                       
                 OR    A                    ;20A9 B7                                                                           
                 JP    Z,L20C1              ;20AA CAC120                                                                       
L20AD:           LD    (HL),13              ;20AD 360D                                                                         
                 INC   HL                   ;20AF 23                                                                           
                 DEC   BC                   ;20B0 0B                                                                           
                 LD    A,B                  ;20B1 78                                                                           
                 OR    C                    ;20B2 B1                                                                           
                 JR    NZ,L20AD             ;20B3 20F8                                                                         
L20B5:           LD    HL,(L20D4)           ;20B5 2AD420                                                                       
                 CALL  L168B                ;20B8 CD8B16                                                                       
                 INC   L                    ;20BB 2C                                                                           
                 OR    L                    ;20BC B5                                                                           
                 ADD   HL,DE                ;20BD 19                                                                           
                 JP    L2050                ;20BE C35020                                                                       

L20C1:           EX    DE,HL                ;20C1 EB                                                                           
L20C2:           PUSH  BC                   ;20C2 C5                                                                           
                 LD    HL,L1619             ;20C3 211916                                                                       
                 LD    BC,L0005             ;20C6 010500                                                                       
                 LDIR                       ;20C9 EDB0                                                                         
                 POP   BC                   ;20CB C1                                                                           
                 DEC   BC                   ;20CC 0B                                                                           
                 LD    A,B                  ;20CD 78                                                                           
                 OR    C                    ;20CE B1                                                                           
                 JR    NZ,L20C2             ;20CF 20F1                                                                         
                 JP    L20B5                ;20D1 C3B520                                                                       

L20D4:           DW    0A323H               ;20D4 23A3                                                                         
L20D6:           DB    33H                  ;20D6 33                                                                           
L20D7:           DW    09E3EH               ;20D7 3E9E                                                                         
L20D9:           PUSH  DE                   ;20D9 D5                                                                           
                 PUSH  BC                   ;20DA C5                                                                           
                 CALL  L19A9                ;20DB CDA919                                                                       
                 POP   BC                   ;20DE C1                                                                           
                 LD    A,(HL)               ;20DF 7E                                                                           
                 CP    44                   ;20E0 FE2C                                                                         
                 CALL  Z,L215A              ;20E2 CC5A21                                                                       
                 CALL  L169A                ;20E5 CD9A16                                                                       
                 ADD   HL,HL                ;20E8 29                                                                           
                 LD    (L20D4),HL           ;20E9 22D420                                                                       
                 POP   HL                   ;20EC E1                                                                           
                 LD    (L4630),HL           ;20ED 223046                                                                       
                 EX    DE,HL                ;20F0 EB                                                                           
                 LD    (L20D7),HL           ;20F1 22D720                                                                       
                 LD    A,B                  ;20F4 78                                                                           
                 LD    (L20D6),A            ;20F5 32D620                                                                       
                 LD    HL,L4636             ;20F8 213646                                                                       
                 LD    DE,CRLF2             ;20FB 110600                                                                       
                 OR    A                    ;20FE B7                                                                           
                 JR    NZ,L2102             ;20FF 2001                                                                         
                 ADD   HL,DE                ;2101 19                                                                           
L2102:           LD    A,C                  ;2102 79                                                                           
                 LD    E,2                  ;2103 1E02                                                                         
                 OR    A                    ;2105 B7                                                                           
                 JR    NZ,L2109             ;2106 2001                                                                         
                 ADD   HL,DE                ;2108 19                                                                           
L2109:           LD    E,(HL)               ;2109 5E                                                                           
                 INC   HL                   ;210A 23                                                                           
                 LD    D,(HL)               ;210B 56                                                                           
                 EX    DE,HL                ;210C EB                                                                           
L210D:           CALL  L17C4                ;210D CDC417                                                                       
                 LD    B,E                  ;2110 43                                                                           
                 LD    HL,L45CA             ;2111 21CA45                                                                       
                 LD    HL,L235E             ;2114 215E23                                                                       
                 PUSH  HL                   ;2117 E5                                                                           
                 LD    L,(HL)               ;2118 6E                                                                           
                 LD    D,0                  ;2119 1600                                                                         
                 LD    H,D                  ;211B 62                                                                           
                 INC   HL                   ;211C 23                                                                           
                 INC   DE                   ;211D 13                                                                           
                 CALL  L16C8                ;211E CDC816                                                                       
                 LD    A,(L20D6)            ;2121 3AD620                                                                       
                 OR    A                    ;2124 B7                                                                           
                 JP    NZ,L2134             ;2125 C23421                                                                       
                 LD    HL,L0005             ;2128 210500                                                                       
                 CALL  L16C8                ;212B CDC816                                                                       
                 POP   HL                   ;212E E1                                                                           
                 ADD   HL,DE                ;212F 19                                                                           
L2130:           INC   HL                   ;2130 23                                                                           
                 JP    L210D                ;2131 C30D21                                                                       

L2134:           POP   HL                   ;2134 E1                                                                           
L2135:           LD    A,13                 ;2135 3E0D                                                                         
L2137:           INC   HL                   ;2137 23                                                                           
                 CP    (HL)                 ;2138 BE                                                                           
                 JR    NZ,L2137             ;2139 20FC                                                                         
                 DEC   DE                   ;213B 1B                                                                           
                 LD    A,D                  ;213C 7A                                                                           
                 OR    E                    ;213D B3                                                                           
                 JR    NZ,L2135             ;213E 20F5                                                                         
                 JP    L2130                ;2140 C33021                                                                       

                 DB    0AFH,0C9H,4EH,23H    ;2143 AFC94E23  Link 2143 found at , $2110                                         
                 DB    46H,23H,0EDH,5BH     ;2147 4623ED5B                                                                     
                 DB    0D7H,20H,78H,0BAH    ;214B D72078BA                                                                     
                 DB    38H,02H,79H,0BBH     ;214F 380279BB                                                                     
                 DB    0DAH,8EH,13H,3EH     ;2153 DA8E133E                                                                     
                 DB    01H,0B7H,0C9H        ;2157 01B7C9                                                                       
L215A:           INC   C                    ;215A 0C                                                                           
                 PUSH  BC                   ;215B C5                                                                           
                 PUSH  DE                   ;215C D5                                                                           
                 INC   HL                   ;215D 23                                                                           
                 CALL  L19A9                ;215E CDA919                                                                       
                 LD    A,E                  ;2161 7B                                                                           
                 POP   DE                   ;2162 D1                                                                           
                 LD    D,A                  ;2163 57                                                                           
                 POP   BC                   ;2164 C1                                                                           
                 RET                        ;2165 C9                                                                           

L2166:           CALL  L198C                ;2166 CD8C19                                                                       
                 PUSH  DE                   ;2169 D5                                                                           
                 CALL  L169A                ;216A CD9A16                                                                       
                 INC   L                    ;216D 2C                                                                           
                 CALL  L19A9                ;216E CDA919                                                                       
                 EX    (SP),HL              ;2171 E3                                                                           
                 LD    (HL),E               ;2172 73                                                                           
                 POP   HL                   ;2173 E1                                                                           
                 JP    L19B5                ;2174 C3B519                                                                       

L2177:           PUSH  HL                   ;2177 E5                                                                           
                 CALL  L1857                ;2178 CD5718                                                                       
                 CALL  L1872                ;217B CD7218                                                                       
                 POP   HL                   ;217E E1                                                                           
                 JP    L19B5                ;217F C3B519                                                                       

L2182:           CALL  L2258                ;2182 CD5822                                                                       
                 CALL  L1814                ;2185 CD1418                                                                       
                 LD    IX,(L4644)           ;2188 DD2A4446                                                                     
                 BIT   7,(IX+4)             ;218C DDCB047E                                                                     
                 JP    Z,L19C7              ;2190 CAC719                                                                       
                 LD    A,(HL)               ;2193 7E                                                                           
                 INC   HL                   ;2194 23                                                                           
                 CP    137                  ;2195 FE89                                                                         
L2197:           JP    Z,L1CDB              ;2197 CADB1C                                                                       
                 CP    139                  ;219A FE8B                                                                         
                 JP    Z,L1CF6              ;219C CAF61C                                                                       
                 CP    173                  ;219F FEAD                                                                         
                 JP    NZ,L138E             ;21A1 C28E13                                                                       
                 CALL  L1659                ;21A4 CD5916                                                                       
                 JP    C,L1CDB              ;21A7 DADB1C                                                                       
                 LD    (L4801),HL           ;21AA 220148                                                                       
                 JP    L19E1                ;21AD C3E119                                                                       

L21B0:           CALL  L162D                ;21B0 CD2D16                                                                       
                 SUB   65                   ;21B3 D641                                                                         
                 CP    26                   ;21B5 FE1A                                                                         
                 JP    NC,L138E             ;21B7 D28E13                                                                       
                 LD    E,(HL)               ;21BA 5E                                                                           
                 INC   HL                   ;21BB 23                                                                           
                 CALL  L169A                ;21BC CD9A16                                                                       
                 JR    Z,L2197              ;21BF 28D6                                                                         
                 LD    B,C                  ;21C1 41                                                                           
                 CP    26                   ;21C2 FE1A                                                                         
                 JP    NC,L138E             ;21C4 D28E13                                                                       
                 LD    D,(HL)               ;21C7 56                                                                           
                 INC   HL                   ;21C8 23                                                                           
                 CALL  L169A                ;21C9 CD9A16                                                                       
                 ADD   HL,HL                ;21CC 29                                                                           
                 CALL  L169A                ;21CD CD9A16                                                                       
                 OR    (HL)                 ;21D0 B6                                                                           
                 PUSH  HL                   ;21D1 E5                                                                           
                 CALL  L163D                ;21D2 CD3D16                                                                       
                 POP   BC                   ;21D5 C1                                                                           
                 PUSH  HL                   ;21D6 E5                                                                           
                 XOR   A                    ;21D7 AF                                                                           
                 SBC   HL,BC                ;21D8 ED42                                                                         
                 PUSH  BC                   ;21DA C5                                                                           
                 PUSH  HL                   ;21DB E5                                                                           
                 LD    HL,(L4634)           ;21DC 2A3446                                                                       
L21DF:           LD    A,(HL)               ;21DF 7E                                                                           
                 CP    E                    ;21E0 BB                                                                           
                 JP    Z,L2204              ;21E1 CA0422                                                                       
                 CP    0                    ;21E4 FE00                                                                         
                 JR    Z,L21EF              ;21E6 2807                                                                         
                 INC   HL                   ;21E8 23                                                                           
                 INC   HL                   ;21E9 23                                                                           
                 CALL  L1633                ;21EA CD3316                                                                       
                 JR    L21DF                ;21ED 18F0                                                                         

L21EF:           EX    DE,HL                ;21EF EB                                                                           
                 LD    BC,USER              ;21F0 010300                                                                       
                 CALL  L177C                ;21F3 CD7C17                                                                       
                 CALL  L189C                ;21F6 CD9C18                                                                       
                 EX    DE,HL                ;21F9 EB                                                                           
                 LD    (HL),E               ;21FA 73                                                                           
                 INC   HL                   ;21FB 23                                                                           
                 LD    (HL),D               ;21FC 72                                                                           
                 INC   HL                   ;21FD 23                                                                           
                 LD    (HL),13              ;21FE 360D                                                                         
                 EX    DE,HL                ;2200 EB                                                                           
                 JP    L221A                ;2201 C31A22                                                                       

L2204:           INC   HL                   ;2204 23                                                                           
                 LD    (HL),D               ;2205 72                                                                           
                 INC   HL                   ;2206 23                                                                           
                 PUSH  HL                   ;2207 E5                                                                           
                 CALL  L163D                ;2208 CD3D16                                                                       
                 POP   DE                   ;220B D1                                                                           
                 XOR   A                    ;220C AF                                                                           
                 SBC   HL,DE                ;220D ED52                                                                         
                 LD    B,H                  ;220F 44                                                                           
                 LD    C,L                  ;2210 4D                                                                           
                 CALL  L1766                ;2211 CD6617                                                                       
                 CALL  L1651                ;2214 CD5116                                                                       
                 CALL  L189C                ;2217 CD9C18                                                                       
L221A:           POP   BC                   ;221A C1                                                                           
                 POP   HL                   ;221B E1                                                                           
                 CALL  L1796                ;221C CD9617                                                                       
                 CALL  L189C                ;221F CD9C18                                                                       
                 POP   HL                   ;2222 E1                                                                           
                 JP    L19B5                ;2223 C3B519                                                                       

L2226:           CALL  L1829                ;2226 CD2918                                                                       
                 JP    Z,L19B5              ;2229 CAB519                                                                       
                 CALL  L22AF                ;222C CDAF22                                                                       
                 CALL  L1829                ;222F CD2918                                                                       
                 JR    Z,L2235              ;2232 2801                                                                         
                 INC   HL                   ;2234 23                                                                           
L2235:           PUSH  HL                   ;2235 E5                                                                           
                 CALL  L180F                ;2236 CD0F18                                                                       
                 CALL  L1801                ;2239 CD0118                                                                       
                 CALL  MUSIC                ;223C CD3000                                                                       
                 JP    C,L1385              ;223F DA8513                                                                       
                 POP   HL                   ;2242 E1                                                                           
                 JP    L2226                ;2243 C32622                                                                       

L2246:           CALL  L19A9                ;2246 CDA919                                                                       
                 LD    A,E                  ;2249 7B                                                                           
                 DEC   A                    ;224A 3D                                                                           
                 CP    7                    ;224B FE07                                                                         
                 JP    NC,L1398             ;224D D29813                                                                       
                 INC   A                    ;2250 3C                                                                           
                 CALL  SPEED                ;2251 CD4100                                                                       
                 JP    L1B27                ;2254 C3271B                                                                       

L2257:           INC   HL                   ;2257 23                                                                           
L2258:           CALL  L22AF                ;2258 CDAF22                                                                       
L225B:           CP    176                  ;225B FEB0                                                                         
                 RET   C                    ;225D D8                                                                           
                 CP    188                  ;225E FEBC                                                                         
                 RET   NC                   ;2260 D0                                                                           
                 EX    AF,AF'               ;2261 08                                                                           
                 LD    A,D                  ;2262 7A                                                                           
                 OR    A                    ;2263 B7                                                                           
                 JP    NZ,L2272             ;2264 C27222                                                                       
                 EX    AF,AF'               ;2267 08                                                                           
                 EXX                        ;2268 D9                                                                           
                 LD    BC,L225B             ;2269 015B22                                                                       
                 LD    DE,L22AE             ;226C 11AE22                                                                       
                 JP    L2339                ;226F C33923                                                                       

L2272:           EX    AF,AF'               ;2272 08                                                                           
                 CP    182                  ;2273 FEB6                                                                         
                 JP    NZ,L138E             ;2275 C28E13                                                                       
                 LD    A,C                  ;2278 79                                                                           
                 PUSH  DE                   ;2279 D5                                                                           
                 PUSH  AF                   ;227A F5                                                                           
                 CALL  L22AE                ;227B CDAE22                                                                       
                 CALL  L180F                ;227E CD0F18                                                                       
                 POP   AF                   ;2281 F1                                                                           
                 EX    (SP),HL              ;2282 E3                                                                           
                 LD    B,A                  ;2283 47                                                                           
                 SUB   C                    ;2284 91                                                                           
                 JP    NZ,L22A1             ;2285 C2A122                                                                       
                 OR    B                    ;2288 B0                                                                           
                 JP    Z,L229C              ;2289 CA9C22                                                                       
                 CALL  L1801                ;228C CD0118                                                                       
                 EX    DE,HL                ;228F EB                                                                           
                 CALL  L1801                ;2290 CD0118                                                                       
L2293:           LD    A,(DE)               ;2293 1A                                                                           
                 CP    (HL)                 ;2294 BE                                                                           
                 INC   HL                   ;2295 23                                                                           
                 INC   DE                   ;2296 13                                                                           
                 JP    NZ,L22A1             ;2297 C2A122                                                                       
                 DJNZ  L2293                ;229A 10F7                                                                         
L229C:           LD    DE,L161E             ;229C 111E16                                                                       
                 JR    Z,L22A4              ;229F 2803                                                                         
L22A1:           LD    DE,L1619             ;22A1 111916                                                                       
L22A4:           CALL  L181A                ;22A4 CD1A18                                                                       
                 POP   HL                   ;22A7 E1                                                                           
                 CALL  L237B                ;22A8 CD7B23                                                                       
                 JP    L225B                ;22AB C35B22                                                                       

L22AE:           INC   HL                   ;22AE 23                                                                           
L22AF:           LD    A,(HL)               ;22AF 7E                                                                           
                 CP    32                   ;22B0 FE20                                                                         
                 JR    Z,L22AE              ;22B2 28FA                                                                         
                 CP    188                  ;22B4 FEBC                                                                         
                 JP    Z,L22C7              ;22B6 CAC722                                                                       
                 CP    189                  ;22B9 FEBD                                                                         
                 JP    NZ,L22C8             ;22BB C2C822                                                                       
                 CALL  L2315                ;22BE CD1523                                                                       
                 CALL  L2393                ;22C1 CD9323                                                                       
                 JP    L22CB                ;22C4 C3CB22                                                                       

L22C7:           INC   HL                   ;22C7 23                                                                           
L22C8:           CALL  L2316                ;22C8 CD1623                                                                       
L22CB:           CP    188                  ;22CB FEBC                                                                         
                 RET   C                    ;22CD D8                                                                           
                 CP    190                  ;22CE FEBE                                                                         
                 RET   NC                   ;22D0 D0                                                                           
                 EX    AF,AF'               ;22D1 08                                                                           
                 LD    A,D                  ;22D2 7A                                                                           
                 OR    A                    ;22D3 B7                                                                           
                 JP    NZ,L22E2             ;22D4 C2E222                                                                       
                 EX    AF,AF'               ;22D7 08                                                                           
                 EXX                        ;22D8 D9                                                                           
                 LD    BC,L22CB             ;22D9 01CB22                                                                       
                 LD    DE,L2315             ;22DC 111523                                                                       
                 JP    L2339                ;22DF C33923                                                                       

L22E2:           EX    AF,AF'               ;22E2 08                                                                           
                 CP    188                  ;22E3 FEBC                                                                         
                 JP    NZ,L138E             ;22E5 C28E13                                                                       
                 PUSH  DE                   ;22E8 D5                                                                           
                 PUSH  BC                   ;22E9 C5                                                                           
                 CALL  L2315                ;22EA CD1523                                                                       
                 CALL  L180F                ;22ED CD0F18                                                                       
                 LD    A,C                  ;22F0 79                                                                           
                 EXX                        ;22F1 D9                                                                           
                 POP   BC                   ;22F2 C1                                                                           
                 POP   DE                   ;22F3 D1                                                                           
                 ADD   A,C                  ;22F4 81                                                                           
                 JP    C,L1398              ;22F5 DA9813                                                                       
                 LD    H,B                  ;22F8 60                                                                           
                 LD    L,A                  ;22F9 6F                                                                           
                 PUSH  HL                   ;22FA E5                                                                           
                 EXX                        ;22FB D9                                                                           
                 PUSH  HL                   ;22FC E5                                                                           
                 PUSH  DE                   ;22FD D5                                                                           
                 EXX                        ;22FE D9                                                                           
                 POP   HL                   ;22FF E1                                                                           
                 PUSH  HL                   ;2300 E5                                                                           
                 CALL  L1801                ;2301 CD0118                                                                       
                 EX    DE,HL                ;2304 EB                                                                           
                 CALL  L1801                ;2305 CD0118                                                                       
                 CALL  L1796                ;2308 CD9617                                                                       
                 CALL  L189C                ;230B CD9C18                                                                       
                 POP   DE                   ;230E D1                                                                           
                 POP   HL                   ;230F E1                                                                           
                 POP   BC                   ;2310 C1                                                                           
                 LD    A,(HL)               ;2311 7E                                                                           
                 JP    L22CB                ;2312 C3CB22                                                                       

L2315:           INC   HL                   ;2315 23                                                                           
L2316:           CALL  L232A                ;2316 CD2A23                                                                       
L2319:           CP    190                  ;2319 FEBE                                                                         
                 RET   C                    ;231B D8                                                                           
                 CP    192                  ;231C FEC0                                                                         
                 RET   NC                   ;231E D0                                                                           
                 EXX                        ;231F D9                                                                           
                 LD    BC,L2319             ;2320 011923                                                                       
                 LD    DE,L2329             ;2323 112923                                                                       
                 JP    L2339                ;2326 C33923                                                                       

L2329:           DB    23H                  ;2329 23                                                                           
L232A:           CALL  L2383                ;232A CD8323                                                                       
L232D:           CP    207                  ;232D FECF                                                                         
                 RET   NZ                   ;232F C0                                                                           
                 LD    A,192                ;2330 3EC0                                                                         
                 EXX                        ;2332 D9                                                                           
                 LD    BC,L232D             ;2333 012D23                                                                       
                 LD    DE,L2382             ;2336 118223                                                                       
L2339:           PUSH  BC                   ;2339 C5                                                                           
                 LD    HL,(L4644)           ;233A 2A4446                                                                       
                 LD    BC,L0005             ;233D 010500                                                                       
                 ADD   HL,BC                ;2340 09                                                                           
                 LD    (L4644),HL           ;2341 224446                                                                       
                 SUB   176                  ;2344 D6B0                                                                         
                 ADD   A,A                  ;2346 87                                                                           
                 LD    HL,L2628             ;2347 212826                                                                       
                 LD    C,A                  ;234A 4F                                                                           
                 ADD   HL,BC                ;234B 09                                                                           
                 LD    C,(HL)               ;234C 4E                                                                           
                 INC   HL                   ;234D 23                                                                           
                 LD    B,(HL)               ;234E 46                                                                           
                 PUSH  BC                   ;234F C5                                                                           
                 LD    HL,L235C             ;2350 215C23                                                                       
                 PUSH  HL                   ;2353 E5                                                                           
                 PUSH  DE                   ;2354 D5                                                                           
                 EXX                        ;2355 D9                                                                           
                 LD    A,D                  ;2356 7A                                                                           
                 OR    A                    ;2357 B7                                                                           
                 RET   Z                    ;2358 C8                                                                           
                 JP    L139D                ;2359 C39D13                                                                       

L235C:           DB    7AH,0B7H             ;235C 7AB7  Link 235C found at , $2351                                             
L235E:           DB    0C2H,9DH,13H,0FDH    ;235E C29D13FD                                                                     
                 DB    0E1H,0E5H,2AH,44H    ;2362 E1E52A44                                                                     
                 DB    46H,01H,0FBH,0FFH    ;2366 4601FBFF                                                                     
                 DB    5DH,54H,09H,22H      ;236A 5D540922                                                                     
                 DB    44H,46H,0EBH,01H     ;236E 4446EB01                                                                     
                 DB    7AH,23H,0C5H,0FDH    ;2372 7A23C5FD                                                                     
                 DB    0E9H                 ;2376 E9                                                                           
L2377:           CALL  L181A                ;2377 CD1A18                                                                       
L237A:           POP   HL                   ;237A E1                                                                           
L237B:           LD    BC,L0005             ;237B 010500                                                                       
                 LD    D,B                  ;237E 50                                                                           
                 LD    E,B                  ;237F 58                                                                           
                 LD    A,(HL)               ;2380 7E                                                                           
                 RET                        ;2381 C9                                                                           

L2382:           DB    23H                  ;2382 23                                                                           
L2383:           CALL  L162D                ;2383 CD2D16                                                                       
                 CP    188                  ;2386 FEBC                                                                         
                 JP    Z,L23A8              ;2388 CAA823                                                                       
                 CP    189                  ;238B FEBD                                                                         
                 JP    NZ,L23A9             ;238D C2A923                                                                       
                 CALL  L23A8                ;2390 CDA823                                                                       
L2393:           EXX                        ;2393 D9                                                                           
                 LD    HL,(L4644)           ;2394 2A4446                                                                       
                 PUSH  HL                   ;2397 E5                                                                           
                 LD    BC,L0004             ;2398 010400                                                                       
                 ADD   HL,BC                ;239B 09                                                                           
                 LD    A,(HL)               ;239C 7E                                                                           
                 POP   HL                   ;239D E1                                                                           
                 OR    A                    ;239E B7                                                                           
                 JR    Z,L23A5              ;239F 2804                                                                         
                 LD    A,(HL)               ;23A1 7E                                                                           
                 ADD   A,128                ;23A2 C680                                                                         
                 LD    (HL),A               ;23A4 77                                                                           
L23A5:           EXX                        ;23A5 D9                                                                           
                 LD    A,(HL)               ;23A6 7E                                                                           
                 RET                        ;23A7 C9                                                                           

L23A8:           INC   HL                   ;23A8 23                                                                           
L23A9:           CALL  L25CD                ;23A9 CDCD25                                                                       
                 JP    NC,L23CC             ;23AC D2CC23                                                                       
                 LD    A,70                 ;23AF 3E46                                                                         
                 CP    E                    ;23B1 BB                                                                           
                 JR    NZ,L23BA             ;23B2 2006                                                                         
                 LD    A,78                 ;23B4 3E4E                                                                         
                 CP    D                    ;23B6 BA                                                                           
                 JP    Z,L2476              ;23B7 CA7624                                                                       
L23BA:           CALL  L2436                ;23BA CD3624                                                                       
                 PUSH  HL                   ;23BD E5                                                                           
                 LD    A,B                  ;23BE 78                                                                           
                 OR    A                    ;23BF B7                                                                           
                 JP    Z,L2377              ;23C0 CA7723                                                                       
                 EX    DE,HL                ;23C3 EB                                                                           
                 LD    B,0                  ;23C4 0600                                                                         
                 CALL  L18DF                ;23C6 CDDF18                                                                       
                 POP   HL                   ;23C9 E1                                                                           
                 LD    A,(HL)               ;23CA 7E                                                                           
                 RET                        ;23CB C9                                                                           

L23CC:           CP    40                   ;23CC FE28                                                                         
                 JP    Z,L23F2              ;23CE CAF223                                                                       
                 CP    34                   ;23D1 FE22                                                                         
                 JP    Z,L18C4              ;23D3 CAC418                                                                       
                 CALL  L193D                ;23D6 CD3D19                                                                       
                 JP    NZ,L23E3             ;23D9 C2E323                                                                       
                 LD    DE,(L4644)           ;23DC ED5B4446                                                                     
                 JP    L2FD9                ;23E0 C3D92F                                                                       

L23E3:           CP    255                  ;23E3 FEFF                                                                         
                 JP    NZ,L2400             ;23E5 C20024                                                                       
                 CALL  L162C                ;23E8 CD2C16                                                                       
                 PUSH  HL                   ;23EB E5                                                                           
                 LD    DE,L1623             ;23EC 112316                                                                       
                 JP    L2377                ;23EF C37723                                                                       

L23F2:           LD    BC,COLDSTART         ;23F2 010000                                                                       
                 CALL  L1752                ;23F5 CD5217                                                                       
                 CALL  L2257                ;23F8 CD5722                                                                       
                 CALL  L169A                ;23FB CD9A16                                                                       
                 ADD   HL,HL                ;23FE 29                                                                           
                 RET                        ;23FF C9                                                                           

L2400:           SUB   192                  ;2400 D6C0                                                                         
                 CP    15                   ;2402 FE0F                                                                         
                 JP    NC,L240D             ;2404 D20D24                                                                       
                 LD    DE,L264A             ;2407 114A26                                                                       
                 JP    L1A12                ;240A C3121A                                                                       

L240D:           SUB   16                   ;240D D610                                                                         
                 CP    15                   ;240F FE0F                                                                         
                 JP    NC,L138E             ;2411 D28E13                                                                       
                 PUSH  AF                   ;2414 F5                                                                           
                 CALL  L22AE                ;2415 CDAE22                                                                       
                 CALL  L1814                ;2418 CD1418                                                                       
                 CALL  L169A                ;241B CD9A16                                                                       
                 ADD   HL,HL                ;241E 29                                                                           
                 POP   AF                   ;241F F1                                                                           
                 PUSH  HL                   ;2420 E5                                                                           
                 LD    HL,L237A             ;2421 217A23                                                                       
                 PUSH  HL                   ;2424 E5                                                                           
                 LD    HL,(L4644)           ;2425 2A4446                                                                       
                 EX    DE,HL                ;2428 EB                                                                           
                 LD    HL,L2662             ;2429 216226                                                                       
                 ADD   A,A                  ;242C 87                                                                           
                 LD    C,A                  ;242D 4F                                                                           
                 LD    B,0                  ;242E 0600                                                                         
                 ADD   HL,BC                ;2430 09                                                                           
                 LD    A,(HL)               ;2431 7E                                                                           
                 INC   HL                   ;2432 23                                                                           
                 LD    H,(HL)               ;2433 66                                                                           
                 LD    L,A                  ;2434 6F                                                                           
                 JP    (HL)                 ;2435 E9                                                                           

L2436:           LD    A,(HL)               ;2436 7E                                                                           
                 CP    36                   ;2437 FE24                                                                         
                 JP    Z,L24F7              ;2439 CAF724                                                                       
                 CP    40                   ;243C FE28                                                                         
                 JP    Z,L2585              ;243E CA8525                                                                       
L2441:           PUSH  HL                   ;2441 E5                                                                           
                 LD    HL,(L4640)           ;2442 2A4046                                                                       
                 LD    BC,L0005             ;2445 010500                                                                       
L2448:           LD    A,(HL)               ;2448 7E                                                                           
                 CP    E                    ;2449 BB                                                                           
                 INC   HL                   ;244A 23                                                                           
                 JR    NZ,L2452             ;244B 2005                                                                         
                 LD    A,(HL)               ;244D 7E                                                                           
                 CP    D                    ;244E BA                                                                           
                 JP    Z,L2471              ;244F CA7124                                                                       
L2452:           OR    A                    ;2452 B7                                                                           
                 JR    Z,L245A              ;2453 2805                                                                         
                 INC   HL                   ;2455 23                                                                           
                 ADD   HL,BC                ;2456 09                                                                           
                 JP    L2448                ;2457 C34824                                                                       

L245A:           LD    C,7                  ;245A 0E07                                                                         
                 DEC   HL                   ;245C 2B                                                                           
                 PUSH  DE                   ;245D D5                                                                           
                 EX    DE,HL                ;245E EB                                                                           
                 LD    HL,L1619             ;245F 211916                                                                       
                 DEC   HL                   ;2462 2B                                                                           
                 DEC   HL                   ;2463 2B                                                                           
                 CALL  L1796                ;2464 CD9617                                                                       
                 CALL  L189C                ;2467 CD9C18                                                                       
                 EX    DE,HL                ;246A EB                                                                           
                 POP   DE                   ;246B D1                                                                           
                 LD    (HL),E               ;246C 73                                                                           
                 INC   HL                   ;246D 23                                                                           
                 LD    (HL),D               ;246E 72                                                                           
                 LD    C,5                  ;246F 0E05                                                                         
L2471:           INC   HL                   ;2471 23                                                                           
                 EX    DE,HL                ;2472 EB                                                                           
                 POP   HL                   ;2473 E1                                                                           
                 LD    A,(HL)               ;2474 7E                                                                           
                 RET                        ;2475 C9                                                                           

L2476:           LD    A,(HL)               ;2476 7E                                                                           
                 SUB   65                   ;2477 D641                                                                         
                 CP    26                   ;2479 FE1A                                                                         
                 JP    NC,L138E             ;247B D28E13                                                                       
                 LD    E,(HL)               ;247E 5E                                                                           
                 INC   HL                   ;247F 23                                                                           
                 CALL  L169A                ;2480 CD9A16                                                                       
                 JR    Z,L245A              ;2483 28D5                                                                         
                 CALL  L22AF                ;2485 CDAF22                                                                       
                 CALL  L1814                ;2488 CD1418                                                                       
                 CALL  L169A                ;248B CD9A16                                                                       
                 ADD   HL,HL                ;248E 29                                                                           
                 POP   DE                   ;248F D1                                                                           
                 PUSH  HL                   ;2490 E5                                                                           
                 LD    HL,(L4634)           ;2491 2A3446                                                                       
L2494:           LD    A,(HL)               ;2494 7E                                                                           
                 CP    0                    ;2495 FE00                                                                         
                 JP    Z,L138E              ;2497 CA8E13                                                                       
                 CP    E                    ;249A BB                                                                           
                 JR    Z,L24A4              ;249B 2807                                                                         
                 INC   HL                   ;249D 23                                                                           
                 INC   HL                   ;249E 23                                                                           
                 CALL  L1633                ;249F CD3316                                                                       
                 JR    L2494                ;24A2 18F0                                                                         

L24A4:           INC   HL                   ;24A4 23                                                                           
                 LD    E,(HL)               ;24A5 5E                                                                           
                 INC   HL                   ;24A6 23                                                                           
                 PUSH  HL                   ;24A7 E5                                                                           
                 PUSH  DE                   ;24A8 D5                                                                           
                 LD    D,32                 ;24A9 1620                                                                         
                 CALL  L2441                ;24AB CD4124                                                                       
                 POP   HL                   ;24AE E1                                                                           
                 PUSH  DE                   ;24AF D5                                                                           
                 PUSH  HL                   ;24B0 E5                                                                           
                 LD    HL,(L4646)           ;24B1 2A4646                                                                       
                 LD    DE,L464C             ;24B4 114C46                                                                       
                 CALL  L1662                ;24B7 CD6216                                                                       
                 JP    Z,L13AC              ;24BA CAAC13                                                                       
                 LD    BC,LFFFA             ;24BD 01FAFF                                                                       
                 ADD   HL,BC                ;24C0 09                                                                           
                 LD    (L4646),HL           ;24C1 224646                                                                       
                 POP   DE                   ;24C4 D1                                                                           
                 LD    (HL),E               ;24C5 73                                                                           
                 INC   HL                   ;24C6 23                                                                           
                 POP   DE                   ;24C7 D1                                                                           
                 LD    BC,L0005             ;24C8 010500                                                                       
                 EX    DE,HL                ;24CB EB                                                                           
                 CALL  L1799                ;24CC CD9917                                                                       
                 EX    DE,HL                ;24CF EB                                                                           
                 LD    HL,(L4644)           ;24D0 2A4446                                                                       
                 CALL  L1799                ;24D3 CD9917                                                                       
                 POP   HL                   ;24D6 E1                                                                           
                 CALL  L22AF                ;24D7 CDAF22                                                                       
                 CALL  L1814                ;24DA CD1418                                                                       
                 CALL  L1829                ;24DD CD2918                                                                       
                 JP    NZ,L138E             ;24E0 C28E13                                                                       
                 LD    HL,(L4646)           ;24E3 2A4646                                                                       
                 LD    E,(HL)               ;24E6 5E                                                                           
                 INC   HL                   ;24E7 23                                                                           
                 LD    D,32                 ;24E8 1620                                                                         
                 CALL  L2441                ;24EA CD4124                                                                       
                 CALL  L1799                ;24ED CD9917                                                                       
                 ADD   HL,BC                ;24F0 09                                                                           
                 LD    (L4646),HL           ;24F1 224646                                                                       
                 JP    L237A                ;24F4 C37A23                                                                       

L24F7:           CALL  L162C                ;24F7 CD2C16                                                                       
                 CP    40                   ;24FA FE28                                                                         
                 JP    Z,L2580              ;24FC CA8025                                                                       
                 PUSH  HL                   ;24FF E5                                                                           
                 LD    HL,L4954             ;2500 215449                                                                       
                 XOR   A                    ;2503 AF                                                                           
                 SBC   HL,DE                ;2504 ED52                                                                         
                 JP    Z,L2539              ;2506 CA3925                                                                       
                 EX    DE,HL                ;2509 EB                                                                           
                 LD    (L4630),HL           ;250A 223046                                                                       
                 LD    HL,(L463A)           ;250D 2A3A46                                                                       
L2510:           CALL  L17C4                ;2510 CDC417                                                                       
                 LD    E,37                 ;2513 1E25                                                                         
                 JP    Z,L2530              ;2515 CA3025                                                                       
                 CALL  L1633                ;2518 CD3316                                                                       
                 JP    L2510                ;251B C31025                                                                       

                 DB    01H,03H,00H,0EBH     ;251E 010300EB  Link 251E found at , $2513                                         
                 DB    21H,30H,46H,0CDH     ;2522 213046CD                                                                     
                 DB    96H,17H,0CDH,9CH     ;2526 9617CD9C                                                                     
                 DB    18H,0EBH,23H,23H     ;252A 18EB2323                                                                     
                 DB    36H,0DH              ;252E 360D                                                                         
L2530:           CALL  L17F3                ;2530 CDF317                                                                       
                 EX    DE,HL                ;2533 EB                                                                           
                 LD    B,1                  ;2534 0601                                                                         
                 POP   HL                   ;2536 E1                                                                           
                 LD    A,(HL)               ;2537 7E                                                                           
                 RET                        ;2538 C9                                                                           

L2539:           CALL  READTIME             ;2539 CD3B00                                                                       
                 EX    DE,HL                ;253C EB                                                                           
                 OR    A                    ;253D B7                                                                           
                 JR    Z,L2542              ;253E 2802                                                                         
                 LD    A,12                 ;2540 3E0C                                                                         
L2542:           EXX                        ;2542 D9                                                                           
                 LD    HL,L4559             ;2543 215945                                                                       
                 PUSH  HL                   ;2546 E5                                                                           
                 EXX                        ;2547 D9                                                                           
                 LD    DE,LF1F0             ;2548 11F0F1                                                                       
                 CALL  L2560                ;254B CD6025                                                                       
                 LD    DE,LFFC4             ;254E 11C4FF                                                                       
                 CALL  L255F                ;2551 CD5F25                                                                       
                 LD    A,L                  ;2554 7D                                                                           
                 CALL  L2569                ;2555 CD6925                                                                       
                 POP   DE                   ;2558 D1                                                                           
                 LD    BC,L0106             ;2559 010601                                                                       
                 POP   HL                   ;255C E1                                                                           
                 LD    A,(HL)               ;255D 7E                                                                           
                 RET                        ;255E C9                                                                           

L255F:           XOR   A                    ;255F AF                                                                           
L2560:           ADD   HL,DE                ;2560 19                                                                           
                 JR    NC,L2566             ;2561 3003                                                                         
                 INC   A                    ;2563 3C                                                                           
                 JR    L2560                ;2564 18FA                                                                         

L2566:           OR    A                    ;2566 B7                                                                           
                 SBC   HL,DE                ;2567 ED52                                                                         
L2569:           LD    BC,L30F6             ;2569 01F630                                                                       
L256C:           ADD   A,C                  ;256C 81                                                                           
                 JR    NC,L2572             ;256D 3003                                                                         
                 INC   B                    ;256F 04                                                                           
                 JR    L256C                ;2570 18FA                                                                         

L2572:           ADD   A,58                 ;2572 C63A                                                                         
                 EX    AF,AF'               ;2574 08                                                                           
                 LD    A,B                  ;2575 78                                                                           
                 EXX                        ;2576 D9                                                                           
                 LD    (HL),A               ;2577 77                                                                           
                 INC   HL                   ;2578 23                                                                           
                 EX    AF,AF'               ;2579 08                                                                           
                 LD    (HL),A               ;257A 77                                                                           
                 INC   HL                   ;257B 23                                                                           
                 LD    (HL),13              ;257C 360D                                                                         
                 EXX                        ;257E D9                                                                           
                 RET                        ;257F C9                                                                           

L2580:           LD    BC,L0100             ;2580 010001                                                                       
                 JR    L2588                ;2583 1803                                                                         

L2585:           LD    BC,COLDSTART         ;2585 010000                                                                       
L2588:           INC   HL                   ;2588 23                                                                           
                 CALL  L20D9                ;2589 CDD920                                                                       
                 JP    Z,L138E              ;258C CA8E13                                                                       
                 PUSH  HL                   ;258F E5                                                                           
                 LD    L,C                  ;2590 69                                                                           
                 LD    H,0                  ;2591 2600                                                                         
                 LD    C,E                  ;2593 4B                                                                           
                 LD    E,D                  ;2594 5A                                                                           
                 LD    B,H                  ;2595 44                                                                           
                 LD    D,H                  ;2596 54                                                                           
                 PUSH  BC                   ;2597 C5                                                                           
                 INC   HL                   ;2598 23                                                                           
                 CALL  L16C8                ;2599 CDC816                                                                       
                 POP   HL                   ;259C E1                                                                           
                 ADD   HL,DE                ;259D 19                                                                           
                 EX    DE,HL                ;259E EB                                                                           
                 LD    A,(L20D6)            ;259F 3AD620                                                                       
                 OR    A                    ;25A2 B7                                                                           
                 JP    NZ,L25B5             ;25A3 C2B525                                                                       
                 LD    HL,L0005             ;25A6 210500                                                                       
                 CALL  L16C8                ;25A9 CDC816                                                                       
                 POP   HL                   ;25AC E1                                                                           
                 ADD   HL,DE                ;25AD 19                                                                           
                 EX    DE,HL                ;25AE EB                                                                           
                 LD    BC,L0005             ;25AF 010500                                                                       
                 JP    L25C7                ;25B2 C3C725                                                                       

L25B5:           POP   HL                   ;25B5 E1                                                                           
L25B6:           LD    A,D                  ;25B6 7A                                                                           
                 OR    E                    ;25B7 B3                                                                           
                 JP    Z,L25C1              ;25B8 CAC125                                                                       
                 DEC   DE                   ;25BB 1B                                                                           
                 CALL  L1633                ;25BC CD3316                                                                       
                 JR    L25B6                ;25BF 18F5                                                                         

L25C1:           CALL  L17F3                ;25C1 CDF317                                                                       
                 EX    DE,HL                ;25C4 EB                                                                           
                 LD    B,1                  ;25C5 0601                                                                         
L25C7:           LD    HL,(L20D4)           ;25C7 2AD420                                                                       
                 LD    A,(HL)               ;25CA 7E                                                                           
                 RET                        ;25CB C9                                                                           

L25CC:           INC   HL                   ;25CC 23                                                                           
L25CD:           LD    A,(HL)               ;25CD 7E                                                                           
                 CP    32                   ;25CE FE20                                                                         
                 JR    Z,L25CC              ;25D0 28FA                                                                         
                 SUB   65                   ;25D2 D641                                                                         
                 CP    26                   ;25D4 FE1A                                                                         
                 LD    A,(HL)               ;25D6 7E                                                                           
                 RET   NC                   ;25D7 D0                                                                           
                 LD    E,(HL)               ;25D8 5E                                                                           
                 LD    D,32                 ;25D9 1620                                                                         
L25DB:           INC   HL                   ;25DB 23                                                                           
                 LD    A,(HL)               ;25DC 7E                                                                           
                 CP    D                    ;25DD BA                                                                           
                 JR    Z,L25DB              ;25DE 28FB                                                                         
                 SUB   48                   ;25E0 D630                                                                         
                 CP    10                   ;25E2 FE0A                                                                         
                 JR    C,L25ED              ;25E4 3807                                                                         
                 SUB   17                   ;25E6 D611                                                                         
                 CP    26                   ;25E8 FE1A                                                                         
                 LD    A,(HL)               ;25EA 7E                                                                           
                 CCF                        ;25EB 3F                                                                           
                 RET   C                    ;25EC D8                                                                           
L25ED:           LD    D,(HL)               ;25ED 56                                                                           
                 LD    A,70                 ;25EE 3E46                                                                         
                 CP    E                    ;25F0 BB                                                                           
                 JR    NZ,L25F9             ;25F1 2006                                                                         
                 LD    A,78                 ;25F3 3E4E                                                                         
                 CP    D                    ;25F5 BA                                                                           
                 JP    Z,L260E              ;25F6 CA0E26                                                                       
L25F9:           INC   HL                   ;25F9 23                                                                           
                 LD    A,(HL)               ;25FA 7E                                                                           
                 CP    32                   ;25FB FE20                                                                         
                 JR    Z,L25F9              ;25FD 28FA                                                                         
                 SUB   48                   ;25FF D630                                                                         
                 CP    10                   ;2601 FE0A                                                                         
                 JR    C,L25F9              ;2603 38F4                                                                         
                 SUB   17                   ;2605 D611                                                                         
                 CP    26                   ;2607 FE1A                                                                         
                 JR    C,L25F9              ;2609 38EE                                                                         
L260B:           LD    A,(HL)               ;260B 7E                                                                           
                 SCF                        ;260C 37                                                                           
                 RET                        ;260D C9                                                                           

L260E:           CALL  L162C                ;260E CD2C16                                                                       
                 SCF                        ;2611 37                                                                           
                 RET                        ;2612 C9                                                                           

L2613:           CALL  L25CD                ;2613 CDCD25                                                                       
                 JP    NC,L138E             ;2616 D28E13                                                                       
                 LD    A,70                 ;2619 3E46                                                                         
                 CP    E                    ;261B BB                                                                           
                 JP    NZ,L260B             ;261C C20B26                                                                       
                 LD    A,78                 ;261F 3E4E                                                                         
                 CP    D                    ;2621 BA                                                                           
                 JP    NZ,L260B             ;2622 C20B26                                                                       
                 JP    L138E                ;2625 C38E13                                                                       

L2628:           DW    L34F1                ;2628 F134                                                                         
                 DW    L34F1                ;262A F134                                                                         
                 DW    L351C                ;262C 1C35                                                                         
                 DW    L351C                ;262E 1C35                                                                         
                 DW    L3520                ;2630 2035                                                                         
                 DW    L3520                ;2632 2035                                                                         
                 DW    L3512                ;2634 1235                                                                         
                 DW    L3504                ;2636 0435                                                                         
                 DW    L3508                ;2638 0835                                                                         
                 DW    L270B                ;263A 0B27                                                                         
                 DW    L270E                ;263C 0E27                                                                         
                 DW    L2711                ;263E 1127                                                                         
                 DW    L2D4D                ;2640 4D2D                                                                         
                 DW    L2D4A                ;2642 4A2D                                                                         
                 DW    L2E59                ;2644 592E                                                                         
                 DW    L2F30                ;2646 302F                                                                         
                 DW    L3B0B                ;2648 0B3B                                                                         
L264A:           DW    L267A                ;264A 7A26                                                                         
                 DW    L26AC                ;264C AC26                                                                         
                 DW    L26D0                ;264E D026                                                                         
                 DW    L2714                ;2650 1427                                                                         
                 DW    L2723                ;2652 2327                                                                         
                 DW    L273D                ;2654 3D27                                                                         
                 DW    L2776                ;2656 7627                                                                         
                 DW    L2759                ;2658 5927                                                                         
                 DW    L27B8                ;265A B827                                                                         
                 DW    L27D9                ;265C D927                                                                         
                 DW    L2801                ;265E 0128                                                                         
                 DW    L2827                ;2660 2728                                                                         
L2662:           DW    L352F                ;2662 2F35                                                                         
                 DW    L35B0                ;2664 B035                                                                         
                 DW    L36A2                ;2666 A236                                                                         
                 DW    L36B1                ;2668 B136                                                                         
                 DW    L3A25                ;266A 253A                                                                         
                 DW    L37A6                ;266C A637                                                                         
                 DW    L340E                ;266E 0E34                                                                         
                 DW    L3A13                ;2670 133A                                                                         
                 DW    L38DF                ;2672 DF38                                                                         
                 DW    L2839                ;2674 3928                                                                         
                 DW    L283E                ;2676 3E28                                                                         
                 DW    L36DC                ;2678 DC36                                                                         
L267A:           CALL  L22AF                ;267A CDAF22                                                                       
                 CALL  L180F                ;267D CD0F18                                                                       
                 PUSH  DE                   ;2680 D5                                                                           
                 PUSH  BC                   ;2681 C5                                                                           
L2682:           CALL  L169A                ;2682 CD9A16                                                                       
                 INC   L                    ;2685 2C                                                                           
                 CALL  L19A9                ;2686 CDA919                                                                       
                 CALL  L169A                ;2689 CD9A16                                                                       
                 ADD   HL,HL                ;268C 29                                                                           
                 POP   BC                   ;268D C1                                                                           
                 EX    (SP),HL              ;268E E3                                                                           
                 EX    DE,HL                ;268F EB                                                                           
                 LD    A,C                  ;2690 79                                                                           
                 SUB   L                    ;2691 95                                                                           
                 JP    C,L26A8              ;2692 DAA826                                                                       
                 PUSH  HL                   ;2695 E5                                                                           
                 LD    C,A                  ;2696 4F                                                                           
                 PUSH  DE                   ;2697 D5                                                                           
                 CALL  L1801                ;2698 CD0118                                                                       
                 ADD   HL,DE                ;269B 19                                                                           
                 EX    DE,HL                ;269C EB                                                                           
L269D:           CALL  L1766                ;269D CD6617                                                                       
                 CALL  L1651                ;26A0 CD5116                                                                       
                 CALL  L189C                ;26A3 CD9C18                                                                       
                 POP   DE                   ;26A6 D1                                                                           
                 POP   BC                   ;26A7 C1                                                                           
L26A8:           POP   HL                   ;26A8 E1                                                                           
                 JP    L162D                ;26A9 C32D16                                                                       

L26AC:           CALL  L22AF                ;26AC CDAF22                                                                       
                 CALL  L180F                ;26AF CD0F18                                                                       
                 PUSH  DE                   ;26B2 D5                                                                           
                 PUSH  BC                   ;26B3 C5                                                                           
                 CALL  L169A                ;26B4 CD9A16                                                                       
                 INC   L                    ;26B7 2C                                                                           
                 CALL  L19A9                ;26B8 CDA919                                                                       
                 CALL  L169A                ;26BB CD9A16                                                                       
                 ADD   HL,HL                ;26BE 29                                                                           
                 POP   BC                   ;26BF C1                                                                           
                 EX    (SP),HL              ;26C0 E3                                                                           
                 EX    DE,HL                ;26C1 EB                                                                           
                 LD    A,C                  ;26C2 79                                                                           
                 SUB   L                    ;26C3 95                                                                           
                 JP    C,L26A8              ;26C4 DAA826                                                                       
                 PUSH  HL                   ;26C7 E5                                                                           
                 LD    C,A                  ;26C8 4F                                                                           
                 PUSH  DE                   ;26C9 D5                                                                           
                 CALL  L1801                ;26CA CD0118                                                                       
                 JP    L269D                ;26CD C39D26                                                                       

L26D0:           CALL  L22AF                ;26D0 CDAF22                                                                       
                 CALL  L180F                ;26D3 CD0F18                                                                       
                 PUSH  DE                   ;26D6 D5                                                                           
                 PUSH  BC                   ;26D7 C5                                                                           
                 CALL  L169A                ;26D8 CD9A16                                                                       
                 INC   L                    ;26DB 2C                                                                           
                 CALL  L19A9                ;26DC CDA919                                                                       
                 LD    A,E                  ;26DF 7B                                                                           
                 DEC   A                    ;26E0 3D                                                                           
                 JP    Z,L2708              ;26E1 CA0827                                                                       
                 JP    C,L2708              ;26E4 DA0827                                                                       
                 POP   BC                   ;26E7 C1                                                                           
                 LD    E,A                  ;26E8 5F                                                                           
                 LD    A,C                  ;26E9 79                                                                           
                 SUB   E                    ;26EA 93                                                                           
                 JP    NC,L26F0             ;26EB D2F026                                                                       
                 XOR   A                    ;26EE AF                                                                           
                 LD    E,C                  ;26EF 59                                                                           
L26F0:           LD    C,E                  ;26F0 4B                                                                           
                 LD    B,D                  ;26F1 42                                                                           
                 POP   DE                   ;26F2 D1                                                                           
                 PUSH  DE                   ;26F3 D5                                                                           
                 PUSH  AF                   ;26F4 F5                                                                           
                 PUSH  BC                   ;26F5 C5                                                                           
                 CALL  L1801                ;26F6 CD0118                                                                       
                 POP   BC                   ;26F9 C1                                                                           
                 CALL  L1766                ;26FA CD6617                                                                       
                 CALL  L1651                ;26FD CD5116                                                                       
                 CALL  L189C                ;2700 CD9C18                                                                       
                 POP   AF                   ;2703 F1                                                                           
                 LD    C,A                  ;2704 4F                                                                           
                 LD    B,0                  ;2705 0600                                                                         
                 PUSH  BC                   ;2707 C5                                                                           
L2708:           JP    L2682                ;2708 C38226                                                                       

L270B:           JP    L138E                ;270B C38E13                                                                       

L270E:           JP    L138E                ;270E C38E13                                                                       

L2711:           JP    L138E                ;2711 C38E13                                                                       

L2714:           CALL  L22AF                ;2714 CDAF22                                                                       
                 CALL  L180F                ;2717 CD0F18                                                                       
                 CALL  L169A                ;271A CD9A16                                                                       
                 ADD   HL,HL                ;271D 29                                                                           
                 PUSH  HL                   ;271E E5                                                                           
                 LD    A,C                  ;271F 79                                                                           
                 JP    L278A                ;2720 C38A27                                                                       

L2723:           CALL  L19A9                ;2723 CDA919                                                                       
                 CALL  L169A                ;2726 CD9A16                                                                       
                 ADD   HL,HL                ;2729 29                                                                           
                 PUSH  HL                   ;272A E5                                                                           
                 LD    A,E                  ;272B 7B                                                                           
                 CP    32                   ;272C FE20                                                                         
                 JR    NC,L2732             ;272E 3002                                                                         
                 LD    E,13                 ;2730 1E0D                                                                         
L2732:           LD    HL,L4400             ;2732 210044                                                                       
                 PUSH  HL                   ;2735 E5                                                                           
                 LD    (HL),E               ;2736 73                                                                           
                 INC   HL                   ;2737 23                                                                           
                 LD    (HL),13              ;2738 360D                                                                         
                 JP    L2752                ;273A C35227                                                                       

L273D:           CALL  L22AF                ;273D CDAF22                                                                       
                 CALL  L1814                ;2740 CD1418                                                                       
                 CALL  L169A                ;2743 CD9A16                                                                       
                 ADD   HL,HL                ;2746 29                                                                           
                 PUSH  HL                   ;2747 E5                                                                           
                 LD    HL,(L4644)           ;2748 2A4446                                                                       
                 LD    DE,L4400             ;274B 110044                                                                       
                 PUSH  DE                   ;274E D5                                                                           
                 CALL  L322D                ;274F CD2D32                                                                       
L2752:           POP   HL                   ;2752 E1                                                                           
                 CALL  L18C4                ;2753 CDC418                                                                       
                 POP   HL                   ;2756 E1                                                                           
                 LD    A,(HL)               ;2757 7E                                                                           
                 RET                        ;2758 C9                                                                           

L2759:           CALL  L22AF                ;2759 CDAF22                                                                       
                 CALL  L180F                ;275C CD0F18                                                                       
                 CALL  L169A                ;275F CD9A16                                                                       
                 ADD   HL,HL                ;2762 29                                                                           
                 PUSH  HL                   ;2763 E5                                                                           
                 CALL  L1801                ;2764 CD0118                                                                       
                 EX    DE,HL                ;2767 EB                                                                           
                 CALL  L190D                ;2768 CD0D19                                                                       
                 LD    (HL),B               ;276B 70                                                                           
                 DAA                        ;276C 27                                                                           
                 JP    L26A8                ;276D C3A826                                                                       

                 DB    11H,19H,16H,0C3H     ;2770 111916C3  Link 2770 found at , $276B                                         
                 DB    77H,23H              ;2774 7723                                                                         
L2776:           CALL  L22AF                ;2776 CDAF22                                                                       
                 CALL  L180F                ;2779 CD0F18                                                                       
                 CALL  L169A                ;277C CD9A16                                                                       
                 ADD   HL,HL                ;277F 29                                                                           
                 PUSH  HL                   ;2780 E5                                                                           
                 CALL  L1801                ;2781 CD0118                                                                       
                 LD    A,(DE)               ;2784 1A                                                                           
                 CP    13                   ;2785 FE0D                                                                         
                 JP    Z,L1398              ;2787 CA9813                                                                       
L278A:           OR    A                    ;278A B7                                                                           
                 LD    BC,L8000             ;278B 010080                                                                       
                 CALL  NZ,L27A6             ;278E C4A627                                                                       
                 LD    HL,(L4644)           ;2791 2A4446                                                                       
                 LD    DE,USER              ;2794 110300                                                                       
                 LD    (HL),B               ;2797 70                                                                           
                 INC   HL                   ;2798 23                                                                           
L2799:           LD    (HL),D               ;2799 72                                                                           
                 INC   HL                   ;279A 23                                                                           
                 DEC   E                    ;279B 1D                                                                           
                 JR    NZ,L2799             ;279C 20FB                                                                         
                 LD    (HL),C               ;279E 71                                                                           
                 LD    BC,L0005             ;279F 010500                                                                       
                 POP   HL                   ;27A2 E1                                                                           
                 JP    L162D                ;27A3 C32D16                                                                       

L27A6:           LD    E,8                  ;27A6 1E08                                                                         
L27A8:           OR    A                    ;27A8 B7                                                                           
                 JP    M,L27B1              ;27A9 FAB127                                                                       
                 RLA                        ;27AC 17                                                                           
                 DEC   E                    ;27AD 1D                                                                           
                 JP    L27A8                ;27AE C3A827                                                                       

L27B1:           LD    C,A                  ;27B1 4F                                                                           
                 LD    A,192                ;27B2 3EC0                                                                         
                 ADD   A,E                  ;27B4 83                                                                           
                 LD    B,A                  ;27B5 47                                                                           
                 RET                        ;27B6 C9                                                                           

L27B7:           DB    00H                  ;27B7 00                                                                           
L27B8:           CALL  L198C                ;27B8 CD8C19                                                                       
                 CALL  L169A                ;27BB CD9A16                                                                       
                 ADD   HL,HL                ;27BE 29                                                                           
                 PUSH  HL                   ;27BF E5                                                                           
                 LD    A,(L27B7)            ;27C0 3AB727                                                                       
                 OR    A                    ;27C3 B7                                                                           
                 JP    NZ,L27D1             ;27C4 C2D127                                                                       
                 LD    HL,(04563H)          ;27C7 2A6345                                                                       
                 DEC   HL                   ;27CA 2B                                                                           
                 CALL  L1662                ;27CB CD6216                                                                       
                 JP    NC,L27D4             ;27CE D2D427                                                                       
L27D1:           LD    A,(DE)               ;27D1 1A                                                                           
                 JR    L27D6                ;27D2 1802                                                                         

L27D4:           LD    A,32                 ;27D4 3E20                                                                         
L27D6:           JP    L278A                ;27D6 C38A27                                                                       

L27D9:           CALL  L19A9                ;27D9 CDA919                                                                       
                 LD    B,19                 ;27DC 0613                                                                         
                 CALL  L169A                ;27DE CD9A16                                                                       
                 ADD   HL,HL                ;27E1 29                                                                           
                 LD    A,39                 ;27E2 3E27                                                                         
                 ADD   A,A                  ;27E4 87                                                                           
                 SUB   E                    ;27E5 93                                                                           
                 JP    C,L1398              ;27E6 DA9813                                                                       
                 LD    A,(L457D)            ;27E9 3A7D45                                                                       
                 OR    A                    ;27EC B7                                                                           
                 LD    A,(CHARCOUNT)        ;27ED 3A9411                                                                       
                 JR    Z,L27F7              ;27F0 2805                                                                         
                 LD    B,32                 ;27F2 0620                                                                         
                 LD    A,(L3D26)            ;27F4 3A263D                                                                       
L27F7:           LD    D,A                  ;27F7 57                                                                           
                 LD    A,E                  ;27F8 7B                                                                           
                 SUB   D                    ;27F9 92                                                                           
                 JP    NC,L27FE             ;27FA D2FE27                                                                       
                 XOR   A                    ;27FD AF                                                                           
L27FE:           JP    L280B                ;27FE C30B28                                                                       

L2801:           CALL  L19A9                ;2801 CDA919                                                                       
                 LD    B,32                 ;2804 0620                                                                         
                 CALL  L169A                ;2806 CD9A16                                                                       
                 ADD   HL,HL                ;2809 29                                                                           
                 LD    A,E                  ;280A 7B                                                                           
L280B:           PUSH  HL                   ;280B E5                                                                           
                 LD    HL,L4400             ;280C 210044                                                                       
                 PUSH  HL                   ;280F E5                                                                           
                 LD    C,A                  ;2810 4F                                                                           
L2811:           OR    A                    ;2811 B7                                                                           
                 JP    Z,L281B              ;2812 CA1B28                                                                       
                 LD    (HL),B               ;2815 70                                                                           
                 INC   HL                   ;2816 23                                                                           
                 DEC   A                    ;2817 3D                                                                           
                 JP    L2811                ;2818 C31128                                                                       

L281B:           LD    (HL),13              ;281B 360D                                                                         
                 LD    B,0                  ;281D 0600                                                                         
                 POP   HL                   ;281F E1                                                                           
                 CALL  L18DF                ;2820 CDDF18                                                                       
                 POP   HL                   ;2823 E1                                                                           
                 JP    L162D                ;2824 C32D16                                                                       

L2827:           PUSH  HL                   ;2827 E5                                                                           
                 CALL  L173C                ;2828 CD3C17                                                                       
                 LD    DE,L4400             ;282B 110044                                                                       
                 PUSH  DE                   ;282E D5                                                                           
                 CALL  L16F7                ;282F CDF716                                                                       
                 POP   HL                   ;2832 E1                                                                           
                 CALL  L22AF                ;2833 CDAF22                                                                       
                 POP   HL                   ;2836 E1                                                                           
                 LD    A,(HL)               ;2837 7E                                                                           
                 RET                        ;2838 C9                                                                           

L2839:           LD    A,(DE)               ;2839 1A                                                                           
                 OR    128                  ;283A F680                                                                         
                 LD    (DE),A               ;283C 12                                                                           
                 RET                        ;283D C9                                                                           

L283E:           LD    A,(DE)               ;283E 1A                                                                           
                 LD    DE,L161E             ;283F 111E16                                                                       
                 OR    A                    ;2842 B7                                                                           
                 JP    P,L2851              ;2843 F25128                                                                       
                 LD    DE,L1614             ;2846 111416                                                                       
                 CP    128                  ;2849 FE80                                                                         
                 JP    NZ,L2851             ;284B C25128                                                                       
                 LD    DE,L1619             ;284E 111916                                                                       
L2851:           JP    L181A                ;2851 C31A18                                                                       

L2854:           JP    COLDSTART            ;2854 C30000                                                                       

L2857:           CALL  L2613                ;2857 CD1326                                                                       
                 CALL  L2436                ;285A CD3624                                                                       
                 LD    (L4801),HL           ;285D 220148                                                                       
                 CALL  L197B                ;2860 CD7B19                                                                       
                 CALL  KEYBOARD             ;2863 CD1B00                                                                       
                 CP    27                   ;2866 FE1B                                                                         
                 JP    Z,L124B              ;2868 CA4B12                                                                       
                 LD    HL,L45A2             ;286B 21A245                                                                       
                 OR    A                    ;286E B7                                                                           
                 JP    NZ,L28A3             ;286F C2A328                                                                       
                 LD    (L45A4),A            ;2872 32A445                                                                       
L2875:           LD    A,(L4571)            ;2875 3A7145                                                                       
                 LD    B,48                 ;2878 0630                                                                         
                 OR    A                    ;287A B7                                                                           
                 JP    Z,L2880              ;287B CA8028                                                                       
                 LD    B,13                 ;287E 060D                                                                         
L2880:           LD    (HL),B               ;2880 70                                                                           
                 INC   HL                   ;2881 23                                                                           
                 LD    (HL),13              ;2882 360D                                                                         
                 DEC   HL                   ;2884 2B                                                                           
                 CALL  L18C7                ;2885 CDC718                                                                       
                 LD    A,(L4571)            ;2888 3A7145                                                                       
                 OR    A                    ;288B B7                                                                           
                 JP    NZ,L2898             ;288C C29828                                                                       
                 CALL  L1801                ;288F CD0118                                                                       
                 EX    DE,HL                ;2892 EB                                                                           
                 CALL  L190D                ;2893 CD0D19                                                                       
L2896:           OR    D                    ;2896 B2                                                                           
                 ADD   HL,DE                ;2897 19                                                                           
L2898:           CALL  L1976                ;2898 CD7619                                                                       
                 CALL  L1B6A                ;289B CD6A1B                                                                       
                 SBC   A,L                  ;289E 9D                                                                           
                 INC   DE                   ;289F 13                                                                           
                 JP    L19B2                ;28A0 C3B219                                                                       

L28A3:           LD    B,A                  ;28A3 47                                                                           
                 LD    A,(L45A4)            ;28A4 3AA445                                                                       
                 CP    B                    ;28A7 B8                                                                           
                 JP    Z,L2875              ;28A8 CA7528                                                                       
                 LD    A,B                  ;28AB 78                                                                           
                 LD    (L45A4),A            ;28AC 32A445                                                                       
                 JP    L2880                ;28AF C38028                                                                       

L28B2:           CALL  L198C                ;28B2 CD8C19                                                                       
                 CALL  L169A                ;28B5 CD9A16                                                                       
                 ADD   HL,HL                ;28B8 29                                                                           
                 LD    (L4801),HL           ;28B9 220148                                                                       
                 LD    HL,L19B2             ;28BC 21B219                                                                       
                 PUSH  HL                   ;28BF E5                                                                           
                 EX    DE,HL                ;28C0 EB                                                                           
                 JP    (HL)                 ;28C1 E9                                                                           

L28C2:           CALL  L168B                ;28C2 CD8B16                                                                       
                 LD    C,L                  ;28C5 4D                                                                           
                 RET   C                    ;28C6 D8                                                                           
                 JR    Z,L2896              ;28C7 28CD                                                                         
                 SBC   A,D                  ;28C9 9A                                                                           
                 LD    D,65                 ;28CA 1641                                                                         
                 CALL  L169A                ;28CC CD9A16                                                                       
                 LD    E,B                  ;28CF 58                                                                           
                 LD    (L4801),HL           ;28D0 220148                                                                       
                 LD    HL,(04561H)          ;28D3 2A6145                                                                       
                 JR    L28F5                ;28D6 181D                                                                         

                 DB    0CDH,8CH,19H,22H     ;28D8 CD8C1922  Link 28D8 found at , $28C6                                         
                 DB    01H,48H,2AH,61H      ;28DC 01482A61                                                                     
                 DB    45H,0CDH,62H,16H     ;28E0 45CD6216                                                                     
                 DB    0DAH,93H,13H,2AH     ;28E4 DA93132A                                                                     
                 DB    44H,46H,01H,0C8H     ;28E8 444601C8                                                                     
                 DB    00H,09H,0CDH,62H     ;28EC 0009CD62                                                                     
                 DB    16H,0D2H,93H,13H     ;28F0 16D29313                                                                     
                 DB    0EBH                 ;28F4 EB                                                                           
L28F5:           LD    (04563H),HL          ;28F5 226345                                                                       
                 LD    SP,HL                ;28F8 F9                                                                           
                 JP    L19B2                ;28F9 C3B219                                                                       

L28FC:           LD    HL,(L47FF)           ;28FC 2AFF47                                                                       
                 LD    A,L                  ;28FF 7D                                                                           
                 OR    H                    ;2900 B4                                                                           
                 JP    NZ,L13BB             ;2901 C2BB13                                                                       
                 LD    A,(L4565)            ;2904 3A6545                                                                       
                 OR    A                    ;2907 B7                                                                           
                 JP    Z,L13BB              ;2908 CABB13                                                                       
                 PUSH  AF                   ;290B F5                                                                           
                 CALL  L13C1                ;290C CDC113                                                                       
                 LD    BC,CRLF2             ;290F 010600                                                                       
                 LD    DE,L47FD             ;2912 11FD47                                                                       
                 LD    HL,L4566             ;2915 216645                                                                       
                 CALL  L1799                ;2918 CD9917                                                                       
                 POP   AF                   ;291B F1                                                                           
                 LD    HL,(L4801)           ;291C 2A0148                                                                       
                 OR    A                    ;291F B7                                                                           
                 JP    M,L1E7C              ;2920 FA7C1E                                                                       
                 DEC   A                    ;2923 3D                                                                           
                 JP    Z,L19B2              ;2924 CAB219                                                                       
                 JP    L19E1                ;2927 C3E119                                                                       

L292A:           LD    A,1                  ;292A 3E01                                                                         
                 JR    L292F                ;292C 1801                                                                         

L292E:           XOR   A                    ;292E AF                                                                           
L292F:           PUSH  AF                   ;292F F5                                                                           
                 CALL  L19A9                ;2930 CDA919                                                                       
                 PUSH  DE                   ;2933 D5                                                                           
                 CALL  L169A                ;2934 CD9A16                                                                       
                 INC   L                    ;2937 2C                                                                           
                 CALL  L19A9                ;2938 CDA919                                                                       
                 LD    (L4801),HL           ;293B 220148                                                                       
                 LD    A,E                  ;293E 7B                                                                           
L293F:           SUB   50                   ;293F D632                                                                         
                 JR    NC,L293F             ;2941 30FC                                                                         
                 ADD   A,50                 ;2943 C632                                                                         
                 LD    E,A                  ;2945 5F                                                                           
                 POP   BC                   ;2946 C1                                                                           
                 LD    A,C                  ;2947 79                                                                           
L2948:           SUB   80                   ;2948 D650                                                                         
                 JR    NC,L2948             ;294A 30FC                                                                         
                 ADD   A,80                 ;294C C650                                                                         
                 LD    C,A                  ;294E 4F                                                                           
                 XOR   A                    ;294F AF                                                                           
                 SRL   C                    ;2950 CB39                                                                         
                 JR    NC,L2962             ;2952 300E                                                                         
                 SRL   E                    ;2954 CB3B                                                                         
                 JR    NC,L295C             ;2956 3004                                                                         
                 ADD   A,4                  ;2958 C604                                                                         
L295A:           ADD   A,2                  ;295A C602                                                                         
L295C:           ADD   A,1                  ;295C C601                                                                         
L295E:           ADD   A,1                  ;295E C601                                                                         
                 JR    L2968                ;2960 1806                                                                         

L2962:           SRL   E                    ;2962 CB3B                                                                         
                 JR    NC,L295E             ;2964 30F8                                                                         
                 JR    L295A                ;2966 18F2                                                                         

L2968:           PUSH  AF                   ;2968 F5                                                                           
                 LD    HL,VIDRAM            ;2969 2100D0                                                                       
                 LD    A,40                 ;296C 3E28                                                                         
L296E:           ADD   HL,DE                ;296E 19                                                                           
                 DEC   A                    ;296F 3D                                                                           
                 JR    NZ,L296E             ;2970 20FC                                                                         
                 ADD   HL,BC                ;2972 09                                                                           
                 LD    A,(HL)               ;2973 7E                                                                           
                 CP    240                  ;2974 FEF0                                                                         
                 JR    NC,L297A             ;2976 3002                                                                         
                 LD    A,240                ;2978 3EF0                                                                         
L297A:           POP   BC                   ;297A C1                                                                           
                 LD    C,A                  ;297B 4F                                                                           
                 POP   AF                   ;297C F1                                                                           
                 OR    A                    ;297D B7                                                                           
                 LD    A,B                  ;297E 78                                                                           
                 JR    Z,L2984              ;297F 2803                                                                         
                 OR    C                    ;2981 B1                                                                           
                 JR    L2986                ;2982 1802                                                                         

L2984:           CPL                        ;2984 2F                                                                           
                 AND   C                    ;2985 A1                                                                           
L2986:           CP    240                  ;2986 FEF0                                                                         
                 JR    NZ,L298B             ;2988 2001                                                                         
                 XOR   A                    ;298A AF                                                                           
L298B:           LD    (HL),A               ;298B 77                                                                           
                 JP    L19B2                ;298C C3B219                                                                       

L298F:           XOR   A                    ;298F AF                                                                           
                 JP    L2A38                ;2990 C3382A                                                                       

L2993:           LD    A,(STACK)            ;2993 3AF010                                                                       
                 CP    2                    ;2996 FE02                                                                         
                 JP    NZ,L2A66             ;2998 C2662A                                                                       
                 CALL  L2B08                ;299B CD082B                                                                       
                 CALL  L2B48                ;299E CD482B                                                                       
                 CALL  CHECK                ;29A1 CD2D00                                                                       
                 PUSH  AF                   ;29A4 F5                                                                           
                 CALL  L2B60                ;29A5 CD602B                                                                       
                 POP   AF                   ;29A8 F1                                                                           
                 JP    C,L2B41              ;29A9 DA412B                                                                       
                 LD    DE,L29B5             ;29AC 11B529                                                                       
                 CALL  L1357                ;29AF CD5713                                                                       
                 JP    L19B2                ;29B2 C3B219                                                                       

L29B5:           DB    "OK"                 ;29B5 4F4B                                                                         
                 DB    0DH                  ;29B7 0D                                                                           
L29B8:           DB    00H                  ;29B8 00                                                                           
L29B9:           DW    00000H               ;29B9 0000                                                                         
L29BB:           EX    DE,HL                ;29BB EB                                                                           
                 CALL  L2B9C                ;29BC CD9C2B                                                                       
                 LD    HL,L0D02             ;29BF 21020D                                                                       
                 LD    (STACK),HL           ;29C2 22F010                                                                       
                 XOR   A                    ;29C5 AF                                                                           
                 PUSH  AF                   ;29C6 F5                                                                           
                 LD    HL,L4806             ;29C7 210648                                                                       
L29CA:           LD    (FILESTART),HL       ;29CA 220411                                                                       
                 LD    HL,COLDSTART         ;29CD 210000                                                                       
                 LD    (EXECUTE),HL         ;29D0 220611                                                                       
                 LD    (L1108),HL           ;29D3 220811                                                                       
                 EX    DE,HL                ;29D6 EB                                                                           
                 CALL  L1829                ;29D7 CD2918                                                                       
                 JP    Z,L29FB              ;29DA CAFB29                                                                       
                 CALL  L2383                ;29DD CD8323                                                                       
                 LD    A,D                  ;29E0 7A                                                                           
                 OR    A                    ;29E1 B7                                                                           
                 JP    Z,L138E              ;29E2 CA8E13                                                                       
                 LD    A,C                  ;29E5 79                                                                           
                 CP    17                   ;29E6 FE11                                                                         
                 JP    NC,L138E             ;29E8 D28E13                                                                       
                 CALL  L1801                ;29EB CD0118                                                                       
                 PUSH  HL                   ;29EE E5                                                                           
                 LD    HL,HEADBUFFER        ;29EF 21F110                                                                       
                 EX    DE,HL                ;29F2 EB                                                                           
                 CALL  L1799                ;29F3 CD9917                                                                       
                 EX    DE,HL                ;29F6 EB                                                                           
                 ADD   HL,BC                ;29F7 09                                                                           
                 LD    (HL),13              ;29F8 360D                                                                         
                 POP   HL                   ;29FA E1                                                                           
L29FB:           LD    (L4801),HL           ;29FB 220148                                                                       
                 POP   AF                   ;29FE F1                                                                           
                 JP    NZ,L2BC6             ;29FF C2C62B                                                                       
                 LD    HL,(L29B9)           ;2A02 2AB929                                                                       
                 LD    (L1108),HL           ;2A05 220811                                                                       
                 LD    A,(L29B8)            ;2A08 3AB829                                                                       
                 OR    A                    ;2A0B B7                                                                           
                 JP    NZ,L124B             ;2A0C C24B12                                                                       
                 LD    HL,(L4634)           ;2A0F 2A3446                                                                       
                 LD    DE,L4806             ;2A12 110648                                                                       
                 EX    DE,HL                ;2A15 EB                                                                           
                 CALL  L1668                ;2A16 CD6816                                                                       
                 LD    (FILESIZE),HL        ;2A19 220211                                                                       
                 CALL  PHEAD                ;2A1C CD2100                                                                       
                 JP    C,L1385              ;2A1F DA8513                                                                       
                 CALL  CRLF                 ;2A22 CD0900                                                                       
                 CALL  L2B48                ;2A25 CD482B                                                                       
                 CALL  PDATA                ;2A28 CD2400                                                                       
                 PUSH  AF                   ;2A2B F5                                                                           
                 CALL  L2B60                ;2A2C CD602B                                                                       
                 POP   AF                   ;2A2F F1                                                                           
                 JP    NC,L19B2             ;2A30 D2B219                                                                       
                 JP    L1385                ;2A33 C38513                                                                       

L2A36:           LD    A,1                  ;2A36 3E01                                                                         
L2A38:           LD    (L4592),A            ;2A38 329245                                                                       
                 XOR   A                    ;2A3B AF                                                                           
                 LD    (L458E),A            ;2A3C 328E45                                                                       
L2A3F:           CALL  L1829                ;2A3F CD2918                                                                       
                 JP    Z,L2A63              ;2A42 CA632A                                                                       
                 CALL  L2383                ;2A45 CD8323                                                                       
                 CALL  L180F                ;2A48 CD0F18                                                                       
                 CALL  L1829                ;2A4B CD2918                                                                       
                 JP    NZ,L138E             ;2A4E C28E13                                                                       
                 CALL  L1801                ;2A51 CD0118                                                                       
                 LD    A,C                  ;2A54 79                                                                           
                 CP    17                   ;2A55 FE11                                                                         
                 JP    NC,L138E             ;2A57 D28E13                                                                       
                 LD    A,1                  ;2A5A 3E01                                                                         
                 LD    (L458E),A            ;2A5C 328E45                                                                       
                 LD    (L458F),DE           ;2A5F ED538F45                                                                     
L2A63:           LD    (L4801),HL           ;2A63 220148                                                                       
L2A66:           CALL  LHEAD                ;2A66 CD2700                                                                       
                 JP    C,L2B41              ;2A69 DA412B                                                                       
                 CALL  L2B0D                ;2A6C CD0D2B                                                                       
                 LD    HL,STACK             ;2A6F 21F010                                                                       
                 LD    A,(HL)               ;2A72 7E                                                                           
                 OR    A                    ;2A73 B7                                                                           
                 JP    Z,L2A66              ;2A74 CA662A                                                                       
                 CP    4                    ;2A77 FE04                                                                         
                 JP    NC,L2A66             ;2A79 D2662A                                                                       
                 LD    A,(L458E)            ;2A7C 3A8E45                                                                       
                 OR    A                    ;2A7F B7                                                                           
                 JP    Z,L2A99              ;2A80 CA992A                                                                       
                 LD    HL,(L458F)           ;2A83 2A8F45                                                                       
                 LD    DE,HEADBUFFER        ;2A86 11F110                                                                       
                 LD    C,16                 ;2A89 0E10                                                                         
L2A8B:           LD    A,(DE)               ;2A8B 1A                                                                           
                 CP    (HL)                 ;2A8C BE                                                                           
                 JP    NZ,L2A66             ;2A8D C2662A                                                                       
                 CP    13                   ;2A90 FE0D                                                                         
                 JR    Z,L2A99              ;2A92 2805                                                                         
                 INC   HL                   ;2A94 23                                                                           
                 INC   DE                   ;2A95 13                                                                           
                 DEC   C                    ;2A96 0D                                                                           
                 JR    NZ,L2A8B             ;2A97 20F2                                                                         
L2A99:           LD    A,(STACK)            ;2A99 3AF010                                                                       
                 LD    C,A                  ;2A9C 4F                                                                           
                 LD    A,(L4592)            ;2A9D 3A9245                                                                       
                 OR    A                    ;2AA0 B7                                                                           
                 JP    Z,L2993              ;2AA1 CA9329                                                                       
                 CP    2                    ;2AA4 FE02                                                                         
                 JP    NZ,L2AB1             ;2AA6 C2B12A                                                                       
                 DEC   C                    ;2AA9 0D                                                                           
                 CP    C                    ;2AAA B9                                                                           
                 JP    Z,L2BEA              ;2AAB CAEA2B                                                                       
                 JP    L2A66                ;2AAE C3662A                                                                       

L2AB1:           LD    A,C                  ;2AB1 79                                                                           
                 CP    1                    ;2AB2 FE01                                                                         
                 JP    Z,L2B74              ;2AB4 CA742B                                                                       
                 CP    2                    ;2AB7 FE02                                                                         
                 JP    NZ,L2A66             ;2AB9 C2662A                                                                       
                 CALL  L2B9C                ;2ABC CD9C2B                                                                       
                 LD    BC,L0064             ;2ABF 016400                                                                       
                 LD    HL,L4806             ;2AC2 210648                                                                       
                 CALL  L1742                ;2AC5 CD4217                                                                       
                 EX    DE,HL                ;2AC8 EB                                                                           
                 LD    HL,(FILESIZE)        ;2AC9 2A0211                                                                       
                 CALL  L1662                ;2ACC CD6216                                                                       
                 JP    NC,L1393             ;2ACF D29313                                                                       
                 CALL  L2B12                ;2AD2 CD122B                                                                       
                 LD    A,(L1108)            ;2AD5 3A0811                                                                       
                 LD    (L29B8),A            ;2AD8 32B829                                                                       
                 LD    HL,L4806             ;2ADB 210648                                                                       
                 LD    (FILESTART),HL       ;2ADE 220411                                                                       
                 CALL  LDATA                ;2AE1 CD2A00                                                                       
                 JP    C,L2B3C              ;2AE4 DA3C2B                                                                       
                 LD    DE,L4806             ;2AE7 110648                                                                       
                 LD    HL,(FILESIZE)        ;2AEA 2A0211                                                                       
                 ADD   HL,DE                ;2AED 19                                                                           
                 LD    (L4634),HL           ;2AEE 223446                                                                       
                 CALL  L2B60                ;2AF1 CD602B                                                                       
                 CALL  L1857                ;2AF4 CD5718                                                                       
                 CALL  L187C                ;2AF7 CD7C18                                                                       
                 LD    A,(L1109)            ;2AFA 3A0911                                                                       
                 OR    A                    ;2AFD B7                                                                           
                 JP    Z,L19B2              ;2AFE CAB219                                                                       
                 LD    HL,L2B07             ;2B01 21072B                                                                       
                 JP    L1CCB                ;2B04 C3CB1C                                                                       

L2B07:           DB    0DH                  ;2B07 0D                                                                           
L2B08:           LD    DE,L2B31             ;2B08 11312B                                                                       
                 JR    L2B15                ;2B0B 1808                                                                         

L2B0D:           LD    DE,L2B21             ;2B0D 11212B                                                                       
                 JR    L2B15                ;2B10 1803                                                                         

L2B12:           LD    DE,L2B28             ;2B12 11282B                                                                       
L2B15:           CALL  L1357                ;2B15 CD5713                                                                       
                 LD    DE,HEADBUFFER        ;2B18 11F110                                                                       
                 CALL  MESSAGE              ;2B1B CD1500                                                                       
                 JP    CRLF                 ;2B1E C30900                                                                       

L2B21:           DB    "FOUND "             ;2B21 464F554E4420                                                                 
                 DB    0DH                  ;2B27 0D                                                                           
L2B28:           DB    "LOADING "           ;2B28 4C4F4144494E4720                                                             
                 DB    0DH                  ;2B30 0D                                                                           
L2B31:           DB    "VERIFYING "         ;2B31 564552494659494E4720                                                         
                 DB    0DH                  ;2B3B 0D                                                                           
L2B3C:           PUSH  AF                   ;2B3C F5                                                                           
                 CALL  L1832                ;2B3D CD3218                                                                       
                 POP   AF                   ;2B40 F1                                                                           
L2B41:           DEC   A                    ;2B41 3D                                                                           
                 JP    Z,L1398              ;2B42 CA9813                                                                       
                 JP    L1385                ;2B45 C38513                                                                       

L2B48:           LD    HL,L4806             ;2B48 210648                                                                       
L2B4B:           LD    E,(HL)               ;2B4B 5E                                                                           
                 INC   HL                   ;2B4C 23                                                                           
                 LD    D,(HL)               ;2B4D 56                                                                           
                 LD    A,E                  ;2B4E 7B                                                                           
                 OR    D                    ;2B4F B2                                                                           
                 RET   Z                    ;2B50 C8                                                                           
                 PUSH  DE                   ;2B51 D5                                                                           
                 DEC   HL                   ;2B52 2B                                                                           
                 LD    A,E                  ;2B53 7B                                                                           
                 SUB   L                    ;2B54 95                                                                           
                 LD    E,A                  ;2B55 5F                                                                           
                 LD    A,D                  ;2B56 7A                                                                           
                 SBC   A,H                  ;2B57 9C                                                                           
                 LD    D,A                  ;2B58 57                                                                           
                 LD    (HL),E               ;2B59 73                                                                           
                 INC   HL                   ;2B5A 23                                                                           
                 LD    (HL),D               ;2B5B 72                                                                           
                 POP   HL                   ;2B5C E1                                                                           
                 JP    L2B4B                ;2B5D C34B2B                                                                       

L2B60:           LD    HL,L4806             ;2B60 210648                                                                       
L2B63:           LD    E,(HL)               ;2B63 5E                                                                           
                 INC   HL                   ;2B64 23                                                                           
                 LD    D,(HL)               ;2B65 56                                                                           
                 LD    A,E                  ;2B66 7B                                                                           
                 OR    D                    ;2B67 B2                                                                           
                 RET   Z                    ;2B68 C8                                                                           
                 DEC   HL                   ;2B69 2B                                                                           
                 EX    DE,HL                ;2B6A EB                                                                           
                 ADD   HL,DE                ;2B6B 19                                                                           
                 EX    DE,HL                ;2B6C EB                                                                           
                 LD    (HL),E               ;2B6D 73                                                                           
                 INC   HL                   ;2B6E 23                                                                           
                 LD    (HL),D               ;2B6F 72                                                                           
                 EX    DE,HL                ;2B70 EB                                                                           
                 JP    L2B63                ;2B71 C3632B                                                                       

L2B74:           LD    HL,(FILESTART)       ;2B74 2A0411                                                                       
                 EX    DE,HL                ;2B77 EB                                                                           
                 LD    HL,(04563H)          ;2B78 2A6345                                                                       
                 DEC   HL                   ;2B7B 2B                                                                           
                 CALL  L1662                ;2B7C CD6216                                                                       
                 JP    NC,L13B6             ;2B7F D2B613                                                                       
                 LD    HL,(FILESIZE)        ;2B82 2A0211                                                                       
                 ADD   HL,DE                ;2B85 19                                                                           
                 JP    C,L1393              ;2B86 DA9313                                                                       
                 EX    DE,HL                ;2B89 EB                                                                           
                 LD    HL,(04561H)          ;2B8A 2A6145                                                                       
                 CALL  L1662                ;2B8D CD6216                                                                       
                 JP    C,L1393              ;2B90 DA9313                                                                       
                 CALL  L2B12                ;2B93 CD122B                                                                       
                 CALL  LDATA                ;2B96 CD2A00                                                                       
                 JP    L19B2                ;2B99 C3B219                                                                       

L2B9C:           PUSH  HL                   ;2B9C E5                                                                           
                 LD    HL,(L47FF)           ;2B9D 2AFF47                                                                       
                 LD    A,H                  ;2BA0 7C                                                                           
                 OR    L                    ;2BA1 B5                                                                           
                 JP    NZ,L138E             ;2BA2 C28E13                                                                       
                 POP   HL                   ;2BA5 E1                                                                           
                 RET                        ;2BA6 C9                                                                           

L2BA7:           LD    A,(L457A)            ;2BA7 3A7A45                                                                       
                 OR    A                    ;2BAA B7                                                                           
                 JP    NZ,L13B1             ;2BAB C2B113                                                                       
                 INC   A                    ;2BAE 3C                                                                           
                 PUSH  AF                   ;2BAF F5                                                                           
                 EX    DE,HL                ;2BB0 EB                                                                           
                 LD    HL,L0D03             ;2BB1 21030D                                                                       
                 LD    (STACK),HL           ;2BB4 22F010                                                                       
                 LD    HL,L0080             ;2BB7 218000                                                                       
                 LD    (FILESIZE),HL        ;2BBA 220211                                                                       
                 LD    HL,L45AE             ;2BBD 21AE45                                                                       
                 LD    (L457B),HL           ;2BC0 227B45                                                                       
                 JP    L29CA                ;2BC3 C3CA29                                                                       

L2BC6:           CALL  PHEAD                ;2BC6 CD2100                                                                       
                 JP    C,L1385              ;2BC9 DA8513                                                                       
                 CALL  CRLF                 ;2BCC CD0900                                                                       
                 LD    A,1                  ;2BCF 3E01                                                                         
                 LD    (L457A),A            ;2BD1 327A45                                                                       
                 JP    L19B2                ;2BD4 C3B219                                                                       

L2BD7:           LD    A,(L457A)            ;2BD7 3A7A45                                                                       
                 OR    A                    ;2BDA B7                                                                           
                 JP    NZ,L13B1             ;2BDB C2B113                                                                       
                 LD    A,2                  ;2BDE 3E02                                                                         
                 LD    (L4592),A            ;2BE0 329245                                                                       
                 XOR   A                    ;2BE3 AF                                                                           
                 LD    (L458E),A            ;2BE4 328E45                                                                       
                 JP    L2A3F                ;2BE7 C33F2A                                                                       

L2BEA:           LD    (L457A),A            ;2BEA 327A45                                                                       
                 CALL  L2B12                ;2BED CD122B                                                                       
                 LD    HL,L45AE             ;2BF0 21AE45                                                                       
                 LD    (FILESTART),HL       ;2BF3 220411                                                                       
                 LD    HL,L0080             ;2BF6 218000                                                                       
                 LD    (FILESIZE),HL        ;2BF9 220211                                                                       
                 LD    HL,L462E             ;2BFC 212E46                                                                       
                 LD    (L457B),HL           ;2BFF 227B45                                                                       
                 JP    L19B2                ;2C02 C3B219                                                                       

L2C05:           LD    A,(L457A)            ;2C05 3A7A45                                                                       
                 OR    A                    ;2C08 B7                                                                           
                 JP    Z,L1B27              ;2C09 CA271B                                                                       
                 PUSH  HL                   ;2C0C E5                                                                           
                 DEC   A                    ;2C0D 3D                                                                           
                 JP    NZ,L2C25             ;2C0E C2252C                                                                       
                 LD    HL,(L457B)           ;2C11 2A7B45                                                                       
                 LD    DE,L462E             ;2C14 112E46                                                                       
                 CALL  L1662                ;2C17 CD6216                                                                       
                 JP    NC,L2C2D             ;2C1A D22D2C                                                                       
L2C1D:           LD    (HL),255             ;2C1D 36FF                                                                         
                 CALL  PDATA                ;2C1F CD2400                                                                       
                 JP    C,L1385              ;2C22 DA8513                                                                       
L2C25:           XOR   A                    ;2C25 AF                                                                           
                 LD    (L457A),A            ;2C26 327A45                                                                       
                 POP   HL                   ;2C29 E1                                                                           
                 JP    L1B27                ;2C2A C3271B                                                                       

L2C2D:           CALL  PDATA                ;2C2D CD2400                                                                       
                 JP    C,L1385              ;2C30 DA8513                                                                       
                 LD    HL,L45AE             ;2C33 21AE45                                                                       
                 JP    L2C1D                ;2C36 C31D2C                                                                       

L2C39:           CALL  L168B                ;2C39 CD8B16                                                                       
                 CP    A                    ;2C3C BF                                                                           
                 LD    C,C                  ;2C3D 49                                                                           
                 INC   L                    ;2C3E 2C                                                                           
                 CALL  L168B                ;2C3F CD8B16                                                                       
                 LD    D,H                  ;2C42 54                                                                           
                 LD    C,C                  ;2C43 49                                                                           
                 INC   L                    ;2C44 2C                                                                           
                 LD    A,1                  ;2C45 3E01                                                                         
                 JR    L2C4A                ;2C47 1801                                                                         

                 DB    0AFH                 ;2C49 AF                                                                           
L2C4A:           LD    (L457D),A            ;2C4A 327D45                                                                       
                 RET                        ;2C4D C9                                                                           

                 DB    3AH,7AH,45H,0FEH     ;2C4E 3A7A45FE  Link 2C4E found at , $1CAA                                         
                 DB    01H,0C2H,0B1H,13H    ;2C52 01C2B113                                                                     
                 DB    2AH,7BH,45H,0D5H     ;2C56 2A7B45D5                                                                     
                 DB    11H,2EH,46H,0CDH     ;2C5A 112E46CD                                                                     
                 DB    62H,16H,0DAH,6CH     ;2C5E 6216DA6C                                                                     
                 DB    2CH,0CDH,24H,00H     ;2C62 2CCD2400                                                                     
                 DB    0DAH,85H,13H,21H     ;2C66 DA851321                                                                     
                 DB    0AEH,45H,0D1H,1AH    ;2C6A AE45D11A                                                                     
                 DB    77H,23H,13H,0FEH     ;2C6E 772313FE                                                                     
                 DB    0DH,0C2H,59H,2CH     ;2C72 0DC2592C                                                                     
                 DB    22H,7BH,45H,0C9H     ;2C76 227B45C9                                                                     
L2C7A:           LD    C,A                  ;2C7A 4F                                                                           
                 CALL  L2CD0                ;2C7B CDD02C                                                                       
                 RET   Z                    ;2C7E C8                                                                           
                 PUSH  DE                   ;2C7F D5                                                                           
                 LD    C,0                  ;2C80 0E00                                                                         
                 CP    2                    ;2C82 FE02                                                                         
                 JP    NZ,L13B1             ;2C84 C2B113                                                                       
                 LD    (L4592),A            ;2C87 329245                                                                       
                 LD    HL,(L457B)           ;2C8A 2A7B45                                                                       
L2C8D:           PUSH  DE                   ;2C8D D5                                                                           
                 LD    DE,L462E             ;2C8E 112E46                                                                       
                 CALL  L1662                ;2C91 CD6216                                                                       
                 JP    C,L2CA7              ;2C94 DAA72C                                                                       
                 CALL  LDATA                ;2C97 CD2A00                                                                       
                 JP    NC,L2CA4             ;2C9A D2A42C                                                                       
                 DEC   A                    ;2C9D 3D                                                                           
                 JP    Z,L1398              ;2C9E CA9813                                                                       
                 JP    L1385                ;2CA1 C38513                                                                       

L2CA4:           LD    HL,L45AE             ;2CA4 21AE45                                                                       
L2CA7:           LD    A,(HL)               ;2CA7 7E                                                                           
                 LD    B,A                  ;2CA8 47                                                                           
                 CP    255                  ;2CA9 FEFF                                                                         
                 JP    NZ,L2CB6             ;2CAB C2B62C                                                                       
                 LD    A,(L4592)            ;2CAE 3A9245                                                                       
                 CP    2                    ;2CB1 FE02                                                                         
                 JP    Z,L13B1              ;2CB3 CAB113                                                                       
L2CB6:           XOR   A                    ;2CB6 AF                                                                           
                 LD    (L4592),A            ;2CB7 329245                                                                       
                 LD    A,B                  ;2CBA 78                                                                           
                 POP   DE                   ;2CBB D1                                                                           
                 LD    (DE),A               ;2CBC 12                                                                           
                 INC   HL                   ;2CBD 23                                                                           
                 INC   DE                   ;2CBE 13                                                                           
                 INC   C                    ;2CBF 0C                                                                           
                 CP    13                   ;2CC0 FE0D                                                                         
                 JP    NZ,L2C8D             ;2CC2 C28D2C                                                                       
                 DEC   C                    ;2CC5 0D                                                                           
                 POP   DE                   ;2CC6 D1                                                                           
                 LD    (L457B),HL           ;2CC7 227B45                                                                       
                 POP   HL                   ;2CCA E1                                                                           
                 INC   HL                   ;2CCB 23                                                                           
                 INC   HL                   ;2CCC 23                                                                           
                 INC   HL                   ;2CCD 23                                                                           
                 PUSH  HL                   ;2CCE E5                                                                           
                 RET                        ;2CCF C9                                                                           

L2CD0:           LD    A,(L457D)            ;2CD0 3A7D45                                                                       
                 OR    A                    ;2CD3 B7                                                                           
                 LD    A,(L457A)            ;2CD4 3A7A45                                                                       
                 RET                        ;2CD7 C9                                                                           

L2CD8:           CALL  L19A9                ;2CD8 CDA919                                                                       
                 PUSH  DE                   ;2CDB D5                                                                           
                 CALL  L169A                ;2CDC CD9A16                                                                       
                 INC   L                    ;2CDF 2C                                                                           
                 CALL  L2613                ;2CE0 CD1326                                                                       
                 CALL  L2436                ;2CE3 CD3624                                                                       
                 LD    A,B                  ;2CE6 78                                                                           
                 OR    A                    ;2CE7 B7                                                                           
                 JP    NZ,L139D             ;2CE8 C29D13                                                                       
                 LD    (L4801),HL           ;2CEB 220148                                                                       
                 CALL  L197B                ;2CEE CD7B19                                                                       
                 POP   DE                   ;2CF1 D1                                                                           
                 LD    A,E                  ;2CF2 7B                                                                           
                 CP    240                  ;2CF3 FEF0                                                                         
                 JP    NC,L1398             ;2CF5 D29813                                                                       
                 LD    (L2CFC),A            ;2CF8 32FC2C                                                                       
                 IN    A,(PTRDATA)          ;2CFB DBFF                                                                         
                 OR    A                    ;2CFD B7                                                                           
                 LD    B,A                  ;2CFE 47                                                                           
                 JP    Z,L2D0F              ;2CFF CA0F2D                                                                       
                 LD    A,200                ;2D02 3EC8                                                                         
L2D04:           BIT   7,B                  ;2D04 CB78                                                                         
                 JP    NZ,L2D11             ;2D06 C2112D                                                                       
                 SLA   B                    ;2D09 CB20                                                                         
                 DEC   A                    ;2D0B 3D                                                                           
                 JP    L2D04                ;2D0C C3042D                                                                       

L2D0F:           LD    A,128                ;2D0F 3E80                                                                         
L2D11:           LD    HL,(L4644)           ;2D11 2A4446                                                                       
                 LD    (HL),A               ;2D14 77                                                                           
                 INC   HL                   ;2D15 23                                                                           
                 XOR   A                    ;2D16 AF                                                                           
                 LD    (HL),A               ;2D17 77                                                                           
                 INC   HL                   ;2D18 23                                                                           
                 LD    (HL),A               ;2D19 77                                                                           
                 INC   HL                   ;2D1A 23                                                                           
                 LD    (HL),A               ;2D1B 77                                                                           
                 INC   HL                   ;2D1C 23                                                                           
                 LD    (HL),B               ;2D1D 70                                                                           
                 LD    D,A                  ;2D1E 57                                                                           
                 LD    E,A                  ;2D1F 5F                                                                           
                 LD    B,A                  ;2D20 47                                                                           
                 LD    C,5                  ;2D21 0E05                                                                         
                 CALL  L1976                ;2D23 CD7619                                                                       
                 CALL  L1B6A                ;2D26 CD6A1B                                                                       
                 SBC   A,L                  ;2D29 9D                                                                           
                 INC   DE                   ;2D2A 13                                                                           
                 JP    L19B2                ;2D2B C3B219                                                                       

L2D2E:           CALL  L19A9                ;2D2E CDA919                                                                       
                 LD    A,E                  ;2D31 7B                                                                           
                 CP    240                  ;2D32 FEF0                                                                         
                 JP    NC,L1398             ;2D34 D29813                                                                       
                 LD    (L2D43),A            ;2D37 32432D                                                                       
                 CALL  L169A                ;2D3A CD9A16                                                                       
                 INC   L                    ;2D3D 2C                                                                           
                 CALL  L19A9                ;2D3E CDA919                                                                       
                 LD    A,E                  ;2D41 7B                                                                           
                 OUT   (PTRDATA),A          ;2D42 D3FF                                                                         
                 JP    L19B5                ;2D44 C3B519                                                                       

L2D47:           DW    032AFH               ;2D47 AF32                                                                         
L2D49:           DB    7AH                  ;2D49 7A                                                                           
L2D4A:           XOR   A                    ;2D4A AF                                                                           
                 JR    L2D4F                ;2D4B 1802                                                                         

L2D4D:           LD    A,128                ;2D4D 3E80                                                                         
L2D4F:           PUSH  DE                   ;2D4F D5                                                                           
                 XOR   (HL)                 ;2D50 AE                                                                           
                 CPL                        ;2D51 2F                                                                           
                 LD    C,A                  ;2D52 4F                                                                           
                 LD    A,(DE)               ;2D53 1A                                                                           
                 AND   128                  ;2D54 E680                                                                         
                 LD    B,A                  ;2D56 47                                                                           
                 XOR   C                    ;2D57 A9                                                                           
                 CPL                        ;2D58 2F                                                                           
                 AND   128                  ;2D59 E680                                                                         
                 LD    C,A                  ;2D5B 4F                                                                           
L2D5C:           PUSH  BC                   ;2D5C C5                                                                           
                 LD    B,(HL)               ;2D5D 46                                                                           
                 RES   7,B                  ;2D5E CBB8                                                                         
                 LD    A,(DE)               ;2D60 1A                                                                           
                 AND   127                  ;2D61 E67F                                                                         
                 CP    B                    ;2D63 B8                                                                           
                 JP    NC,L2D72             ;2D64 D2722D                                                                       
                 POP   BC                   ;2D67 C1                                                                           
                 EX    DE,HL                ;2D68 EB                                                                           
                 LD    A,B                  ;2D69 78                                                                           
                 XOR   C                    ;2D6A A9                                                                           
                 CPL                        ;2D6B 2F                                                                           
                 AND   128                  ;2D6C E680                                                                         
                 LD    B,A                  ;2D6E 47                                                                           
                 JP    L2D5C                ;2D6F C35C2D                                                                       

L2D72:           LD    C,A                  ;2D72 4F                                                                           
                 ADD   A,64                 ;2D73 C640                                                                         
                 LD    (L2D49),A            ;2D75 32492D                                                                       
                 LD    A,C                  ;2D78 79                                                                           
                 SUB   B                    ;2D79 90                                                                           
                 POP   BC                   ;2D7A C1                                                                           
                 LD    (L2D47),BC           ;2D7B ED43472D                                                                     
                 PUSH  DE                   ;2D7F D5                                                                           
                 INC   HL                   ;2D80 23                                                                           
                 LD    E,(HL)               ;2D81 5E                                                                           
                 INC   HL                   ;2D82 23                                                                           
                 LD    D,(HL)               ;2D83 56                                                                           
                 INC   HL                   ;2D84 23                                                                           
                 LD    C,(HL)               ;2D85 4E                                                                           
                 INC   HL                   ;2D86 23                                                                           
                 LD    B,(HL)               ;2D87 46                                                                           
                 POP   HL                   ;2D88 E1                                                                           
                 INC   HL                   ;2D89 23                                                                           
                 JP    Z,L2DAB              ;2D8A CAAB2D                                                                       
L2D8D:           CP    8                    ;2D8D FE08                                                                         
                 JP    NC,L2DA1             ;2D8F D2A12D                                                                       
L2D92:           SRL   B                    ;2D92 CB38                                                                         
                 RR    C                    ;2D94 CB19                                                                         
                 RR    D                    ;2D96 CB1A                                                                         
                 RR    E                    ;2D98 CB1B                                                                         
                 DEC   A                    ;2D9A 3D                                                                           
                 JP    NZ,L2D92             ;2D9B C2922D                                                                       
                 JP    L2DAB                ;2D9E C3AB2D                                                                       

L2DA1:           LD    E,D                  ;2DA1 5A                                                                           
                 LD    D,C                  ;2DA2 51                                                                           
                 LD    C,B                  ;2DA3 48                                                                           
                 LD    B,0                  ;2DA4 0600                                                                         
                 SUB   8                    ;2DA6 D608                                                                         
                 JP    NZ,L2D8D             ;2DA8 C28D2D                                                                       
L2DAB:           LD    A,(L2D47)            ;2DAB 3A472D                                                                       
                 OR    A                    ;2DAE B7                                                                           
                 JP    Z,L2DEE              ;2DAF CAEE2D                                                                       
                 LD    A,(HL)               ;2DB2 7E                                                                           
                 INC   HL                   ;2DB3 23                                                                           
                 ADD   A,E                  ;2DB4 83                                                                           
                 LD    E,A                  ;2DB5 5F                                                                           
                 LD    A,(HL)               ;2DB6 7E                                                                           
                 INC   HL                   ;2DB7 23                                                                           
                 ADC   A,D                  ;2DB8 8A                                                                           
                 LD    D,A                  ;2DB9 57                                                                           
                 LD    A,(HL)               ;2DBA 7E                                                                           
                 INC   HL                   ;2DBB 23                                                                           
                 ADC   A,C                  ;2DBC 89                                                                           
                 LD    C,A                  ;2DBD 4F                                                                           
                 LD    A,(HL)               ;2DBE 7E                                                                           
                 ADC   A,B                  ;2DBF 88                                                                           
                 LD    B,A                  ;2DC0 47                                                                           
                 JP    NC,L2DD0             ;2DC1 D2D02D                                                                       
                 RR    B                    ;2DC4 CB18                                                                         
                 RR    C                    ;2DC6 CB19                                                                         
                 RR    D                    ;2DC8 CB1A                                                                         
                 RR    E                    ;2DCA CB1B                                                                         
                 LD    HL,L2D49             ;2DCC 21492D                                                                       
                 INC   (HL)                 ;2DCF 34                                                                           
L2DD0:           LD    HL,L2D49             ;2DD0 21492D                                                                       
                 LD    A,(HL)               ;2DD3 7E                                                                           
                 SUB   64                   ;2DD4 D640                                                                         
                 JP    C,L2DE0              ;2DD6 DAE02D                                                                       
                 JP    M,L1398              ;2DD9 FA9813                                                                       
                 DEC   HL                   ;2DDC 2B                                                                           
                 OR    (HL)                 ;2DDD B6                                                                           
                 JR    L2DE3                ;2DDE 1803                                                                         

L2DE0:           CALL  L367B                ;2DE0 CD7B36                                                                       
L2DE3:           POP   HL                   ;2DE3 E1                                                                           
L2DE4:           LD    (HL),A               ;2DE4 77                                                                           
                 INC   HL                   ;2DE5 23                                                                           
                 LD    (HL),E               ;2DE6 73                                                                           
                 INC   HL                   ;2DE7 23                                                                           
                 LD    (HL),D               ;2DE8 72                                                                           
                 INC   HL                   ;2DE9 23                                                                           
                 LD    (HL),C               ;2DEA 71                                                                           
                 INC   HL                   ;2DEB 23                                                                           
                 LD    (HL),B               ;2DEC 70                                                                           
                 RET                        ;2DED C9                                                                           

L2DEE:           LD    A,(HL)               ;2DEE 7E                                                                           
                 INC   HL                   ;2DEF 23                                                                           
                 SUB   E                    ;2DF0 93                                                                           
                 LD    E,A                  ;2DF1 5F                                                                           
                 LD    A,(HL)               ;2DF2 7E                                                                           
                 INC   HL                   ;2DF3 23                                                                           
                 SBC   A,D                  ;2DF4 9A                                                                           
                 LD    D,A                  ;2DF5 57                                                                           
                 LD    A,(HL)               ;2DF6 7E                                                                           
                 INC   HL                   ;2DF7 23                                                                           
                 SBC   A,C                  ;2DF8 99                                                                           
                 LD    C,A                  ;2DF9 4F                                                                           
                 LD    A,(HL)               ;2DFA 7E                                                                           
                 SBC   A,B                  ;2DFB 98                                                                           
                 LD    B,A                  ;2DFC 47                                                                           
                 CALL  C,L2E3D              ;2DFD DC3D2E                                                                       
                 OR    C                    ;2E00 B1                                                                           
                 OR    D                    ;2E01 B2                                                                           
                 JP    NZ,L2E0B             ;2E02 C20B2E                                                                       
                 LD    A,E                  ;2E05 7B                                                                           
                 CP    63                   ;2E06 FE3F                                                                         
                 JP    C,L2DE0              ;2E08 DAE02D                                                                       
L2E0B:           LD    HL,L2D49             ;2E0B 21492D                                                                       
L2E0E:           LD    A,B                  ;2E0E 78                                                                           
                 OR    A                    ;2E0F B7                                                                           
                 JP    M,L2DD0              ;2E10 FAD02D                                                                       
                 JP    NZ,L2E2B             ;2E13 C22B2E                                                                       
                 LD    A,(HL)               ;2E16 7E                                                                           
                 SUB   8                    ;2E17 D608                                                                         
                 JP    C,L2DE0              ;2E19 DAE02D                                                                       
                 LD    (HL),A               ;2E1C 77                                                                           
                 LD    A,C                  ;2E1D 79                                                                           
                 OR    D                    ;2E1E B2                                                                           
                 OR    E                    ;2E1F B3                                                                           
                 JP    Z,L2DE0              ;2E20 CAE02D                                                                       
                 LD    B,C                  ;2E23 41                                                                           
                 LD    C,D                  ;2E24 4A                                                                           
                 LD    D,E                  ;2E25 53                                                                           
                 LD    E,0                  ;2E26 1E00                                                                         
                 JP    L2E0E                ;2E28 C30E2E                                                                       

L2E2B:           DEC   (HL)                 ;2E2B 35                                                                           
                 JP    C,L2DE0              ;2E2C DAE02D                                                                       
                 SLA   E                    ;2E2F CB23                                                                         
                 RL    D                    ;2E31 CB12                                                                         
                 RL    C                    ;2E33 CB11                                                                         
                 RL    B                    ;2E35 CB10                                                                         
                 JP    P,L2E2B              ;2E37 F22B2E                                                                       
                 JP    L2DD0                ;2E3A C3D02D                                                                       

L2E3D:           LD    HL,L2D48             ;2E3D 21482D                                                                       
                 LD    A,(HL)               ;2E40 7E                                                                           
                 ADD   A,128                ;2E41 C680                                                                         
                 LD    (HL),A               ;2E43 77                                                                           
                 LD    A,E                  ;2E44 7B                                                                           
                 CPL                        ;2E45 2F                                                                           
                 ADD   A,1                  ;2E46 C601                                                                         
                 LD    E,A                  ;2E48 5F                                                                           
                 LD    A,D                  ;2E49 7A                                                                           
                 CPL                        ;2E4A 2F                                                                           
                 ADC   A,0                  ;2E4B CE00                                                                         
                 LD    D,A                  ;2E4D 57                                                                           
                 LD    A,C                  ;2E4E 79                                                                           
                 CPL                        ;2E4F 2F                                                                           
                 ADC   A,0                  ;2E50 CE00                                                                         
                 LD    C,A                  ;2E52 4F                                                                           
                 LD    A,B                  ;2E53 78                                                                           
                 CPL                        ;2E54 2F                                                                           
                 ADC   A,0                  ;2E55 CE00                                                                         
                 LD    B,A                  ;2E57 47                                                                           
                 RET                        ;2E58 C9                                                                           

L2E59:           PUSH  DE                   ;2E59 D5                                                                           
                 LD    A,(DE)               ;2E5A 1A                                                                           
                 XOR   (HL)                 ;2E5B AE                                                                           
                 CPL                        ;2E5C 2F                                                                           
                 AND   128                  ;2E5D E680                                                                         
                 LD    (L2D48),A            ;2E5F 32482D                                                                       
                 LD    B,(HL)               ;2E62 46                                                                           
                 RES   7,B                  ;2E63 CBB8                                                                         
                 LD    A,(DE)               ;2E65 1A                                                                           
                 AND   127                  ;2E66 E67F                                                                         
                 ADD   A,B                  ;2E68 80                                                                           
                 JP    Z,L2DE0              ;2E69 CAE02D                                                                       
                 DEC   A                    ;2E6C 3D                                                                           
                 CP    48                   ;2E6D FE30                                                                         
                 JP    C,L2DE0              ;2E6F DAE02D                                                                       
                 CP    224                  ;2E72 FEE0                                                                         
                 JP    NC,L1398             ;2E74 D29813                                                                       
                 LD    (L2D49),A            ;2E77 32492D                                                                       
                 XOR   A                    ;2E7A AF                                                                           
                 LD    (L2D47),A            ;2E7B 32472D                                                                       
                 LD    BC,L0004             ;2E7E 010400                                                                       
                 ADD   HL,BC                ;2E81 09                                                                           
                 LD    A,(HL)               ;2E82 7E                                                                           
                 OR    A                    ;2E83 B7                                                                           
                 JP    P,L2DE0              ;2E84 F2E02D                                                                       
                 PUSH  HL                   ;2E87 E5                                                                           
                 POP   IY                   ;2E88 FDE1                                                                         
                 LD    C,B                  ;2E8A 48                                                                           
                 EX    DE,HL                ;2E8B EB                                                                           
                 INC   HL                   ;2E8C 23                                                                           
                 LD    E,(HL)               ;2E8D 5E                                                                           
                 INC   HL                   ;2E8E 23                                                                           
                 LD    D,(HL)               ;2E8F 56                                                                           
                 INC   HL                   ;2E90 23                                                                           
                 PUSH  HL                   ;2E91 E5                                                                           
                 LD    H,B                  ;2E92 60                                                                           
                 LD    L,B                  ;2E93 68                                                                           
                 EXX                        ;2E94 D9                                                                           
                 POP   HL                   ;2E95 E1                                                                           
                 LD    E,(HL)               ;2E96 5E                                                                           
                 INC   HL                   ;2E97 23                                                                           
                 LD    D,(HL)               ;2E98 56                                                                           
                 LD    HL,COLDSTART         ;2E99 210000                                                                       
                 LD    A,D                  ;2E9C 7A                                                                           
                 OR    A                    ;2E9D B7                                                                           
                 JP    P,L2DE0              ;2E9E F2E02D                                                                       
                 LD    C,4                  ;2EA1 0E04                                                                         
L2EA3:           LD    A,(IY+0)             ;2EA3 FD7E00                                                                       
                 LD    B,8                  ;2EA6 0608                                                                         
                 OR    A                    ;2EA8 B7                                                                           
                 JP    Z,L2F24              ;2EA9 CA242F                                                                       
L2EAC:           RLA                        ;2EAC 17                                                                           
                 JP    NC,L2EC5             ;2EAD D2C52E                                                                       
                 EX    AF,AF'               ;2EB0 08                                                                           
                 EXX                        ;2EB1 D9                                                                           
                 LD    A,B                  ;2EB2 78                                                                           
                 ADD   A,C                  ;2EB3 81                                                                           
                 LD    C,A                  ;2EB4 4F                                                                           
                 ADC   HL,DE                ;2EB5 ED5A                                                                         
                 EXX                        ;2EB7 D9                                                                           
                 ADC   HL,DE                ;2EB8 ED5A                                                                         
                 JP    NC,L2EC4             ;2EBA D2C42E                                                                       
                 LD    A,(L2D47)            ;2EBD 3A472D                                                                       
                 INC   A                    ;2EC0 3C                                                                           
                 LD    (L2D47),A            ;2EC1 32472D                                                                       
L2EC4:           EX    AF,AF'               ;2EC4 08                                                                           
L2EC5:           SRL   D                    ;2EC5 CB3A                                                                         
                 RR    E                    ;2EC7 CB1B                                                                         
                 EXX                        ;2EC9 D9                                                                           
                 RR    D                    ;2ECA CB1A                                                                         
                 RR    E                    ;2ECC CB1B                                                                         
                 RR    B                    ;2ECE CB18                                                                         
                 EXX                        ;2ED0 D9                                                                           
                 DJNZ  L2EAC                ;2ED1 10D9                                                                         
L2ED3:           DEC   IY                   ;2ED3 FD2B                                                                         
                 DEC   C                    ;2ED5 0D                                                                           
                 JP    NZ,L2EA3             ;2ED6 C2A32E                                                                       
                 LD    A,(L2D47)            ;2ED9 3A472D                                                                       
                 OR    A                    ;2EDC B7                                                                           
                 JP    Z,L2EF7              ;2EDD CAF72E                                                                       
                 LD    B,A                  ;2EE0 47                                                                           
                 LD    A,(L2D49)            ;2EE1 3A492D                                                                       
                 ADD   A,B                  ;2EE4 80                                                                           
                 LD    (L2D49),A            ;2EE5 32492D                                                                       
L2EE8:           SCF                        ;2EE8 37                                                                           
                 RR    H                    ;2EE9 CB1C                                                                         
                 RR    L                    ;2EEB CB1D                                                                         
                 EXX                        ;2EED D9                                                                           
                 RR    H                    ;2EEE CB1C                                                                         
                 RR    L                    ;2EF0 CB1D                                                                         
                 RR    C                    ;2EF2 CB19                                                                         
                 EXX                        ;2EF4 D9                                                                           
                 DJNZ  L2EE8                ;2EF5 10F1                                                                         
L2EF7:           EXX                        ;2EF7 D9                                                                           
                 LD    A,C                  ;2EF8 79                                                                           
                 OR    A                    ;2EF9 B7                                                                           
                 JP    P,L2F1C              ;2EFA F21C2F                                                                       
                 LD    DE,L0001             ;2EFD 110100                                                                       
                 ADD   HL,DE                ;2F00 19                                                                           
                 EXX                        ;2F01 D9                                                                           
                 LD    DE,COLDSTART         ;2F02 110000                                                                       
                 ADC   HL,DE                ;2F05 ED5A                                                                         
                 JP    NC,L2F1B             ;2F07 D21B2F                                                                       
                 RR    H                    ;2F0A CB1C                                                                         
                 RR    L                    ;2F0C CB1D                                                                         
                 EXX                        ;2F0E D9                                                                           
                 RR    H                    ;2F0F CB1C                                                                         
                 RR    L                    ;2F11 CB1D                                                                         
                 EXX                        ;2F13 D9                                                                           
                 LD    A,(L2D49)            ;2F14 3A492D                                                                       
                 INC   A                    ;2F17 3C                                                                           
                 LD    (L2D49),A            ;2F18 32492D                                                                       
L2F1B:           EXX                        ;2F1B D9                                                                           
L2F1C:           PUSH  HL                   ;2F1C E5                                                                           
                 EXX                        ;2F1D D9                                                                           
                 LD    B,H                  ;2F1E 44                                                                           
                 LD    C,L                  ;2F1F 4D                                                                           
                 POP   DE                   ;2F20 D1                                                                           
                 JP    L2E0B                ;2F21 C30B2E                                                                       

L2F24:           LD    A,E                  ;2F24 7B                                                                           
                 LD    E,D                  ;2F25 5A                                                                           
                 LD    D,0                  ;2F26 1600                                                                         
                 EXX                        ;2F28 D9                                                                           
                 LD    B,E                  ;2F29 43                                                                           
                 LD    E,D                  ;2F2A 5A                                                                           
                 LD    D,A                  ;2F2B 57                                                                           
                 EXX                        ;2F2C D9                                                                           
                 JP    L2ED3                ;2F2D C3D32E                                                                       

L2F30:           PUSH  DE                   ;2F30 D5                                                                           
                 LD    A,(DE)               ;2F31 1A                                                                           
                 XOR   (HL)                 ;2F32 AE                                                                           
                 CPL                        ;2F33 2F                                                                           
                 AND   128                  ;2F34 E680                                                                         
                 LD    (L2D48),A            ;2F36 32482D                                                                       
                 LD    B,(HL)               ;2F39 46                                                                           
                 RES   7,B                  ;2F3A CBB8                                                                         
                 LD    A,(DE)               ;2F3C 1A                                                                           
                 AND   127                  ;2F3D E67F                                                                         
                 SUB   B                    ;2F3F 90                                                                           
                 ADD   A,129                ;2F40 C681                                                                         
L2F42:           CP    48                   ;2F42 FE30                                                                         
                 JP    C,L2DE0              ;2F44 DAE02D                                                                       
                 CP    224                  ;2F47 FEE0                                                                         
                 JP    NC,L1398             ;2F49 D29813                                                                       
                 LD    (L2D49),A            ;2F4C 32492D                                                                       
                 INC   HL                   ;2F4F 23                                                                           
                 INC   DE                   ;2F50 13                                                                           
                 EX    DE,HL                ;2F51 EB                                                                           
                 LD    C,(HL)               ;2F52 4E                                                                           
                 INC   HL                   ;2F53 23                                                                           
                 LD    B,(HL)               ;2F54 46                                                                           
                 INC   HL                   ;2F55 23                                                                           
                 PUSH  HL                   ;2F56 E5                                                                           
                 EX    DE,HL                ;2F57 EB                                                                           
                 LD    E,(HL)               ;2F58 5E                                                                           
                 INC   HL                   ;2F59 23                                                                           
                 LD    D,(HL)               ;2F5A 56                                                                           
                 INC   HL                   ;2F5B 23                                                                           
                 LD    A,L                  ;2F5C 7D                                                                           
                 EX    AF,AF'               ;2F5D 08                                                                           
                 LD    A,H                  ;2F5E 7C                                                                           
                 LD    H,B                  ;2F5F 60                                                                           
                 LD    L,C                  ;2F60 69                                                                           
                 EXX                        ;2F61 D9                                                                           
                 POP   HL                   ;2F62 E1                                                                           
                 LD    C,(HL)               ;2F63 4E                                                                           
                 INC   HL                   ;2F64 23                                                                           
                 LD    B,(HL)               ;2F65 46                                                                           
                 LD    H,A                  ;2F66 67                                                                           
                 EX    AF,AF'               ;2F67 08                                                                           
                 LD    L,A                  ;2F68 6F                                                                           
                 LD    E,(HL)               ;2F69 5E                                                                           
                 INC   HL                   ;2F6A 23                                                                           
                 LD    D,(HL)               ;2F6B 56                                                                           
                 LD    H,B                  ;2F6C 60                                                                           
                 LD    L,C                  ;2F6D 69                                                                           
                 LD    A,D                  ;2F6E 7A                                                                           
                 OR    A                    ;2F6F B7                                                                           
                 JP    P,L1398              ;2F70 F29813                                                                       
                 LD    C,4                  ;2F73 0E04                                                                         
L2F75:           LD    B,8                  ;2F75 0608                                                                         
L2F77:           BIT   7,H                  ;2F77 CB7C                                                                         
                 JP    NZ,L2F95             ;2F79 C2952F                                                                       
                 OR    A                    ;2F7C B7                                                                           
L2F7D:           RLA                        ;2F7D 17                                                                           
                 EXX                        ;2F7E D9                                                                           
                 ADD   HL,HL                ;2F7F 29                                                                           
                 EXX                        ;2F80 D9                                                                           
                 ADC   HL,HL                ;2F81 ED6A                                                                         
                 DJNZ  L2F77                ;2F83 10F2                                                                         
                 PUSH  AF                   ;2F85 F5                                                                           
                 DEC   C                    ;2F86 0D                                                                           
                 JP    NZ,L2F75             ;2F87 C2752F                                                                       
L2F8A:           POP   AF                   ;2F8A F1                                                                           
                 LD    E,A                  ;2F8B 5F                                                                           
                 POP   AF                   ;2F8C F1                                                                           
                 LD    D,A                  ;2F8D 57                                                                           
                 POP   AF                   ;2F8E F1                                                                           
                 LD    C,A                  ;2F8F 4F                                                                           
                 POP   AF                   ;2F90 F1                                                                           
                 LD    B,A                  ;2F91 47                                                                           
                 JP    L2E0B                ;2F92 C30B2E                                                                       

L2F95:           EXX                        ;2F95 D9                                                                           
                 OR    A                    ;2F96 B7                                                                           
                 SBC   HL,DE                ;2F97 ED52                                                                         
                 EXX                        ;2F99 D9                                                                           
                 SBC   HL,DE                ;2F9A ED52                                                                         
                 CCF                        ;2F9C 3F                                                                           
                 JP    C,L2F7D              ;2F9D DA7D2F                                                                       
                 EXX                        ;2FA0 D9                                                                           
                 ADD   HL,DE                ;2FA1 19                                                                           
                 EXX                        ;2FA2 D9                                                                           
                 ADC   HL,DE                ;2FA3 ED5A                                                                         
                 OR    A                    ;2FA5 B7                                                                           
                 RLA                        ;2FA6 17                                                                           
                 EXX                        ;2FA7 D9                                                                           
                 ADD   HL,HL                ;2FA8 29                                                                           
                 EXX                        ;2FA9 D9                                                                           
                 ADC   HL,HL                ;2FAA ED6A                                                                         
                 DEC   B                    ;2FAC 05                                                                           
                 JP    NZ,L2FB7             ;2FAD C2B72F                                                                       
                 PUSH  AF                   ;2FB0 F5                                                                           
                 LD    B,8                  ;2FB1 0608                                                                         
                 DEC   C                    ;2FB3 0D                                                                           
                 JP    Z,L2F8A              ;2FB4 CA8A2F                                                                       
L2FB7:           EXX                        ;2FB7 D9                                                                           
                 OR    A                    ;2FB8 B7                                                                           
                 SBC   HL,DE                ;2FB9 ED52                                                                         
                 EXX                        ;2FBB D9                                                                           
                 SBC   HL,DE                ;2FBC ED52                                                                         
                 SCF                        ;2FBE 37                                                                           
                 RLA                        ;2FBF 17                                                                           
                 DEC   B                    ;2FC0 05                                                                           
                 JP    NZ,L2FCB             ;2FC1 C2CB2F                                                                       
                 PUSH  AF                   ;2FC4 F5                                                                           
                 LD    B,8                  ;2FC5 0608                                                                         
                 DEC   C                    ;2FC7 0D                                                                           
                 JP    Z,L2F8A              ;2FC8 CA8A2F                                                                       
L2FCB:           EXX                        ;2FCB D9                                                                           
                 ADD   HL,HL                ;2FCC 29                                                                           
                 EXX                        ;2FCD D9                                                                           
                 ADC   HL,HL                ;2FCE ED6A                                                                         
                 JP    NC,L2F77             ;2FD0 D2772F                                                                       
                 JP    L2FB7                ;2FD3 C3B72F                                                                       

L2FD6:           DB    9DH                  ;2FD6 9D                                                                           
L2FD7:           DW    03A23H               ;2FD7 233A                                                                         
L2FD9:           LD    A,(HL)               ;2FD9 7E                                                                           
                 PUSH  HL                   ;2FDA E5                                                                           
                 POP   IX                   ;2FDB DDE1                                                                         
                 EX    DE,HL                ;2FDD EB                                                                           
                 LD    (L2FD7),HL           ;2FDE 22D72F                                                                       
                 EX    AF,AF'               ;2FE1 08                                                                           
                 XOR   A                    ;2FE2 AF                                                                           
                 LD    (L2FD6),A            ;2FE3 32D62F                                                                       
                 LD    H,A                  ;2FE6 67                                                                           
                 LD    L,A                  ;2FE7 6F                                                                           
                 EXX                        ;2FE8 D9                                                                           
                 LD    H,A                  ;2FE9 67                                                                           
                 LD    L,A                  ;2FEA 6F                                                                           
                 LD    B,A                  ;2FEB 47                                                                           
                 LD    C,A                  ;2FEC 4F                                                                           
                 EX    AF,AF'               ;2FED 08                                                                           
                 CP    46                   ;2FEE FE2E                                                                         
                 JP    Z,L3008              ;2FF0 CA0830                                                                       
                 SUB   48                   ;2FF3 D630                                                                         
L2FF5:           CALL  L30E3                ;2FF5 CDE330                                                                       
                 CALL  L30D9                ;2FF8 CDD930                                                                       
                 SUB   48                   ;2FFB D630                                                                         
                 CP    10                   ;2FFD FE0A                                                                         
                 JR    C,L2FF5              ;2FFF 38F4                                                                         
                 ADD   A,48                 ;3001 C630                                                                         
                 CP    46                   ;3003 FE2E                                                                         
                 JP    NZ,L3019             ;3005 C21930                                                                       
L3008:           CALL  L30D9                ;3008 CDD930                                                                       
                 SUB   48                   ;300B D630                                                                         
                 CP    10                   ;300D FE0A                                                                         
                 JP    NC,L3017             ;300F D21730                                                                       
                 CALL  L30F2                ;3012 CDF230                                                                       
                 JR    L3008                ;3015 18F1                                                                         

L3017:           ADD   A,48                 ;3017 C630                                                                         
L3019:           CP    69                   ;3019 FE45                                                                         
                 JP    NZ,L3064             ;301B C26430                                                                       
                 EXX                        ;301E D9                                                                           
                 CALL  L30D9                ;301F CDD930                                                                       
                 LD    B,1                  ;3022 0601                                                                         
                 CP    188                  ;3024 FEBC                                                                         
                 JR    Z,L302E              ;3026 2806                                                                         
                 CP    189                  ;3028 FEBD                                                                         
                 JP    NZ,L138E             ;302A C28E13                                                                       
                 DEC   B                    ;302D 05                                                                           
L302E:           LD    A,B                  ;302E 78                                                                           
                 OR    A                    ;302F B7                                                                           
                 EX    AF,AF'               ;3030 08                                                                           
L3031:           CALL  L30D9                ;3031 CDD930                                                                       
                 SUB   48                   ;3034 D630                                                                         
                 JR    Z,L3031              ;3036 28F9                                                                         
                 CP    10                   ;3038 FE0A                                                                         
                 JP    NC,L305A             ;303A D25A30                                                                       
                 LD    B,A                  ;303D 47                                                                           
                 CALL  L30D9                ;303E CDD930                                                                       
                 SUB   48                   ;3041 D630                                                                         
                 CP    10                   ;3043 FE0A                                                                         
                 JP    NC,L305A             ;3045 D25A30                                                                       
                 LD    C,A                  ;3048 4F                                                                           
                 CALL  L30D9                ;3049 CDD930                                                                       
                 SUB   48                   ;304C D630                                                                         
                 CP    10                   ;304E FE0A                                                                         
                 JP    C,L1398              ;3050 DA9813                                                                       
                 LD    A,B                  ;3053 78                                                                           
                 ADD   A,A                  ;3054 87                                                                           
                 ADD   A,A                  ;3055 87                                                                           
                 ADD   A,B                  ;3056 80                                                                           
                 ADD   A,A                  ;3057 87                                                                           
                 ADD   A,C                  ;3058 81                                                                           
                 LD    B,A                  ;3059 47                                                                           
L305A:           EX    AF,AF'               ;305A 08                                                                           
                 LD    A,B                  ;305B 78                                                                           
                 JR    NZ,L3060             ;305C 2002                                                                         
                 CPL                        ;305E 2F                                                                           
                 INC   A                    ;305F 3C                                                                           
L3060:           LD    (L2FD6),A            ;3060 32D62F                                                                       
                 EXX                        ;3063 D9                                                                           
L3064:           PUSH  IX                   ;3064 DDE5                                                                         
                 LD    A,(L2FD6)            ;3066 3AD62F                                                                       
                 ADD   A,29                 ;3069 C61D                                                                         
                 ADD   A,C                  ;306B 81                                                                           
                 LD    (L2FD6),A            ;306C 32D62F                                                                       
                 CP    48                   ;306F FE30                                                                         
                 JP    C,L307C              ;3071 DA7C30                                                                       
                 CP    128                  ;3074 FE80                                                                         
                 JP    C,L1398              ;3076 DA9813                                                                       
                 JP    L30CE                ;3079 C3CE30                                                                       

L307C:           LD    A,128                ;307C 3E80                                                                         
                 LD    (L2D48),A            ;307E 32482D                                                                       
                 LD    A,160                ;3081 3EA0                                                                         
                 LD    (L2D49),A            ;3083 32492D                                                                       
                 PUSH  HL                   ;3086 E5                                                                           
                 EXX                        ;3087 D9                                                                           
                 POP   BC                   ;3088 C1                                                                           
                 LD    D,H                  ;3089 54                                                                           
                 LD    E,L                  ;308A 5D                                                                           
                 LD    HL,L3096             ;308B 219630                                                                       
                 PUSH  HL                   ;308E E5                                                                           
                 LD    HL,(L2FD7)           ;308F 2AD72F                                                                       
                 PUSH  HL                   ;3092 E5                                                                           
                 JP    L2E0B                ;3093 C30B2E                                                                       

L3096:           DB    3AH,0D6H,2FH,6FH     ;3096 3AD62F6F  Link 3096 found at , $308C                                         
                 DB    4FH,26H,00H,44H      ;309A 4F260044                                                                     
                 DB    29H,29H,09H,01H      ;309E 29290901                                                                     
                 DB    20H,31H,09H,0EDH     ;30A2 203109ED                                                                     
                 DB    5BH,0D7H,2FH,3EH     ;30A6 5BD72F3E                                                                     
                 DB    80H,32H,48H,2DH      ;30AA 8032482D                                                                     
                 DB    3EH,20H,86H,47H      ;30AE 3E208647                                                                     
                 DB    1AH,0E6H,7FH,80H     ;30B2 1AE67F80                                                                     
                 DB    0DAH,98H,13H,0D6H    ;30B6 DA9813D6                                                                     
                 DB    21H,30H,01H,0AFH     ;30BA 213001AF                                                                     
                 DB    01H,0C6H,30H,0C5H    ;30BE 01C630C5                                                                     
                 DB    0D5H,0C3H,6DH,2EH    ;30C2 D5C36D2E                                                                     
L30C6:           DB    0E1H,01H,05H,00H     ;30C6 E1010500                                                                     
                 DB    50H,58H,7EH,0C9H     ;30CA 50587EC9                                                                     
L30CE:           LD    HL,L30C6             ;30CE 21C630                                                                       
                 PUSH  HL                   ;30D1 E5                                                                           
                 LD    HL,(L2FD7)           ;30D2 2AD72F                                                                       
                 PUSH  HL                   ;30D5 E5                                                                           
                 JP    L2DE0                ;30D6 C3E02D                                                                       

L30D9:           INC   IX                   ;30D9 DD23                                                                         
                 LD    A,(IX+0)             ;30DB DD7E00                                                                       
                 CP    32                   ;30DE FE20                                                                         
                 RET   NZ                   ;30E0 C0                                                                           
                 JR    L30D9                ;30E1 18F6                                                                         

L30E3:           OR    A                    ;30E3 B7                                                                           
                 JR    NZ,L30E9             ;30E4 2003                                                                         
                 OR    B                    ;30E6 B0                                                                           
                 RET   Z                    ;30E7 C8                                                                           
                 XOR   A                    ;30E8 AF                                                                           
L30E9:           EX    AF,AF'               ;30E9 08                                                                           
                 LD    A,B                  ;30EA 78                                                                           
                 CP    9                    ;30EB FE09                                                                         
                 JP    NZ,L3100             ;30ED C20031                                                                       
                 INC   C                    ;30F0 0C                                                                           
                 RET                        ;30F1 C9                                                                           

L30F2:           OR    A                    ;30F2 B7                                                                           
                 JR    NZ,L30FA             ;30F3 2005                                                                         
                 DEC   C                    ;30F5 0D                                                                           
L30F6:           OR    B                    ;30F6 B0                                                                           
                 RET   Z                    ;30F7 C8                                                                           
                 INC   C                    ;30F8 0C                                                                           
                 XOR   A                    ;30F9 AF                                                                           
L30FA:           EX    AF,AF'               ;30FA 08                                                                           
                 LD    A,B                  ;30FB 78                                                                           
                 CP    9                    ;30FC FE09                                                                         
                 RET   Z                    ;30FE C8                                                                           
                 DEC   C                    ;30FF 0D                                                                           
L3100:           INC   B                    ;3100 04                                                                           
                 LD    D,H                  ;3101 54                                                                           
                 LD    E,L                  ;3102 5D                                                                           
                 EXX                        ;3103 D9                                                                           
                 LD    D,H                  ;3104 54                                                                           
                 LD    E,L                  ;3105 5D                                                                           
                 XOR   A                    ;3106 AF                                                                           
                 ADD   HL,HL                ;3107 29                                                                           
                 RLA                        ;3108 17                                                                           
                 ADD   HL,HL                ;3109 29                                                                           
                 RLA                        ;310A 17                                                                           
                 ADD   HL,DE                ;310B 19                                                                           
                 LD    D,0                  ;310C 1600                                                                         
                 ADC   A,D                  ;310E 8A                                                                           
                 ADD   HL,HL                ;310F 29                                                                           
                 RLA                        ;3110 17                                                                           
                 EX    AF,AF'               ;3111 08                                                                           
                 LD    E,A                  ;3112 5F                                                                           
                 EX    AF,AF'               ;3113 08                                                                           
                 ADD   HL,DE                ;3114 19                                                                           
                 ADC   A,D                  ;3115 8A                                                                           
                 EXX                        ;3116 D9                                                                           
                 ADD   HL,HL                ;3117 29                                                                           
                 ADD   HL,HL                ;3118 29                                                                           
                 ADD   HL,DE                ;3119 19                                                                           
                 ADD   HL,HL                ;311A 29                                                                           
                 LD    D,0                  ;311B 1600                                                                         
                 LD    E,A                  ;311D 5F                                                                           
                 ADD   HL,DE                ;311E 19                                                                           
                 RET                        ;311F C9                                                                           

                 DB    0E0H,0F5H,0F7H,0D2H  ;3120 E0F5F7D2  Link 3120 found at , $30A2, $3487                                  
                 DB    0CAH,0E3H,0F3H,0B5H  ;3124 CAE3F3B5                                                                     
                 DB    87H,0FDH,0E7H,0B8H   ;3128 87FDE7B8                                                                     
                 DB    0D1H,74H,9EH,0EAH    ;312C D1749EEA                                                                     
                 DB    25H,06H,12H,0C6H     ;3130 250612C6                                                                     
                 DB    0EDH,0AFH,87H,96H    ;3134 EDAF8796                                                                     
                 DB    0F7H,0F1H,0CDH,14H   ;3138 F7F1CD14                                                                     
                 DB    0BEH,9AH,0F4H,01H    ;313C BE9AF401                                                                     
                 DB    9AH,6DH,0C1H,0F7H    ;3140 9A6DC1F7                                                                     
                 DB    81H,00H,0C9H,0F1H    ;3144 8100C9F1                                                                     
                 DB    0FBH,50H,0A0H,1DH    ;3148 FB50A01D                                                                     
                 DB    97H                  ;314C 97                                                                           
L314D:           DB    0FEH,65H,08H,0E5H    ;314D FE6508E5                                                                     
                 DB    0BCH,01H,7EH,4AH     ;3151 BC017E4A                                                                     
                 DB    1EH,0ECH,05H,8FH     ;3155 1EEC058F                                                                     
                 DB    0EEH,92H,93H,08H     ;3159 EE929308                                                                     
                 DB    32H,0AAH,77H,0B8H    ;315D 32AA77B8                                                                     
                 DB    0BH,0BFH,94H,95H     ;3161 0BBF9495                                                                     
                 DB    0E6H,0FH,0F7H,7CH    ;3165 E60FF77C                                                                     
                 DB    1DH,90H,12H,35H      ;3169 1D901235                                                                     
                 DB    0DCH,24H,0B4H,15H    ;316D DC24B415                                                                     
                 DB    42H,13H,2EH,0E1H     ;3171 42132EE1                                                                     
                 DB    19H,09H,0CCH,0BCH    ;3175 1909CCBC                                                                     
                 DB    8CH,1CH,0CH,0FFH     ;3179 8C1C0CFF                                                                     
                 DB    0EBH,0AFH,1FH,0CFH   ;317D EBAF1FCF                                                                     
                 DB    0FEH,0E6H,0DBH,23H   ;3181 FEE6DB23                                                                     
                 DB    41H,5FH,70H,89H      ;3185 415F7089                                                                     
                 DB    26H,12H,77H,0CCH     ;3189 261277CC                                                                     
                 DB    0ABH,29H,0D6H,94H    ;318D AB29D694                                                                     
                 DB    0BFH,0D6H,2DH,06H    ;3191 BFD62D06                                                                     
                 DB    0BDH,37H,86H,30H     ;3195 BD378630                                                                     
                 DB    47H,0ACH,0C5H,0A7H   ;3199 47ACC5A7                                                                     
                 DB    33H,59H,17H,0B7H     ;319D 335917B7                                                                     
                 DB    0D1H,37H,98H,6EH     ;31A1 D137986E                                                                     
                 DB    12H,83H,3AH,3DH      ;31A5 12833A3D                                                                     
                 DB    0AH,0D7H,0A3H,3DH    ;31A9 0AD7A33D                                                                     
                 DB    0CDH,0CCH,0CCH,0CCH  ;31AD CDCCCCCC                                                                     
                 DB    41H,00H,00H,00H      ;31B1 41000000                                                                     
                 DB    80H,44H,00H,00H      ;31B5 80440000                                                                     
                 DB    00H,0A0H,47H,00H     ;31B9 00A04700                                                                     
                 DB    00H,00H,0C8H,4AH     ;31BD 0000C84A                                                                     
                 DB    00H,00H,00H,0FAH     ;31C1 000000FA                                                                     
                 DB    4EH,00H,00H,40H      ;31C5 4E000040                                                                     
                 DB    9CH,51H,00H,00H      ;31C9 9C510000                                                                     
                 DB    50H,0C3H,54H,00H     ;31CD 50C35400                                                                     
                 DB    00H,24H,0F4H,58H     ;31D1 0024F458                                                                     
                 DB    00H,80H,96H,98H      ;31D5 00809698                                                                     
                 DB    5BH,00H,20H,0BCH     ;31D9 5B0020BC                                                                     
                 DB    0BEH,5EH,00H,28H     ;31DD BE5E0028                                                                     
                 DB    6BH,0EEH,62H,00H     ;31E1 6BEE6200                                                                     
                 DB    0F9H,02H,95H,65H     ;31E5 F9029565                                                                     
                 DB    40H,0B7H,43H,0BAH    ;31E9 40B743BA                                                                     
                 DB    68H,10H,0A5H,0D4H    ;31ED 6810A5D4                                                                     
                 DB    0E8H,6CH,2AH,0E7H    ;31F1 E86C2AE7                                                                     
                 DB    84H,91H,6FH,0F5H     ;31F5 84916FF5                                                                     
                 DB    20H,0E6H,0B5H,72H    ;31F9 20E6B572                                                                     
                 DB    32H,0A9H,5FH,0E3H    ;31FD 32A95FE3                                                                     
                 DB    76H,0BFH,0C9H,1BH    ;3201 76BFC91B                                                                     
                 DB    8EH,79H,2FH,0BCH     ;3205 8E792FBC                                                                     
                 DB    0A2H,0B1H,7CH,3AH    ;3209 A2B17C3A                                                                     
                 DB    6BH,0BH,0DEH,80H     ;320D 6B0BDE80                                                                     
                 DB    05H,23H,0C7H,8AH     ;3211 0523C78A                                                                     
L3215:           DW    02D54H               ;3215 542D                                                                         
L3217:           DB    22H                  ;3217 22  Link 3217 found at , $3232, $325F, $32EE, $3344, $33E2, $33E6, $3427, $34
L3218:           DB    03H                  ;3218 03                                                                           
L3219:           DB    64H                  ;3219 64                                                                           
L321A:           DB    0C3H,0FFH,29H,0CDH   ;321A C3FF29CD                                                                     
                 DB    42H,26H,0D6H         ;321E 4226D6                                                                       
L3221:           DB    "A"                  ;3221 41                                                                           
L3222:           DB    0FEH                 ;3222 FE                                                                           
L3223:           DB    1AH                  ;3223 1A  Link 3223 found at , $32DD, $3DFD, $3E3C                                 
L3224:           DB    0D2H,8EH,23H,5EH     ;3224 D28E235E                                                                     
                 DB    23H,0CDH,0B2H,26H    ;3228 23CDB226                                                                     
                 DB    28H                  ;322C 28                                                                           
L322D:           PUSH  DE                   ;322D D5                                                                           
                 CALL  L3316                ;322E CD1633                                                                       
                 LD    A,(L3217)            ;3231 3A1732                                                                       
                 OR    A                    ;3234 B7                                                                           
                 JP    Z,L32DC              ;3235 CADC32                                                                       
                 JP    M,L3242              ;3238 FA4232                                                                       
                 CP    9                    ;323B FE09                                                                         
                 JP    C,L32A1              ;323D DAA132                                                                       
                 JR    L3247                ;3240 1805                                                                         

L3242:           CP    255                  ;3242 FEFF                                                                         
                 JP    NC,L32D6             ;3244 D2D632                                                                       
L3247:           LD    A,46                 ;3247 3E2E                                                                         
                 LD    (L3219),A            ;3249 321932                                                                       
                 LD    HL,L3222             ;324C 212232                                                                       
                 XOR   A                    ;324F AF                                                                           
L3250:           DEC   HL                   ;3250 2B                                                                           
                 CP    (HL)                 ;3251 BE                                                                           
                 JR    Z,L3250              ;3252 28FC                                                                         
                 LD    A,(HL)               ;3254 7E                                                                           
                 CP    46                   ;3255 FE2E                                                                         
                 JP    Z,L3309              ;3257 CA0933                                                                       
                 INC   HL                   ;325A 23                                                                           
                 LD    (HL),69              ;325B 3645                                                                         
                 INC   HL                   ;325D 23                                                                           
                 LD    A,(L3217)            ;325E 3A1732                                                                       
                 LD    B,43                 ;3261 062B                                                                         
                 OR    A                    ;3263 B7                                                                           
                 JP    P,L3270              ;3264 F27032                                                                       
                 CP    237                  ;3267 FEED                                                                         
                 JP    C,L3309              ;3269 DA0933                                                                       
                 LD    B,45                 ;326C 062D                                                                         
                 CPL                        ;326E 2F                                                                           
                 INC   A                    ;326F 3C                                                                           
L3270:           LD    (HL),B               ;3270 70                                                                           
                 INC   HL                   ;3271 23                                                                           
                 LD    BC,LFF0A             ;3272 010AFF                                                                       
L3275:           INC   B                    ;3275 04                                                                           
                 SUB   C                    ;3276 91                                                                           
                 JR    NC,L3275             ;3277 30FC                                                                         
                 ADD   A,C                  ;3279 81                                                                           
                 LD    (HL),B               ;327A 70                                                                           
                 INC   HL                   ;327B 23                                                                           
                 LD    (HL),A               ;327C 77                                                                           
                 INC   HL                   ;327D 23                                                                           
                 LD    (HL),13              ;327E 360D                                                                         
L3280:           LD    HL,L3218             ;3280 211832                                                                       
L3283:           INC   HL                   ;3283 23                                                                           
                 LD    A,(HL)               ;3284 7E                                                                           
                 CP    13                   ;3285 FE0D                                                                         
                 JP    Z,L3293              ;3287 CA9332                                                                       
                 JP    NC,L3283             ;328A D28332                                                                       
                 OR    48                   ;328D F630                                                                         
                 LD    (HL),A               ;328F 77                                                                           
                 JP    L3283                ;3290 C38332                                                                       

L3293:           LD    DE,L3218             ;3293 111832                                                                       
                 XOR   A                    ;3296 AF                                                                           
                 SBC   HL,DE                ;3297 ED52                                                                         
                 LD    B,H                  ;3299 44                                                                           
                 LD    C,L                  ;329A 4D                                                                           
                 POP   HL                   ;329B E1                                                                           
                 EX    DE,HL                ;329C EB                                                                           
                 INC   BC                   ;329D 03                                                                           
                 LDIR                       ;329E EDB0                                                                         
                 RET                        ;32A0 C9                                                                           

L32A1:           LD    HL,L321A             ;32A1 211A32                                                                       
                 LD    DE,L3219             ;32A4 111932                                                                       
                 LD    B,A                  ;32A7 47                                                                           
                 INC   B                    ;32A8 04                                                                           
L32A9:           DEC   B                    ;32A9 05                                                                           
                 JP    Z,L32B4              ;32AA CAB432                                                                       
                 LD    A,(HL)               ;32AD 7E                                                                           
                 LD    (DE),A               ;32AE 12                                                                           
                 INC   HL                   ;32AF 23                                                                           
                 INC   DE                   ;32B0 13                                                                           
                 JP    L32A9                ;32B1 C3A932                                                                       

L32B4:           LD    A,46                 ;32B4 3E2E                                                                         
                 LD    (DE),A               ;32B6 12                                                                           
                 LD    HL,L3222             ;32B7 212232                                                                       
L32BA:           LD    (HL),13              ;32BA 360D                                                                         
                 DEC   HL                   ;32BC 2B                                                                           
                 LD    A,(HL)               ;32BD 7E                                                                           
                 OR    A                    ;32BE B7                                                                           
                 JR    Z,L32BA              ;32BF 28F9                                                                         
                 CP    46                   ;32C1 FE2E                                                                         
                 JP    NZ,L32C8             ;32C3 C2C832                                                                       
                 LD    (HL),13              ;32C6 360D                                                                         
L32C8:           LD    HL,L3219             ;32C8 211932                                                                       
                 LD    A,(HL)               ;32CB 7E                                                                           
                 CP    13                   ;32CC FE0D                                                                         
                 JP    NZ,L3280             ;32CE C28032                                                                       
                 LD    (HL),0               ;32D1 3600                                                                         
                 JP    L3280                ;32D3 C38032                                                                       

L32D6:           LD    DE,L3224             ;32D6 112432                                                                       
                 JP    L32DF                ;32D9 C3DF32                                                                       

L32DC:           LD    DE,L3223             ;32DC 112332                                                                       
L32DF:           LD    HL,L3221             ;32DF 212132                                                                       
                 LD    A,13                 ;32E2 3E0D                                                                         
                 LD    (DE),A               ;32E4 12                                                                           
                 PUSH  DE                   ;32E5 D5                                                                           
                 DEC   DE                   ;32E6 1B                                                                           
                 LD    BC,L0008             ;32E7 010800                                                                       
                 LDDR                       ;32EA EDB8                                                                         
                 EX    DE,HL                ;32EC EB                                                                           
                 LD    A,(L3217)            ;32ED 3A1732                                                                       
                 OR    A                    ;32F0 B7                                                                           
                 JP    Z,L32F7              ;32F1 CAF732                                                                       
                 LD    (HL),0               ;32F4 3600                                                                         
                 DEC   HL                   ;32F6 2B                                                                           
L32F7:           LD    (HL),46              ;32F7 362E                                                                         
                 DEC   HL                   ;32F9 2B                                                                           
                 LD    (HL),0               ;32FA 3600                                                                         
                 POP   HL                   ;32FC E1                                                                           
L32FD:           DEC   HL                   ;32FD 2B                                                                           
                 LD    A,(HL)               ;32FE 7E                                                                           
                 CP    0                    ;32FF FE00                                                                         
                 JP    NZ,L3280             ;3301 C28032                                                                       
                 LD    (HL),13              ;3304 360D                                                                         
                 JP    L32FD                ;3306 C3FD32                                                                       

L3309:           LD    HL,L3313             ;3309 211333                                                                       
                 LD    BC,USER              ;330C 010300                                                                       
                 POP   DE                   ;330F D1                                                                           
                 LDIR                       ;3310 EDB0                                                                         
                 RET                        ;3312 C9                                                                           

L3313:           DB    " 0"                 ;3313 2030                                                                         
                 DB    0DH                  ;3315 0D                                                                           
L3316:           LD    (L3215),HL           ;3316 221532                                                                       
                 LD    A,(HL)               ;3319 7E                                                                           
                 LD    B,32                 ;331A 0620                                                                         
                 OR    A                    ;331C B7                                                                           
                 JP    M,L3322              ;331D FA2233                                                                       
                 LD    B,45                 ;3320 062D                                                                         
L3322:           AND   127                  ;3322 E67F                                                                         
                 LD    (HL),A               ;3324 77                                                                           
                 LD    A,B                  ;3325 78                                                                           
                 LD    (L3218),A            ;3326 321832                                                                       
                 EX    DE,HL                ;3329 EB                                                                           
                 LD    HL,L314D             ;332A 214D31                                                                       
                 LD    A,236                ;332D 3EEC                                                                         
                 EX    AF,AF'               ;332F 08                                                                           
L3330:           EX    AF,AF'               ;3330 08                                                                           
                 INC   A                    ;3331 3C                                                                           
                 EX    AF,AF'               ;3332 08                                                                           
                 LD    BC,L0005             ;3333 010500                                                                       
                 ADD   HL,BC                ;3336 09                                                                           
                 PUSH  HL                   ;3337 E5                                                                           
                 PUSH  DE                   ;3338 D5                                                                           
                 LD    A,(DE)               ;3339 1A                                                                           
                 CALL  L33FB                ;333A CDFB33                                                                       
                 POP   DE                   ;333D D1                                                                           
                 POP   HL                   ;333E E1                                                                           
                 JP    NC,L3330             ;333F D23033                                                                       
                 EX    AF,AF'               ;3342 08                                                                           
                 LD    (L3217),A            ;3343 321732                                                                       
                 PUSH  DE                   ;3346 D5                                                                           
                 LD    BC,L3358             ;3347 015833                                                                       
                 PUSH  BC                   ;334A C5                                                                           
                 PUSH  DE                   ;334B D5                                                                           
                 LD    A,128                ;334C 3E80                                                                         
                 LD    (L2D48),A            ;334E 32482D                                                                       
                 LD    A,(DE)               ;3351 1A                                                                           
                 SUB   (HL)                 ;3352 96                                                                           
                 ADD   A,129                ;3353 C681                                                                         
                 JP    L2F42                ;3355 C3422F                                                                       

L3358:           DB    21H,19H,32H,36H      ;3358 21193236  Link 3358 found at , $3348                                         
                 DB    00H,23H,0E3H,7EH     ;335C 0023E37E                                                                     
                 DB    23H,5EH,23H,56H      ;3360 235E2356                                                                     
                 DB    23H,0E5H,0EBH,0D9H   ;3364 23E5EBD9                                                                     
                 DB    0E1H,5EH,23H,56H     ;3368 E15E2356                                                                     
                 DB    0EBH,0D6H,0C0H,0D2H  ;336C EBD6C0D2                                                                     
                 DB    80H,33H,0CBH,3CH     ;3370 8033CB3C                                                                     
                 DB    0CBH,1DH,0D9H,0CBH   ;3374 CB1DD9CB                                                                     
                 DB    1CH,0CBH,1DH,0D9H    ;3378 1CCB1DD9                                                                     
                 DB    3CH,0C2H,72H,33H     ;337C 3CC27233                                                                     
                 DB    0C1H,3EH,09H,08H     ;3380 C13E0908                                                                     
                 DB    0AFH,54H,5DH,0D9H    ;3384 AF545DD9                                                                     
                 DB    54H,5DH,29H,0D9H     ;3388 545D29D9                                                                     
                 DB    0EDH,6AH,17H,0D9H    ;338C ED6A17D9                                                                     
                 DB    29H,0D9H,0EDH,6AH    ;3390 29D9ED6A                                                                     
                 DB    17H,0D9H,19H,0D9H    ;3394 17D919D9                                                                     
                 DB    0EDH,5AH,16H,00H     ;3398 ED5A1600                                                                     
                 DB    8AH,0D9H,29H,0D9H    ;339C 8AD929D9                                                                     
                 DB    0EDH,6AH,17H,02H     ;33A0 ED6A1702                                                                     
                 DB    03H,08H,3DH,0C2H     ;33A4 03083DC2                                                                     
                 DB    83H,33H,21H,22H      ;33A8 83332122                                                                     
                 DB    32H,7EH,36H,00H      ;33AC 327E3600                                                                     
                 DB    0FEH,05H,0EH,00H     ;33B0 FE050E00                                                                     
                 DB    0DAH,0B8H,33H,0CH    ;33B4 DAB8330C                                                                     
                 DB    06H,0AH,05H,0CAH     ;33B8 060A05CA                                                                     
                 DB    0CEH,33H,2BH,7EH     ;33BC CE332B7E                                                                     
                 DB    81H,77H,0D6H,0AH     ;33C0 8177D60A                                                                     
                 DB    0EH,00H,0DAH,0BAH    ;33C4 0E00DABA                                                                     
                 DB    33H,0CH,77H,0C3H     ;33C8 330C77C3                                                                     
                 DB    0BAH,33H,3AH,19H     ;33CC BA333A19                                                                     
                 DB    32H,0B7H,0C8H,21H    ;33D0 32B7C821                                                                     
                 DB    21H,32H,11H,22H      ;33D4 21321122                                                                     
                 DB    32H,01H,09H,00H      ;33D8 32010900                                                                     
                 DB    0EDH,0B8H,0EBH,36H   ;33DC EDB8EB36                                                                     
                 DB    00H,3AH,17H,32H      ;33E0 003A1732                                                                     
                 DB    3CH,32H,17H,32H      ;33E4 3C321732                                                                     
                 DB    0C3H,0AAH,33H        ;33E8 C3AA33                                                                       
L33EB:           LD    BC,L0005             ;33EB 010500                                                                       
L33EE:           LD    A,(DE)               ;33EE 1A                                                                           
                 OR    A                    ;33EF B7                                                                           
                 JP    M,L33FB              ;33F0 FAFB33                                                                       
                 BIT   7,(HL)               ;33F3 CB7E                                                                         
                 JR    Z,L33F9              ;33F5 2802                                                                         
                 SCF                        ;33F7 37                                                                           
                 RET                        ;33F8 C9                                                                           

L33F9:           EX    DE,HL                ;33F9 EB                                                                           
                 LD    A,(DE)               ;33FA 1A                                                                           
L33FB:           CP    (HL)                 ;33FB BE                                                                           
                 RET   NZ                   ;33FC C0                                                                           
                 DEC   C                    ;33FD 0D                                                                           
                 ADD   HL,BC                ;33FE 09                                                                           
                 EX    DE,HL                ;33FF EB                                                                           
                 ADD   HL,BC                ;3400 09                                                                           
                 EX    DE,HL                ;3401 EB                                                                           
                 LD    B,3                  ;3402 0603                                                                         
L3404:           LD    A,(DE)               ;3404 1A                                                                           
                 CP    (HL)                 ;3405 BE                                                                           
                 RET   NZ                   ;3406 C0                                                                           
                 DEC   HL                   ;3407 2B                                                                           
                 DEC   DE                   ;3408 1B                                                                           
                 DJNZ  L3404                ;3409 10F9                                                                         
                 LD    A,(DE)               ;340B 1A                                                                           
                 CP    (HL)                 ;340C BE                                                                           
                 RET                        ;340D C9                                                                           

L340E:           EX    DE,HL                ;340E EB                                                                           
                 CALL  L3316                ;340F CD1633                                                                       
                 LD    A,(L3218)            ;3412 3A1832                                                                       
                 LD    B,128                ;3415 0680                                                                         
                 CP    32                   ;3417 FE20                                                                         
                 JP    Z,L341E              ;3419 CA1E34                                                                       
                 LD    B,0                  ;341C 0600                                                                         
L341E:           LD    A,B                  ;341E 78                                                                           
                 LD    (L2D48),A            ;341F 32482D                                                                       
                 OR    A                    ;3422 B7                                                                           
                 JP    Z,L34A7              ;3423 CAA734                                                                       
                 LD    A,(L3217)            ;3426 3A1732                                                                       
                 DEC   A                    ;3429 3D                                                                           
                 JP    M,L34DF              ;342A FADF34                                                                       
                 LD    HL,L3222             ;342D 212232                                                                       
                 LD    B,13                 ;3430 060D                                                                         
                 LD    (HL),B               ;3432 70                                                                           
                 SUB   8                    ;3433 D608                                                                         
                 JR    NC,L343D             ;3435 3006                                                                         
L3437:           LD    (HL),B               ;3437 70                                                                           
                 DEC   HL                   ;3438 2B                                                                           
                 INC   A                    ;3439 3C                                                                           
                 JR    NZ,L3437             ;343A 20FB                                                                         
                 DEC   A                    ;343C 3D                                                                           
L343D:           INC   A                    ;343D 3C                                                                           
                 LD    (L2FD6),A            ;343E 32D62F                                                                       
                 LD    IX,L3219             ;3441 DD211932                                                                     
                 XOR   A                    ;3445 AF                                                                           
                 LD    H,A                  ;3446 67                                                                           
                 LD    L,A                  ;3447 6F                                                                           
                 EXX                        ;3448 D9                                                                           
                 LD    B,A                  ;3449 47                                                                           
                 LD    C,A                  ;344A 4F                                                                           
                 LD    H,A                  ;344B 67                                                                           
                 LD    L,A                  ;344C 6F                                                                           
L344D:           LD    A,(IX+0)             ;344D DD7E00                                                                       
                 CP    13                   ;3450 FE0D                                                                         
                 JP    Z,L345D              ;3452 CA5D34                                                                       
                 CALL  L30E3                ;3455 CDE330                                                                       
                 INC   IX                   ;3458 DD23                                                                         
                 JP    L344D                ;345A C34D34                                                                       

L345D:           LD    A,(L2FD6)            ;345D 3AD62F                                                                       
                 ADD   A,29                 ;3460 C61D                                                                         
                 ADD   A,C                  ;3462 81                                                                           
                 LD    (L2FD6),A            ;3463 32D62F                                                                       
                 LD    A,160                ;3466 3EA0                                                                         
                 LD    (L2D49),A            ;3468 32492D                                                                       
                 PUSH  HL                   ;346B E5                                                                           
                 EXX                        ;346C D9                                                                           
                 POP   BC                   ;346D C1                                                                           
                 LD    D,H                  ;346E 54                                                                           
                 LD    E,L                  ;346F 5D                                                                           
                 LD    HL,L347B             ;3470 217B34                                                                       
                 PUSH  HL                   ;3473 E5                                                                           
                 LD    HL,(L3215)           ;3474 2A1532                                                                       
                 PUSH  HL                   ;3477 E5                                                                           
                 JP    L2E0B                ;3478 C30B2E                                                                       

L347B:           DB    3AH,0D6H,2FH,4FH     ;347B 3AD62F4F  Link 347B found at , $3471                                         
                 DB    6FH,26H,00H,44H      ;347F 6F260044                                                                     
                 DB    29H,29H,09H,01H      ;3483 29290901                                                                     
                 DB    20H,31H,09H,0EDH     ;3487 203109ED                                                                     
                 DB    5BH,15H,32H,0AFH     ;348B 5B1532AF                                                                     
                 DB    32H,47H,2DH,3EH      ;348F 32472D3E                                                                     
                 DB    20H,86H,47H,1AH      ;3493 2086471A                                                                     
                 DB    0E6H,7FH,80H,0DAH    ;3497 E67F80DA                                                                     
                 DB    98H,13H,0D6H,21H     ;349B 9813D621                                                                     
                 DB    0D2H,0A3H,34H,0AFH   ;349F D2A334AF                                                                     
                 DB    0D5H,0C3H,6DH,2EH    ;34A3 D5C36D2E                                                                     
L34A7:           LD    A,(L3217)            ;34A7 3A1732                                                                       
                 DEC   A                    ;34AA 3D                                                                           
                 JP    M,L34E4              ;34AB FAE434                                                                       
                 LD    HL,L3222             ;34AE 212232                                                                       
                 LD    BC,L0D00             ;34B1 01000D                                                                       
                 LD    (HL),B               ;34B4 70                                                                           
                 SUB   8                    ;34B5 D608                                                                         
                 JP    NC,L34CA             ;34B7 D2CA34                                                                       
                 JP    L34C5                ;34BA C3C534                                                                       

L34BD:           EX    AF,AF'               ;34BD 08                                                                           
                 LD    A,(HL)               ;34BE 7E                                                                           
                 OR    A                    ;34BF B7                                                                           
                 JR    Z,L34C3              ;34C0 2801                                                                         
                 INC   C                    ;34C2 0C                                                                           
L34C3:           LD    (HL),B               ;34C3 70                                                                           
                 EX    AF,AF'               ;34C4 08                                                                           
L34C5:           DEC   HL                   ;34C5 2B                                                                           
                 INC   A                    ;34C6 3C                                                                           
                 JR    NZ,L34BD             ;34C7 20F4                                                                         
                 DEC   A                    ;34C9 3D                                                                           
L34CA:           EX    AF,AF'               ;34CA 08                                                                           
                 LD    A,C                  ;34CB 79                                                                           
                 OR    A                    ;34CC B7                                                                           
                 JR    Z,L34DB              ;34CD 280C                                                                         
L34CF:           LD    A,(HL)               ;34CF 7E                                                                           
                 INC   A                    ;34D0 3C                                                                           
                 LD    (HL),A               ;34D1 77                                                                           
                 CP    10                   ;34D2 FE0A                                                                         
                 JR    NZ,L34DB             ;34D4 2005                                                                         
                 LD    (HL),0               ;34D6 3600                                                                         
                 DEC   HL                   ;34D8 2B                                                                           
                 JR    L34CF                ;34D9 18F4                                                                         

L34DB:           EX    AF,AF'               ;34DB 08                                                                           
                 JP    L343D                ;34DC C33D34                                                                       

L34DF:           LD    DE,L1619             ;34DF 111916                                                                       
                 JR    L34E7                ;34E2 1803                                                                         

L34E4:           LD    DE,L161E             ;34E4 111E16                                                                       
L34E7:           LD    HL,(L3215)           ;34E7 2A1532                                                                       
                 EX    DE,HL                ;34EA EB                                                                           
L34EB:           LD    BC,L0005             ;34EB 010500                                                                       
                 LDIR                       ;34EE EDB0                                                                         
                 RET                        ;34F0 C9                                                                           

L34F1:           PUSH  DE                   ;34F1 D5                                                                           
                 CALL  L33EB                ;34F2 CDEB33                                                                       
                 JP    Z,L34FD              ;34F5 CAFD34                                                                       
L34F8:           LD    HL,L161E             ;34F8 211E16                                                                       
                 JR    L3500                ;34FB 1803                                                                         

L34FD:           LD    HL,L1619             ;34FD 211916                                                                       
L3500:           POP   DE                   ;3500 D1                                                                           
                 JP    L34EB                ;3501 C3EB34                                                                       

L3504:           PUSH  DE                   ;3504 D5                                                                           
                 EX    DE,HL                ;3505 EB                                                                           
                 JR    L3509                ;3506 1801                                                                         

L3508:           PUSH  DE                   ;3508 D5                                                                           
L3509:           CALL  L33EB                ;3509 CDEB33                                                                       
                 JP    C,L34F8              ;350C DAF834                                                                       
                 JP    L34FD                ;350F C3FD34                                                                       

L3512:           PUSH  DE                   ;3512 D5                                                                           
                 CALL  L33EB                ;3513 CDEB33                                                                       
                 JP    Z,L34F8              ;3516 CAF834                                                                       
                 JP    L34FD                ;3519 C3FD34                                                                       

L351C:           PUSH  DE                   ;351C D5                                                                           
                 EX    DE,HL                ;351D EB                                                                           
                 JR    L3521                ;351E 1801                                                                         

L3520:           PUSH  DE                   ;3520 D5                                                                           
L3521:           CALL  L33EB                ;3521 CDEB33                                                                       
                 JP    C,L34FD              ;3524 DAFD34                                                                       
                 JP    L34F8                ;3527 C3F834                                                                       

L352A:           DB    0BEH,35H,28H,0DCH    ;352A BE3528DC  Link 352A found at , $353B, $355D                                  
                 DB    0CFH                 ;352E CF                                                                           
L352F:           PUSH  DE                   ;352F D5                                                                           
                 EX    DE,HL                ;3530 EB                                                                           
                 LD    A,(HL)               ;3531 7E                                                                           
                 LD    BC,L0004             ;3532 010400                                                                       
                 ADD   HL,BC                ;3535 09                                                                           
                 XOR   (HL)                 ;3536 AE                                                                           
                 JP    M,L355C              ;3537 FA5C35                                                                       
                 LD    DE,L352A             ;353A 112A35                                                                       
                 PUSH  DE                   ;353D D5                                                                           
                 LD    HL,L3583             ;353E 218335                                                                       
                 CALL  L2E59                ;3541 CD592E                                                                       
                 POP   HL                   ;3544 E1                                                                           
                 PUSH  HL                   ;3545 E5                                                                           
                 LD    A,(HL)               ;3546 7E                                                                           
                 INC   HL                   ;3547 23                                                                           
                 LD    E,(HL)               ;3548 5E                                                                           
                 INC   HL                   ;3549 23                                                                           
                 LD    D,(HL)               ;354A 56                                                                           
                 INC   HL                   ;354B 23                                                                           
                 LD    C,(HL)               ;354C 4E                                                                           
                 INC   HL                   ;354D 23                                                                           
                 LD    B,(HL)               ;354E 46                                                                           
                 CP    193                  ;354F FEC1                                                                         
                 CALL  NC,L356B             ;3551 D46B35                                                                       
                 POP   HL                   ;3554 E1                                                                           
                 PUSH  HL                   ;3555 E5                                                                           
                 CALL  L2DE4                ;3556 CDE42D                                                                       
                 JP    L3566                ;3559 C36635                                                                       

L355C:           LD    DE,L352A             ;355C 112A35                                                                       
                 LD    HL,L357E             ;355F 217E35                                                                       
                 PUSH  DE                   ;3562 D5                                                                           
                 CALL  L34EB                ;3563 CDEB34                                                                       
L3566:           POP   HL                   ;3566 E1                                                                           
                 POP   DE                   ;3567 D1                                                                           
                 JP    L34EB                ;3568 C3EB34                                                                       

L356B:           SUB   192                  ;356B D6C0                                                                         
L356D:           SLA   E                    ;356D CB23                                                                         
                 RL    D                    ;356F CB12                                                                         
                 RL    C                    ;3571 CB11                                                                         
                 RL    B                    ;3573 CB10                                                                         
                 DEC   A                    ;3575 3D                                                                           
                 JP    NZ,L356D             ;3576 C26D35                                                                       
                 LD    A,192                ;3579 3EC0                                                                         
                 JP    L3661                ;357B C36136                                                                       

L357E:           DB    0BEH,35H,28H,0DCH    ;357E BE3528DC  Link 357E found at , $3560                                         
                 DB    0CFH                 ;3582 CF                                                                           
L3583:           DB    0C5H,00H,00H,00H     ;3583 C5000000                                                                     
                 DB    0B8H                 ;3587 B8                                                                           
L3588:           DB    0CDH,8EH,27H,0CDH    ;3588 CD8E27CD                                                                     
                 DB    0B5H                 ;358C B5                                                                           
L358D:           DB    28H,2AH,30H,62H      ;358D 282A3062                                                                     
                 DB    0EBH                 ;3591 EB                                                                           
L3592:           DB    73H,23H,72H,23H      ;3592 73237223                                                                     
                 DB    36H                  ;3596 36                                                                           
L3597:           DB    0DH,0CDH,03H,28H     ;3597 0DCD0328                                                                     
                 DB    0EBH                 ;359B EB                                                                           
L359C:           LD    DE,L3588             ;359C 118835                                                                       
                 JP    L2D4D                ;359F C34D2D                                                                       

L35A2:           CALL  L359C                ;35A2 CD9C35                                                                       
L35A5:           LD    HL,L358D             ;35A5 218D35                                                                       
L35A8:           LD    DE,L3588             ;35A8 118835                                                                       
                 JP    L2E59                ;35AB C3592E                                                                       

L35AE:           DW    0AFF1H               ;35AE F1AF                                                                         
L35B0:           PUSH  DE                   ;35B0 D5                                                                           
                 LD    HL,L3684             ;35B1 218436                                                                       
                 CALL  L2F30                ;35B4 CD302F                                                                       
                 POP   HL                   ;35B7 E1                                                                           
                 PUSH  HL                   ;35B8 E5                                                                           
                 LD    A,(HL)               ;35B9 7E                                                                           
                 LD    (L35AF),A            ;35BA 32AF35                                                                       
                 OR    128                  ;35BD F680                                                                         
                 INC   HL                   ;35BF 23                                                                           
                 LD    E,(HL)               ;35C0 5E                                                                           
                 INC   HL                   ;35C1 23                                                                           
                 LD    D,(HL)               ;35C2 56                                                                           
                 INC   HL                   ;35C3 23                                                                           
                 LD    C,(HL)               ;35C4 4E                                                                           
                 INC   HL                   ;35C5 23                                                                           
                 LD    B,(HL)               ;35C6 46                                                                           
                 CP    195                  ;35C7 FEC3                                                                         
                 JP    C,L35DF              ;35C9 DADF35                                                                       
                 SUB   194                  ;35CC D6C2                                                                         
L35CE:           SLA   E                    ;35CE CB23                                                                         
                 RL    D                    ;35D0 CB12                                                                         
                 RL    C                    ;35D2 CB11                                                                         
                 RL    B                    ;35D4 CB10                                                                         
                 DEC   A                    ;35D6 3D                                                                           
                 JP    NZ,L35CE             ;35D7 C2CE35                                                                       
                 LD    A,194                ;35DA 3EC2                                                                         
                 CALL  L3661                ;35DC CD6136                                                                       
L35DF:           LD    HL,L8000             ;35DF 210080                                                                       
                 CP    194                  ;35E2 FEC2                                                                         
                 JR    C,L35EC              ;35E4 3806                                                                         
                 LD    H,L                  ;35E6 65                                                                           
                 RES   7,B                  ;35E7 CBB8                                                                         
                 CALL  L3661                ;35E9 CD6136                                                                       
L35EC:           CP    193                  ;35EC FEC1                                                                         
                 JR    C,L35F6              ;35EE 3806                                                                         
                 INC   L                    ;35F0 2C                                                                           
                 RES   7,B                  ;35F1 CBB8                                                                         
                 CALL  L3661                ;35F3 CD6136                                                                       
L35F6:           EX    AF,AF'               ;35F6 08                                                                           
                 LD    A,(L35AF)            ;35F7 3AAF35                                                                       
                 XOR   H                    ;35FA AC                                                                           
                 CPL                        ;35FB 2F                                                                           
                 AND   128                  ;35FC E680                                                                         
                 LD    H,A                  ;35FE 67                                                                           
                 LD    (L35AE),HL           ;35FF 22AE35                                                                       
                 EX    AF,AF'               ;3602 08                                                                           
                 POP   HL                   ;3603 E1                                                                           
                 PUSH  HL                   ;3604 E5                                                                           
                 CALL  L2DE4                ;3605 CDE42D                                                                       
                 LD    A,(L35AE)            ;3608 3AAE35                                                                       
                 OR    A                    ;360B B7                                                                           
                 JR    Z,L3616              ;360C 2808                                                                         
                 POP   DE                   ;360E D1                                                                           
                 PUSH  DE                   ;360F D5                                                                           
                 LD    HL,L1614             ;3610 211416                                                                       
                 CALL  L2D4A                ;3613 CD4A2D                                                                       
L3616:           POP   HL                   ;3616 E1                                                                           
                 PUSH  HL                   ;3617 E5                                                                           
                 LD    A,(HL)               ;3618 7E                                                                           
                 AND   127                  ;3619 E67F                                                                         
                 LD    B,A                  ;361B 47                                                                           
                 LD    A,(L35AF)            ;361C 3AAF35                                                                       
                 OR    B                    ;361F B0                                                                           
                 LD    (HL),A               ;3620 77                                                                           
                 LD    DE,L3588             ;3621 118835                                                                       
                 CALL  L34EB                ;3624 CDEB34                                                                       
                 LD    DE,L358D             ;3627 118D35                                                                       
                 LD    HL,L3588             ;362A 218835                                                                       
                 CALL  L34EB                ;362D CDEB34                                                                       
                 CALL  L35A5                ;3630 CDA535                                                                       
                 LD    DE,L358D             ;3633 118D35                                                                       
                 LD    HL,L3588             ;3636 218835                                                                       
                 CALL  L34EB                ;3639 CDEB34                                                                       
                 LD    HL,L3689             ;363C 218936                                                                       
                 CALL  L35A8                ;363F CDA835                                                                       
                 LD    HL,L368E             ;3642 218E36                                                                       
                 CALL  L35A2                ;3645 CDA235                                                                       
                 LD    HL,L3693             ;3648 219336                                                                       
                 CALL  L35A2                ;364B CDA235                                                                       
                 LD    HL,L3698             ;364E 219836                                                                       
                 CALL  L35A2                ;3651 CDA235                                                                       
                 LD    HL,L369D             ;3654 219D36                                                                       
                 CALL  L359C                ;3657 CD9C35                                                                       
                 POP   DE                   ;365A D1                                                                           
                 LD    HL,L3588             ;365B 218835                                                                       
                 JP    L2E59                ;365E C3592E                                                                       

L3661:           BIT   7,B                  ;3661 CB78                                                                         
                 RET   NZ                   ;3663 C0                                                                           
                 EX    AF,AF'               ;3664 08                                                                           
                 LD    A,B                  ;3665 78                                                                           
                 OR    C                    ;3666 B1                                                                           
                 OR    E                    ;3667 B3                                                                           
                 OR    D                    ;3668 B2                                                                           
                 JP    Z,L367B              ;3669 CA7B36                                                                       
                 EX    AF,AF'               ;366C 08                                                                           
L366D:           BIT   7,B                  ;366D CB78                                                                         
                 RET   NZ                   ;366F C0                                                                           
                 SLA   E                    ;3670 CB23                                                                         
                 RL    D                    ;3672 CB12                                                                         
                 RL    C                    ;3674 CB11                                                                         
                 RL    B                    ;3676 CB10                                                                         
                 DEC   A                    ;3678 3D                                                                           
                 JR    NZ,L366D             ;3679 20F2                                                                         
L367B:           LD    BC,COLDSTART         ;367B 010000                                                                       
                 LD    DE,COLDSTART         ;367E 110000                                                                       
                 LD    A,128                ;3681 3E80                                                                         
                 RET                        ;3683 C9                                                                           

L3684:           DB    0C1H,0A1H,0DAH,0FH   ;3684 C1A1DA0F  Link 3684 found at , $35B2, $36A4, $3ABF                           
                 DB    0C9H                 ;3688 C9                                                                           
L3689:           DB    0B4H,0DCH,0FH,0AH    ;3689 B4DC0F0A                                                                     
                 DB    9FH                  ;368D 9F                                                                           
L368E:           DB    39H,61H,8FH,29H      ;368E 39618F29                                                                     
                 DB    99H                  ;3692 99                                                                           
L3693:           DB    0BDH,0C8H,77H,34H    ;3693 BDC87734                                                                     
                 DB    0A3H                 ;3697 A3                                                                           
L3698:           DB    40H,85H,0E1H,5DH     ;3698 4085E15D                                                                     
                 DB    0A5H                 ;369C A5                                                                           
L369D:           DB    0C1H,94H,0DAH,0FH    ;369D C194DA0F                                                                     
                 DB    0C9H                 ;36A1 C9                                                                           
L36A2:           PUSH  DE                   ;36A2 D5                                                                           
                 LD    HL,L3684             ;36A3 218436                                                                       
                 CALL  L2D4A                ;36A6 CD4A2D                                                                       
                 POP   HL                   ;36A9 E1                                                                           
                 CALL  L3B45                ;36AA CD453B                                                                       
                 EX    DE,HL                ;36AD EB                                                                           
                 JP    L35B0                ;36AE C3B035                                                                       

L36B1:           PUSH  DE                   ;36B1 D5                                                                           
                 EX    DE,HL                ;36B2 EB                                                                           
                 LD    DE,L3597             ;36B3 119735                                                                       
                 CALL  L34EB                ;36B6 CDEB34                                                                       
                 POP   DE                   ;36B9 D1                                                                           
                 PUSH  DE                   ;36BA D5                                                                           
                 CALL  L36A2                ;36BB CDA236                                                                       
                 POP   HL                   ;36BE E1                                                                           
                 PUSH  HL                   ;36BF E5                                                                           
                 LD    DE,L3592             ;36C0 119235                                                                       
                 CALL  L34EB                ;36C3 CDEB34                                                                       
                 POP   DE                   ;36C6 D1                                                                           
                 PUSH  DE                   ;36C7 D5                                                                           
                 LD    HL,L3597             ;36C8 219735                                                                       
                 CALL  L34EB                ;36CB CDEB34                                                                       
                 POP   DE                   ;36CE D1                                                                           
                 PUSH  DE                   ;36CF D5                                                                           
                 CALL  L35B0                ;36D0 CDB035                                                                       
                 POP   DE                   ;36D3 D1                                                                           
                 LD    HL,L3592             ;36D4 219235                                                                       
                 JP    L2F30                ;36D7 C3302F                                                                       

L36DA:           DB    0FEH                 ;36DA FE                                                                           
L36DB:           DB    0AH                  ;36DB 0A                                                                           
L36DC:           LD    A,3                  ;36DC 3E03                                                                         
                 LD    (L36DA),A            ;36DE 32DA36                                                                       
                 PUSH  DE                   ;36E1 D5                                                                           
                 EX    DE,HL                ;36E2 EB                                                                           
                 LD    A,(HL)               ;36E3 7E                                                                           
                 ADD   A,128                ;36E4 C680                                                                         
                 JP    NC,L1398             ;36E6 D29813                                                                       
                 JP    NZ,L36F9             ;36E9 C2F936                                                                       
                 EX    AF,AF'               ;36EC 08                                                                           
                 LD    BC,L0004             ;36ED 010400                                                                       
                 ADD   HL,BC                ;36F0 09                                                                           
                 LD    A,(HL)               ;36F1 7E                                                                           
                 SBC   HL,BC                ;36F2 ED42                                                                         
                 OR    A                    ;36F4 B7                                                                           
                 JP    P,L375C              ;36F5 F25C37                                                                       
                 EX    AF,AF'               ;36F8 08                                                                           
L36F9:           BIT   0,A                  ;36F9 CB47                                                                         
                 JP    NZ,L3778             ;36FB C27837                                                                       
                 LD    (L36DB),A            ;36FE 32DB36                                                                       
                 LD    (HL),192             ;3701 36C0                                                                         
                 LD    DE,L3588             ;3703 118835                                                                       
                 CALL  L34EB                ;3706 CDEB34                                                                       
                 LD    HL,L3790             ;3709 219037                                                                       
                 CALL  L35A8                ;370C CDA835                                                                       
                 LD    HL,L3795             ;370F 219537                                                                       
L3712:           CALL  L359C                ;3712 CD9C35                                                                       
L3715:           LD    DE,L358D             ;3715 118D35                                                                       
                 POP   HL                   ;3718 E1                                                                           
                 PUSH  HL                   ;3719 E5                                                                           
                 CALL  L34EB                ;371A CDEB34                                                                       
                 LD    DE,L358D             ;371D 118D35                                                                       
                 LD    HL,L3588             ;3720 218835                                                                       
                 CALL  L2F30                ;3723 CD302F                                                                       
                 LD    HL,L358D             ;3726 218D35                                                                       
                 CALL  L359C                ;3729 CD9C35                                                                       
                 LD    HL,L3588             ;372C 218835                                                                       
                 LD    A,(HL)               ;372F 7E                                                                           
                 AND   127                  ;3730 E67F                                                                         
                 DEC   A                    ;3732 3D                                                                           
                 JP    C,L375C              ;3733 DA5C37                                                                       
                 OR    128                  ;3736 F680                                                                         
                 LD    (HL),A               ;3738 77                                                                           
                 LD    A,(L36DA)            ;3739 3ADA36                                                                       
                 DEC   A                    ;373C 3D                                                                           
                 LD    (L36DA),A            ;373D 32DA36                                                                       
                 JP    NZ,L3715             ;3740 C21537                                                                       
                 LD    A,(L36DB)            ;3743 3ADB36                                                                       
                 CP    64                   ;3746 FE40                                                                         
                 CALL  NZ,L3763             ;3748 C46337                                                                       
                 LD    B,(HL)               ;374B 46                                                                           
                 RES   7,B                  ;374C CBB8                                                                         
                 ADD   A,B                  ;374E 80                                                                           
                 SUB   64                   ;374F D640                                                                         
                 JP    C,L375C              ;3751 DA5C37                                                                       
                 JP    M,L1398              ;3754 FA9813                                                                       
                 OR    128                  ;3757 F680                                                                         
                 LD    (HL),A               ;3759 77                                                                           
                 JR    L375F                ;375A 1803                                                                         

L375C:           LD    HL,L1619             ;375C 211916                                                                       
L375F:           POP   DE                   ;375F D1                                                                           
                 JP    L34EB                ;3760 C3EB34                                                                       

L3763:           JP    C,L376D              ;3763 DA6D37                                                                       
                 SUB   64                   ;3766 D640                                                                         
                 SRL   A                    ;3768 CB3F                                                                         
                 ADD   A,64                 ;376A C640                                                                         
                 RET                        ;376C C9                                                                           

L376D:           LD    B,A                  ;376D 47                                                                           
                 LD    A,64                 ;376E 3E40                                                                         
                 SUB   B                    ;3770 90                                                                           
                 SRL   A                    ;3771 CB3F                                                                         
                 LD    B,A                  ;3773 47                                                                           
                 LD    A,64                 ;3774 3E40                                                                         
                 SUB   B                    ;3776 90                                                                           
                 RET                        ;3777 C9                                                                           

L3778:           INC   A                    ;3778 3C                                                                           
                 LD    (L36DB),A            ;3779 32DB36                                                                       
                 LD    (HL),191             ;377C 36BF                                                                         
                 LD    DE,L3588             ;377E 118835                                                                       
                 CALL  L34EB                ;3781 CDEB34                                                                       
                 LD    HL,L379A             ;3784 219A37                                                                       
                 CALL  L35A8                ;3787 CDA835                                                                       
                 LD    HL,L379F             ;378A 219F37                                                                       
                 JP    L3712                ;378D C31237                                                                       

L3790:           DB    0C0H,00H,00H,00H     ;3790 C0000000  Link 3790 found at , $370A                                         
                 DB    90H                  ;3794 90                                                                           
L3795:           DB    0BFH,00H,00H,00H     ;3795 BF000000                                                                     
                 DB    0E0H                 ;3799 E0                                                                           
L379A:           DB    0C0H,00H,00H,00H     ;379A C0000000                                                                     
                 DB    0E0H                 ;379E E0                                                                           
L379F:           DB    0BFH,00H,00H,00H     ;379F BF000000                                                                     
                 DB    90H                  ;37A3 90                                                                           
L37A4:           DB    BRC                  ;37A4 CD                                                                           
L37A5:           DB    02H                  ;37A5 02                                                                           
L37A6:           PUSH  DE                   ;37A6 D5                                                                           
                 LD    A,(DE)               ;37A7 1A                                                                           
                 AND   128                  ;37A8 E680                                                                         
                 LD    (L37A4),A            ;37AA 32A437                                                                       
                 LD    A,(DE)               ;37AD 1A                                                                           
                 OR    128                  ;37AE F680                                                                         
                 LD    (DE),A               ;37B0 12                                                                           
                 LD    HL,L38D7             ;37B1 21D738                                                                       
                 CALL  L2F30                ;37B4 CD302F                                                                       
                 POP   HL                   ;37B7 E1                                                                           
                 PUSH  HL                   ;37B8 E5                                                                           
                 LD    A,64                 ;37B9 3E40                                                                         
                 LD    (L37A5),A            ;37BB 32A537                                                                       
                 LD    A,(HL)               ;37BE 7E                                                                           
                 SUB   193                  ;37BF D6C1                                                                         
                 CALL  NC,L3861             ;37C1 D46138                                                                       
                 POP   DE                   ;37C4 D1                                                                           
                 PUSH  DE                   ;37C5 D5                                                                           
                 LD    HL,L38D2             ;37C6 21D238                                                                       
                 CALL  L2D4A                ;37C9 CD4A2D                                                                       
                 POP   HL                   ;37CC E1                                                                           
                 PUSH  HL                   ;37CD E5                                                                           
                 LD    DE,L3588             ;37CE 118835                                                                       
                 CALL  L34EB                ;37D1 CDEB34                                                                       
                 LD    HL,L38AF             ;37D4 21AF38                                                                       
                 CALL  L35A8                ;37D7 CDA835                                                                       
                 LD    HL,L38B4             ;37DA 21B438                                                                       
                 CALL  L359C                ;37DD CD9C35                                                                       
                 POP   HL                   ;37E0 E1                                                                           
                 PUSH  HL                   ;37E1 E5                                                                           
                 CALL  L35A8                ;37E2 CDA835                                                                       
                 LD    HL,L38B9             ;37E5 21B938                                                                       
                 CALL  L359C                ;37E8 CD9C35                                                                       
                 POP   HL                   ;37EB E1                                                                           
                 PUSH  HL                   ;37EC E5                                                                           
                 CALL  L35A8                ;37ED CDA835                                                                       
                 LD    HL,L38BE             ;37F0 21BE38                                                                       
                 CALL  L359C                ;37F3 CD9C35                                                                       
                 POP   HL                   ;37F6 E1                                                                           
                 PUSH  HL                   ;37F7 E5                                                                           
                 CALL  L35A8                ;37F8 CDA835                                                                       
                 LD    HL,L38C3             ;37FB 21C338                                                                       
                 CALL  L359C                ;37FE CD9C35                                                                       
                 POP   HL                   ;3801 E1                                                                           
                 PUSH  HL                   ;3802 E5                                                                           
                 CALL  L35A8                ;3803 CDA835                                                                       
                 LD    HL,L38C8             ;3806 21C838                                                                       
                 CALL  L359C                ;3809 CD9C35                                                                       
                 POP   HL                   ;380C E1                                                                           
                 PUSH  HL                   ;380D E5                                                                           
                 CALL  L35A8                ;380E CDA835                                                                       
                 LD    HL,L38CD             ;3811 21CD38                                                                       
                 CALL  L359C                ;3814 CD9C35                                                                       
                 LD    HL,L3588             ;3817 218835                                                                       
                 LD    B,(HL)               ;381A 46                                                                           
                 RES   7,B                  ;381B CBB8                                                                         
                 LD    A,(L37A5)            ;381D 3AA537                                                                       
                 ADD   A,B                  ;3820 80                                                                           
                 JP    C,L38A5              ;3821 DAA538                                                                       
                 SUB   63                   ;3824 D63F                                                                         
                 JP    C,L3895              ;3826 DA9538                                                                       
                 JP    M,L38A5              ;3829 FAA538                                                                       
                 OR    128                  ;382C F680                                                                         
                 LD    (HL),A               ;382E 77                                                                           
                 LD    A,(L37A4)            ;382F 3AA437                                                                       
                 OR    A                    ;3832 B7                                                                           
                 JP    Z,L383D              ;3833 CA3D38                                                                       
                 LD    HL,L3588             ;3836 218835                                                                       
                 POP   DE                   ;3839 D1                                                                           
                 JP    L34EB                ;383A C3EB34                                                                       

L383D:           POP   DE                   ;383D D1                                                                           
                 PUSH  DE                   ;383E D5                                                                           
                 LD    HL,L1614             ;383F 211416                                                                       
                 CALL  L34EB                ;3842 CDEB34                                                                       
                 POP   DE                   ;3845 D1                                                                           
                 PUSH  DE                   ;3846 D5                                                                           
                 LD    A,(DE)               ;3847 1A                                                                           
                 CP    252                  ;3848 FEFC                                                                         
                 PUSH  AF                   ;384A F5                                                                           
                 JP    C,L3850              ;384B DA5038                                                                       
                 DEC   A                    ;384E 3D                                                                           
                 LD    (DE),A               ;384F 12                                                                           
L3850:           LD    HL,L3588             ;3850 218835                                                                       
                 CALL  L2F30                ;3853 CD302F                                                                       
                 POP   AF                   ;3856 F1                                                                           
                 POP   HL                   ;3857 E1                                                                           
                 RET   C                    ;3858 D8                                                                           
                 LD    A,(HL)               ;3859 7E                                                                           
                 DEC   A                    ;385A 3D                                                                           
                 LD    (HL),A               ;385B 77                                                                           
                 RET   M                    ;385C F8                                                                           
                 PUSH  HL                   ;385D E5                                                                           
                 JP    L2DE0                ;385E C3E02D                                                                       

L3861:           INC   HL                   ;3861 23                                                                           
                 LD    E,(HL)               ;3862 5E                                                                           
                 INC   HL                   ;3863 23                                                                           
                 LD    D,(HL)               ;3864 56                                                                           
                 INC   HL                   ;3865 23                                                                           
                 LD    C,(HL)               ;3866 4E                                                                           
                 INC   HL                   ;3867 23                                                                           
                 LD    B,(HL)               ;3868 46                                                                           
                 PUSH  HL                   ;3869 E5                                                                           
                 INC   A                    ;386A 3C                                                                           
                 LD    H,A                  ;386B 67                                                                           
                 XOR   A                    ;386C AF                                                                           
L386D:           SLA   E                    ;386D CB23                                                                         
                 RL    D                    ;386F CB12                                                                         
                 RL    C                    ;3871 CB11                                                                         
                 RL    B                    ;3873 CB10                                                                         
                 RLA                        ;3875 17                                                                           
                 JP    C,L38A3              ;3876 DAA338                                                                       
                 DEC   H                    ;3879 25                                                                           
                 JP    NZ,L386D             ;387A C26D38                                                                       
                 ADD   A,64                 ;387D C640                                                                         
                 JP    C,L38A3              ;387F DAA338                                                                       
                 LD    (L37A5),A            ;3882 32A537                                                                       
                 LD    A,192                ;3885 3EC0                                                                         
                 CALL  L3661                ;3887 CD6136                                                                       
                 POP   HL                   ;388A E1                                                                           
                 LD    (HL),B               ;388B 70                                                                           
                 DEC   HL                   ;388C 2B                                                                           
                 LD    (HL),C               ;388D 71                                                                           
                 DEC   HL                   ;388E 2B                                                                           
                 LD    (HL),D               ;388F 72                                                                           
                 DEC   HL                   ;3890 2B                                                                           
                 LD    (HL),E               ;3891 73                                                                           
                 DEC   HL                   ;3892 2B                                                                           
                 LD    (HL),A               ;3893 77                                                                           
                 RET                        ;3894 C9                                                                           

L3895:           LD    A,(L37A4)            ;3895 3AA437                                                                       
                 OR    A                    ;3898 B7                                                                           
                 JP    Z,L1398              ;3899 CA9813                                                                       
L389C:           LD    HL,L1619             ;389C 211916                                                                       
                 POP   DE                   ;389F D1                                                                           
                 JP    L34EB                ;38A0 C3EB34                                                                       

L38A3:           POP   AF                   ;38A3 F1                                                                           
                 POP   AF                   ;38A4 F1                                                                           
L38A5:           LD    A,(L37A4)            ;38A5 3AA437                                                                       
                 OR    A                    ;38A8 B7                                                                           
                 JP    NZ,L1398             ;38A9 C29813                                                                       
                 JP    L389C                ;38AC C39C38                                                                       

L38AF:           DB    0B3H,7CH,8CH,90H     ;38AF B37C8C90  Link 38AF found at , $37D5                                         
                 DB    0E3H                 ;38B3 E3                                                                           
L38B4:           DB    0B6H,1FH,0DFH,62H    ;38B4 B61FDF62                                                                     
                 DB    0F8H                 ;38B8 F8                                                                           
L38B9:           DB    0B9H,0E2H,6DH,0DDH   ;38B9 B9E26DDD                                                                     
                 DB    0DEH                 ;38BD DE                                                                           
L38BE:           DB    0BCH,8BH,33H,0C1H    ;38BE BC8B33C1                                                                     
                 DB    0A0H                 ;38C2 A0                                                                           
L38C3:           DB    0BEH,89H,4AH,0F1H    ;38C3 BE894AF1                                                                     
                 DB    0ADH                 ;38C7 AD                                                                           
L38C8:           DB    0BFH,34H,33H,0F2H    ;38C8 BF3433F2                                                                     
                 DB    0FAH                 ;38CC FA                                                                           
L38CD:           DB    0C0H,36H,0F3H,04H    ;38CD C036F304                                                                     
                 DB    0B5H                 ;38D1 B5                                                                           
L38D2:           DB    0C0H,00H,00H,00H     ;38D2 C0000000                                                                     
                 DB    80H                  ;38D6 80                                                                           
L38D7:           DB    0C0H,0F8H,17H,72H    ;38D7 C0F81772                                                                     
                 DB    0B1H                 ;38DB B1                                                                           
L38DC:           DB    0DAH                 ;38DC DA                                                                           
L38DD:           DB    98H                  ;38DD 98                                                                           
L38DE:           DB    23H                  ;38DE 23                                                                           
L38DF:           PUSH  DE                   ;38DF D5                                                                           
                 LD    A,128                ;38E0 3E80                                                                         
                 LD    (L38DD),A            ;38E2 32DD38                                                                       
                 LD    (L38DC),A            ;38E5 32DC38                                                                       
                 EX    DE,HL                ;38E8 EB                                                                           
                 LD    A,(HL)               ;38E9 7E                                                                           
                 OR    A                    ;38EA B7                                                                           
                 JP    P,L1398              ;38EB F29813                                                                       
                 CP    138                  ;38EE FE8A                                                                         
                 JP    NC,L38FE             ;38F0 D2FE38                                                                       
                 XOR   A                    ;38F3 AF                                                                           
                 LD    (L38DC),A            ;38F4 32DC38                                                                       
                 EX    DE,HL                ;38F7 EB                                                                           
                 CALL  L36DC                ;38F8 CDDC36                                                                       
                 POP   HL                   ;38FB E1                                                                           
                 PUSH  HL                   ;38FC E5                                                                           
                 LD    A,(HL)               ;38FD 7E                                                                           
L38FE:           CP    193                  ;38FE FEC1                                                                         
                 CALL  C,L39BF              ;3900 DCBF39                                                                       
                 LD    B,0                  ;3903 0600                                                                         
                 CP    193                  ;3905 FEC1                                                                         
                 JP    Z,L3910              ;3907 CA1039                                                                       
                 SUB   193                  ;390A D6C1                                                                         
                 LD    B,A                  ;390C 47                                                                           
                 LD    A,193                ;390D 3EC1                                                                         
                 LD    (HL),A               ;390F 77                                                                           
L3910:           LD    A,B                  ;3910 78                                                                           
                 LD    (L38DE),A            ;3911 32DE38                                                                       
                 LD    DE,L3588             ;3914 118835                                                                       
                 CALL  L34EB                ;3917 CDEB34                                                                       
                 POP   DE                   ;391A D1                                                                           
                 PUSH  DE                   ;391B D5                                                                           
                 LD    HL,L3A04             ;391C 21043A                                                                       
                 CALL  L2D4A                ;391F CD4A2D                                                                       
                 LD    HL,L3A04             ;3922 21043A                                                                       
                 CALL  L359C                ;3925 CD9C35                                                                       
                 POP   DE                   ;3928 D1                                                                           
                 PUSH  DE                   ;3929 D5                                                                           
                 LD    HL,L3588             ;392A 218835                                                                       
                 CALL  L2F30                ;392D CD302F                                                                       
                 POP   DE                   ;3930 D1                                                                           
                 PUSH  DE                   ;3931 D5                                                                           
                 LD    HL,L3A09             ;3932 21093A                                                                       
                 CALL  L2E59                ;3935 CD592E                                                                       
                 POP   HL                   ;3938 E1                                                                           
                 PUSH  HL                   ;3939 E5                                                                           
                 LD    DE,L358D             ;393A 118D35                                                                       
                 CALL  L34EB                ;393D CDEB34                                                                       
                 POP   HL                   ;3940 E1                                                                           
                 PUSH  HL                   ;3941 E5                                                                           
                 LD    DE,L358D             ;3942 118D35                                                                       
                 CALL  L2E59                ;3945 CD592E                                                                       
                 LD    DE,L3588             ;3948 118835                                                                       
                 LD    HL,L358D             ;394B 218D35                                                                       
                 CALL  L34EB                ;394E CDEB34                                                                       
                 LD    HL,L39F0             ;3951 21F039                                                                       
                 CALL  L35A8                ;3954 CDA835                                                                       
                 LD    HL,L39F5             ;3957 21F539                                                                       
                 CALL  L35A2                ;395A CDA235                                                                       
                 LD    HL,L39FA             ;395D 21FA39                                                                       
                 CALL  L35A2                ;3960 CDA235                                                                       
                 LD    HL,L39FF             ;3963 21FF39                                                                       
                 CALL  L359C                ;3966 CD9C35                                                                       
                 POP   HL                   ;3969 E1                                                                           
                 PUSH  HL                   ;396A E5                                                                           
                 CALL  L35A8                ;396B CDA835                                                                       
                 LD    DE,L358D             ;396E 118D35                                                                       
                 LD    HL,L3588             ;3971 218835                                                                       
                 CALL  L34EB                ;3974 CDEB34                                                                       
                 LD    A,(L38DE)            ;3977 3ADE38                                                                       
                 ADD   A,A                  ;397A 87                                                                           
                 INC   A                    ;397B 3C                                                                           
                 LD    B,A                  ;397C 47                                                                           
                 LD    A,8                  ;397D 3E08                                                                         
L397F:           BIT   7,B                  ;397F CB78                                                                         
                 JP    NZ,L398A             ;3981 C28A39                                                                       
                 SLA   B                    ;3984 CB20                                                                         
                 DEC   A                    ;3986 3D                                                                           
                 JP    NZ,L397F             ;3987 C27F39                                                                       
L398A:           ADD   A,192                ;398A C6C0                                                                         
                 LD    HL,L3588             ;398C 218835                                                                       
                 LD    (HL),A               ;398F 77                                                                           
                 INC   HL                   ;3990 23                                                                           
                 XOR   A                    ;3991 AF                                                                           
                 LD    (HL),A               ;3992 77                                                                           
                 INC   HL                   ;3993 23                                                                           
                 LD    (HL),A               ;3994 77                                                                           
                 INC   HL                   ;3995 23                                                                           
                 LD    (HL),A               ;3996 77                                                                           
                 INC   HL                   ;3997 23                                                                           
                 LD    (HL),B               ;3998 70                                                                           
                 LD    HL,L3A0E             ;3999 210E3A                                                                       
                 CALL  L35A8                ;399C CDA835                                                                       
                 LD    HL,L358D             ;399F 218D35                                                                       
                 CALL  L359C                ;39A2 CD9C35                                                                       
                 LD    HL,L3588             ;39A5 218835                                                                       
                 LD    A,(L38DD)            ;39A8 3ADD38                                                                       
                 CALL  L3B43                ;39AB CD433B                                                                       
                 POP   DE                   ;39AE D1                                                                           
                 PUSH  DE                   ;39AF D5                                                                           
                 CALL  L34EB                ;39B0 CDEB34                                                                       
                 POP   DE                   ;39B3 D1                                                                           
                 LD    A,(L38DC)            ;39B4 3ADC38                                                                       
                 OR    A                    ;39B7 B7                                                                           
                 RET   NZ                   ;39B8 C0                                                                           
                 LD    HL,L3588             ;39B9 218835                                                                       
                 JP    L2D4D                ;39BC C34D2D                                                                       

L39BF:           PUSH  HL                   ;39BF E5                                                                           
                 LD    DE,L3588             ;39C0 118835                                                                       
                 CALL  L34EB                ;39C3 CDEB34                                                                       
                 POP   DE                   ;39C6 D1                                                                           
                 PUSH  DE                   ;39C7 D5                                                                           
                 LD    HL,L1614             ;39C8 211416                                                                       
                 CALL  L34EB                ;39CB CDEB34                                                                       
                 POP   DE                   ;39CE D1                                                                           
                 PUSH  DE                   ;39CF D5                                                                           
                 LD    HL,L3588             ;39D0 218835                                                                       
                 CALL  L2F30                ;39D3 CD302F                                                                       
                 POP   HL                   ;39D6 E1                                                                           
                 LD    A,(HL)               ;39D7 7E                                                                           
                 CP    193                  ;39D8 FEC1                                                                         
                 JP    NC,L39E8             ;39DA D2E839                                                                       
                 PUSH  HL                   ;39DD E5                                                                           
                 EX    DE,HL                ;39DE EB                                                                           
                 LD    HL,L1614             ;39DF 211416                                                                       
                 CALL  L34EB                ;39E2 CDEB34                                                                       
                 POP   HL                   ;39E5 E1                                                                           
                 LD    A,193                ;39E6 3EC1                                                                         
L39E8:           EX    AF,AF'               ;39E8 08                                                                           
                 LD    A,0                  ;39E9 3E00                                                                         
                 LD    (L38DD),A            ;39EB 32DD38                                                                       
                 EX    AF,AF'               ;39EE 08                                                                           
                 RET                        ;39EF C9                                                                           

L39F0:           DB    0ADH,0A4H,62H,0CCH   ;39F0 ADA462CC  Link 39F0 found at , $3952                                         
                 DB    0AFH                 ;39F4 AF                                                                           
L39F5:           DB    0B2H,9FH,0E9H,47H    ;39F5 B29FE947                                                                     
                 DB    0F9H                 ;39F9 F9                                                                           
L39FA:           DB    0B8H,0A4H,82H,0AAH   ;39FA B8A482AA                                                                     
                 DB    0DCH                 ;39FE DC                                                                           
L39FF:           DB    0BFH,0BFH,0CCH,0B0H  ;39FF BFBFCCB0                                                                     
                 DB    0AFH                 ;3A03 AF                                                                           
L3A04:           DB    0C1H,33H,0F3H,04H    ;3A04 C133F304                                                                     
                 DB    0B5H                 ;3A08 B5                                                                           
L3A09:           DB    0C3H,99H,79H,82H     ;3A09 C3997982                                                                     
                 DB    0BAH                 ;3A0D BA                                                                           
L3A0E:           DB    0BFH,0F8H,17H,72H    ;3A0E BFF81772                                                                     
                 DB    0B1H                 ;3A12 B1                                                                           
L3A13:           PUSH  DE                   ;3A13 D5                                                                           
                 CALL  L38DF                ;3A14 CDDF38                                                                       
                 POP   DE                   ;3A17 D1                                                                           
                 LD    HL,L3A1E             ;3A18 211E3A                                                                       
                 JP    L2E59                ;3A1B C3592E                                                                       

L3A1E:           DB    0BFH,0A9H,0D8H,5BH   ;3A1E BFA9D85B  Link 3A1E found at , $1EC0, $1F99, $3A19                           
                 DB    0DEH                 ;3A22 DE                                                                           
L3A23:           DB    03H                  ;3A23 03                                                                           
L3A24:           DB    64H                  ;3A24 64                                                                           
L3A25:           PUSH  DE                   ;3A25 D5                                                                           
                 EX    DE,HL                ;3A26 EB                                                                           
                 LD    A,(HL)               ;3A27 7E                                                                           
                 AND   128                  ;3A28 E680                                                                         
                 LD    (L3A23),A            ;3A2A 32233A                                                                       
                 SET   7,(HL)               ;3A2D CBFE                                                                         
                 LD    DE,L1614             ;3A2F 111416                                                                       
                 CALL  L33EB                ;3A32 CDEB33                                                                       
                 LD    A,128                ;3A35 3E80                                                                         
                 JP    NC,L3A53             ;3A37 D2533A                                                                       
                 LD    DE,L3588             ;3A3A 118835                                                                       
                 POP   HL                   ;3A3D E1                                                                           
                 PUSH  HL                   ;3A3E E5                                                                           
                 CALL  L34EB                ;3A3F CDEB34                                                                       
                 POP   DE                   ;3A42 D1                                                                           
                 PUSH  DE                   ;3A43 D5                                                                           
                 LD    HL,L1614             ;3A44 211416                                                                       
                 CALL  L34EB                ;3A47 CDEB34                                                                       
                 POP   DE                   ;3A4A D1                                                                           
                 PUSH  DE                   ;3A4B D5                                                                           
                 LD    HL,L3588             ;3A4C 218835                                                                       
                 CALL  L2F30                ;3A4F CD302F                                                                       
                 XOR   A                    ;3A52 AF                                                                           
L3A53:           LD    (L3A24),A            ;3A53 32243A                                                                       
                 POP   HL                   ;3A56 E1                                                                           
                 PUSH  HL                   ;3A57 E5                                                                           
                 LD    DE,L3588             ;3A58 118835                                                                       
                 CALL  L34EB                ;3A5B CDEB34                                                                       
                 POP   HL                   ;3A5E E1                                                                           
                 PUSH  HL                   ;3A5F E5                                                                           
                 CALL  L35A8                ;3A60 CDA835                                                                       
                 LD    HL,L3588             ;3A63 218835                                                                       
                 LD    DE,L358D             ;3A66 118D35                                                                       
                 CALL  L34EB                ;3A69 CDEB34                                                                       
                 LD    HL,L3AD3             ;3A6C 21D33A                                                                       
                 CALL  L35A8                ;3A6F CDA835                                                                       
                 LD    HL,L3AD8             ;3A72 21D83A                                                                       
                 CALL  L35A2                ;3A75 CDA235                                                                       
                 LD    HL,L3ADD             ;3A78 21DD3A                                                                       
                 CALL  L35A2                ;3A7B CDA235                                                                       
                 LD    HL,L3AE2             ;3A7E 21E23A                                                                       
                 CALL  L35A2                ;3A81 CDA235                                                                       
                 LD    HL,L3AE7             ;3A84 21E73A                                                                       
                 CALL  L35A2                ;3A87 CDA235                                                                       
                 LD    HL,L3AEC             ;3A8A 21EC3A                                                                       
                 CALL  L35A2                ;3A8D CDA235                                                                       
                 LD    HL,L3AF1             ;3A90 21F13A                                                                       
                 CALL  L35A2                ;3A93 CDA235                                                                       
                 LD    HL,L3AF6             ;3A96 21F63A                                                                       
                 CALL  L35A2                ;3A99 CDA235                                                                       
                 LD    HL,L3AFB             ;3A9C 21FB3A                                                                       
                 CALL  L35A2                ;3A9F CDA235                                                                       
                 LD    HL,L1614             ;3AA2 211416                                                                       
                 CALL  L359C                ;3AA5 CD9C35                                                                       
                 POP   HL                   ;3AA8 E1                                                                           
                 PUSH  HL                   ;3AA9 E5                                                                           
                 CALL  L35A8                ;3AAA CDA835                                                                       
                 POP   DE                   ;3AAD D1                                                                           
                 PUSH  DE                   ;3AAE D5                                                                           
                 LD    HL,L3588             ;3AAF 218835                                                                       
                 CALL  L34EB                ;3AB2 CDEB34                                                                       
                 LD    A,(L3A24)            ;3AB5 3A243A                                                                       
                 OR    A                    ;3AB8 B7                                                                           
                 JP    NZ,L3ACC             ;3AB9 C2CC3A                                                                       
                 POP   DE                   ;3ABC D1                                                                           
                 PUSH  DE                   ;3ABD D5                                                                           
                 LD    HL,L3684             ;3ABE 218436                                                                       
                 CALL  L34EB                ;3AC1 CDEB34                                                                       
                 POP   DE                   ;3AC4 D1                                                                           
                 PUSH  DE                   ;3AC5 D5                                                                           
                 LD    HL,L3588             ;3AC6 218835                                                                       
                 CALL  L2D4A                ;3AC9 CD4A2D                                                                       
L3ACC:           POP   HL                   ;3ACC E1                                                                           
                 LD    A,(L3A23)            ;3ACD 3A233A                                                                       
                 JP    L3B43                ;3AD0 C3433B                                                                       

L3AD3:           DB    37H,0CAH,9AH,56H     ;3AD3 37CA9A56  Link 3AD3 found at , $3A6D                                         
                 DB    0DFH                 ;3AD7 DF                                                                           
L3AD8:           DB    0BAH,12H,77H,0CCH    ;3AD8 BA1277CC                                                                     
                 DB    0ABH                 ;3ADC AB                                                                           
L3ADD:           DB    3BH,23H,0B2H,5EH     ;3ADD 3B23B25E                                                                     
                 DB    0F8H                 ;3AE1 F8                                                                           
L3AE2:           DB    0BCH,20H,63H,90H     ;3AE2 BC206390                                                                     
                 DB    0E9H                 ;3AE6 E9                                                                           
L3AE7:           DB    3DH,0EEH,3DH,0E0H    ;3AE7 3DEE3DE0  Link 3AE7 found at , $3A85                                         
                 DB    0AAH                 ;3AEB AA                                                                           
L3AEC:           DB    0BDH,4FH,1AH,0D5H    ;3AEC BD4F1AD5                                                                     
                 DB    0DFH                 ;3AF0 DF                                                                           
L3AF1:           DB    3EH,0E3H,0AFH,03H    ;3AF1 3EE3AF03                                                                     
                 DB    92H                  ;3AF5 92                                                                           
L3AF6:           DB    0BEH,2AH,7BH,0C7H    ;3AF6 BE2A7BC7                                                                     
                 DB    0CCH                 ;3AFA CC                                                                           
L3AFB:           DB    3FH,17H,96H,0AAH     ;3AFB 3F1796AA                                                                     
                 DB    0AAH                 ;3AFF AA                                                                           
L3B00:           DB    0E1H,22H,03H,64H     ;3B00 E1220364                                                                     
L3B04:           DB    0F1H                 ;3B04 F1                                                                           
L3B05:           DB    0C2H                 ;3B05 C2                                                                           
L3B06:           DB    0CCH                 ;3B06 CC                                                                           
                 DB    3CH,2AH,0BFH,3AH     ;3B07 3C2ABF3A                                                                     
L3B0B:           PUSH  DE                   ;3B0B D5                                                                           
                 LD    DE,L3B06             ;3B0C 11063B                                                                       
                 CALL  L34EB                ;3B0F CDEB34                                                                       
                 POP   HL                   ;3B12 E1                                                                           
                 PUSH  HL                   ;3B13 E5                                                                           
                 LD    BC,L0004             ;3B14 010400                                                                       
                 ADD   HL,BC                ;3B17 09                                                                           
                 LD    A,(HL)               ;3B18 7E                                                                           
                 OR    A                    ;3B19 B7                                                                           
                 POP   HL                   ;3B1A E1                                                                           
                 PUSH  HL                   ;3B1B E5                                                                           
                 JP    P,L2DE0              ;3B1C F2E02D                                                                       
                 LD    A,(HL)               ;3B1F 7E                                                                           
                 AND   128                  ;3B20 E680                                                                         
                 LD    (L3B05),A            ;3B22 32053B                                                                       
                 SET   7,(HL)               ;3B25 CBFE                                                                         
                 EX    DE,HL                ;3B27 EB                                                                           
                 CALL  L38DF                ;3B28 CDDF38                                                                       
                 LD    A,(L3B05)            ;3B2B 3A053B                                                                       
                 OR    A                    ;3B2E B7                                                                           
                 CALL  Z,L3B56              ;3B2F CC563B                                                                       
                 POP   DE                   ;3B32 D1                                                                           
                 PUSH  DE                   ;3B33 D5                                                                           
                 LD    HL,L3B06             ;3B34 21063B                                                                       
                 CALL  L2E59                ;3B37 CD592E                                                                       
                 POP   DE                   ;3B3A D1                                                                           
                 PUSH  DE                   ;3B3B D5                                                                           
                 CALL  L37A6                ;3B3C CDA637                                                                       
                 POP   HL                   ;3B3F E1                                                                           
                 LD    A,(L3B05)            ;3B40 3A053B                                                                       
L3B43:           OR    A                    ;3B43 B7                                                                           
                 RET   NZ                   ;3B44 C0                                                                           
L3B45:           LD    BC,L0004             ;3B45 010400                                                                       
                 ADD   HL,BC                ;3B48 09                                                                           
                 BIT   7,(HL)               ;3B49 CB7E                                                                         
                 PUSH  AF                   ;3B4B F5                                                                           
                 XOR   A                    ;3B4C AF                                                                           
                 SBC   HL,BC                ;3B4D ED42                                                                         
                 POP   AF                   ;3B4F F1                                                                           
                 RET   Z                    ;3B50 C8                                                                           
                 LD    A,(HL)               ;3B51 7E                                                                           
                 ADD   A,128                ;3B52 C680                                                                         
                 LD    (HL),A               ;3B54 77                                                                           
                 RET                        ;3B55 C9                                                                           

L3B56:           LD    HL,L3B06             ;3B56 21063B                                                                       
                 LD    DE,L3B00             ;3B59 11003B                                                                       
                 CALL  L34EB                ;3B5C CDEB34                                                                       
                 LD    DE,L3B06             ;3B5F 11063B                                                                       
                 CALL  L340E                ;3B62 CD0E34                                                                       
                 LD    DE,L3B00             ;3B65 11003B                                                                       
                 LD    HL,L3B06             ;3B68 21063B                                                                       
                 CALL  L2D4A                ;3B6B CD4A2D                                                                       
                 LD    HL,L3B04             ;3B6E 21043B                                                                       
                 LD    A,(HL)               ;3B71 7E                                                                           
                 OR    A                    ;3B72 B7                                                                           
                 JP    M,L1398              ;3B73 FA9813                                                                       
                 LD    HL,L3B06             ;3B76 21063B                                                                       
                 LD    A,(HL)               ;3B79 7E                                                                           
                 INC   HL                   ;3B7A 23                                                                           
                 LD    E,(HL)               ;3B7B 5E                                                                           
                 INC   HL                   ;3B7C 23                                                                           
                 LD    D,(HL)               ;3B7D 56                                                                           
                 INC   HL                   ;3B7E 23                                                                           
                 LD    C,(HL)               ;3B7F 4E                                                                           
                 INC   HL                   ;3B80 23                                                                           
                 LD    B,(HL)               ;3B81 46                                                                           
                 AND   127                  ;3B82 E67F                                                                         
                 SUB   65                   ;3B84 D641                                                                         
                 JP    C,L3B9B              ;3B86 DA9B3B                                                                       
                 JP    Z,L3B98              ;3B89 CA983B                                                                       
L3B8C:           SLA   E                    ;3B8C CB23                                                                         
                 RL    D                    ;3B8E CB12                                                                         
                 RL    C                    ;3B90 CB11                                                                         
                 RL    B                    ;3B92 CB10                                                                         
                 DEC   A                    ;3B94 3D                                                                           
                 JP    NZ,L3B8C             ;3B95 C28C3B                                                                       
L3B98:           RL    B                    ;3B98 CB10                                                                         
                 RET   C                    ;3B9A D8                                                                           
L3B9B:           LD    A,128                ;3B9B 3E80                                                                         
                 LD    (L3B05),A            ;3B9D 32053B                                                                       
                 RET                        ;3BA0 C9                                                                           

L3BA1:           LD    A,(L3D26)            ;3BA1 3A263D                                                                       
                 OR    A                    ;3BA4 B7                                                                           
                 RET   Z                    ;3BA5 C8                                                                           
L3BA6:           CALL  L3C66                ;3BA6 CD663C                                                                       
                 RET   C                    ;3BA9 D8                                                                           
                 LD    A,13                 ;3BAA 3E0D                                                                         
                 CALL  L3C87                ;3BAC CD873C                                                                       
                 XOR   A                    ;3BAF AF                                                                           
                 LD    (L3D26),A            ;3BB0 32263D                                                                       
                 JP    L3CC6                ;3BB3 C3C63C                                                                       

                 DB    0CDH,66H,3CH,0D8H    ;3BB6 CD663CD8  Link 3BB6 found at , $1CB1                                         
                 DB    0C5H,0D5H,3AH,26H    ;3BBA C5D53A26                                                                     
                 DB    3DH,47H,1AH,0FEH     ;3BBE 3D471AFE                                                                     
                 DB    0DH,0CAH,1DH,3CH     ;3BC2 0DCA1D3C                                                                     
                 DB    0FEH,20H,0DCH,0D3H   ;3BC6 FE20DCD3                                                                     
                 DB    3BH,0CDH,87H,3CH     ;3BCA 3BCD873C                                                                     
                 DB    04H,13H,0C3H,0C0H    ;3BCE 0413C3C0                                                                     
                 DB    3BH,0FEH,15H,0CAH    ;3BD2 3BFE15CA                                                                     
                 DB    0ECH,3BH,0FEH,12H    ;3BD6 EC3BFE12                                                                     
                 DB    0CAH,0F1H,3BH,0FEH   ;3BDA CAF13BFE                                                                     
                 DB    11H,0CAH,0F6H,3BH    ;3BDE 11CAF63B                                                                     
                 DB    0FEH,16H,0CAH,0FBH   ;3BE2 FE16CAFB                                                                     
                 DB    3BH,0F1H,13H,0C3H    ;3BE6 3BF113C3                                                                     
                 DB    0C0H,3BH,3EH,0FH     ;3BEA C03B3E0F                                                                     
                 DB    06H,0FFH,0C9H,3EH    ;3BEE 06FFC93E                                                                     
                 DB    0BH,06H,0FFH,0C9H    ;3BF2 0B06FFC9                                                                     
                 DB    3EH,09H,06H,0FFH     ;3BF6 3E0906FF                                                                     
                 DB    0C9H,3EH,0CH,0CDH    ;3BFA C93E0CCD                                                                     
                 DB    87H,3CH,3EH,0AH      ;3BFE 873C3E0A                                                                     
                 DB    06H,0FFH,0C9H        ;3C02 06FFC9                                                                       
L3C05:           CALL  L3C66                ;3C05 CD663C                                                                       
                 RET   C                    ;3C08 D8                                                                           
                 PUSH  BC                   ;3C09 C5                                                                           
                 PUSH  DE                   ;3C0A D5                                                                           
                 LD    A,(L3D26)            ;3C0B 3A263D                                                                       
                 LD    B,A                  ;3C0E 47                                                                           
L3C0F:           LD    A,(DE)               ;3C0F 1A                                                                           
                 CP    13                   ;3C10 FE0D                                                                         
                 JP    Z,L3C1D              ;3C12 CA1D3C                                                                       
                 CALL  L3C87                ;3C15 CD873C                                                                       
                 INC   B                    ;3C18 04                                                                           
                 INC   DE                   ;3C19 13                                                                           
                 JP    L3C0F                ;3C1A C30F3C                                                                       

L3C1D:           LD    A,B                  ;3C1D 78                                                                           
                 CP    80                   ;3C1E FE50                                                                         
                 JP    C,L3C25              ;3C20 DA253C                                                                       
                 SUB   80                   ;3C23 D650                                                                         
L3C25:           LD    (L3D26),A            ;3C25 32263D                                                                       
                 POP   DE                   ;3C28 D1                                                                           
                 POP   BC                   ;3C29 C1                                                                           
                 JP    L3CC6                ;3C2A C3C63C                                                                       

                 DB    0FEH,0DH,0CAH,0A6H   ;3C2D FE0DCAA6  Link 3C2D found at , $2EBF, $2F16                                  
                 DB    3BH,0C5H,0D5H,4FH    ;3C31 3BC5D54F                                                                     
                 DB    3AH,26H,3DH,47H      ;3C35 3A263D47                                                                     
                 DB    0CDH,66H,3CH,0D2H    ;3C39 CD663CD2                                                                     
                 DB    42H,3CH,0D1H,0C1H    ;3C3D 423CD1C1                                                                     
                 DB    0C9H,79H,0CDH,87H    ;3C41 C979CD87                                                                     
                 DB    3CH,04H,0C3H,1DH     ;3C45 3C04C31D                                                                     
                 DB    3CH                  ;3C49 3C                                                                           
L3C4A:           CALL  L3C66                ;3C4A CD663C                                                                       
                 RET   C                    ;3C4D D8                                                                           
                 PUSH  BC                   ;3C4E C5                                                                           
                 PUSH  DE                   ;3C4F D5                                                                           
                 LD    A,(L3D26)            ;3C50 3A263D                                                                       
                 LD    B,A                  ;3C53 47                                                                           
L3C54:           LD    A,32                 ;3C54 3E20                                                                         
                 CALL  L3C87                ;3C56 CD873C                                                                       
                 INC   B                    ;3C59 04                                                                           
                 LD    A,B                  ;3C5A 78                                                                           
L3C5B:           SUB   10                   ;3C5B D60A                                                                         
                 JP    C,L3C54              ;3C5D DA543C                                                                       
                 JP    NZ,L3C5B             ;3C60 C25B3C                                                                       
                 JP    L3C1D                ;3C63 C31D3C                                                                       

L3C66:           LD    A,5                  ;3C66 3E05                                                                         
                 CALL  L3C78                ;3C68 CD783C                                                                       
                 RET   C                    ;3C6B D8                                                                           
                 LD    A,6                  ;3C6C 3E06                                                                         
                 CALL  L3C78                ;3C6E CD783C                                                                       
                 JP    NC,L3C76             ;3C71 D2763C                                                                       
                 XOR   A                    ;3C74 AF                                                                           
                 RET                        ;3C75 C9                                                                           

L3C76:           SCF                        ;3C76 37                                                                           
                 RET                        ;3C77 C9                                                                           

L3C78:           CALL  L3C87                ;3C78 CD873C                                                                       
                 LD    A,0                  ;3C7B 3E00                                                                         
                 CALL  L3C9D                ;3C7D CD9D3C                                                                       
                 IN    A,(PTRSTATUS)        ;3C80 DBFE                                                                         
                 RRCA                       ;3C82 0F                                                                           
                 RRCA                       ;3C83 0F                                                                           
                 RET                        ;3C84 C9                                                                           

L3C85:           LD    A,15                 ;3C85 3E0F                                                                         
L3C87:           PUSH  AF                   ;3C87 F5                                                                           
                 LD    A,0                  ;3C88 3E00                                                                         
                 CALL  L3C9D                ;3C8A CD9D3C                                                                       
                 POP   AF                   ;3C8D F1                                                                           
                 OUT   (PTRDATA),A          ;3C8E D3FF                                                                         
                 LD    A,128                ;3C90 3E80                                                                         
                 OUT   (PTRSTROBE),A        ;3C92 D3FE                                                                         
                 LD    A,1                  ;3C94 3E01                                                                         
                 CALL  L3C9D                ;3C96 CD9D3C                                                                       
                 XOR   A                    ;3C99 AF                                                                           
                 OUT   (PTRSTROBE),A        ;3C9A D3FE                                                                         
                 RET                        ;3C9C C9                                                                           

L3C9D:           PUSH  BC                   ;3C9D C5                                                                           
                 PUSH  DE                   ;3C9E D5                                                                           
                 LD    D,A                  ;3C9F 57                                                                           
                 LD    E,6                  ;3CA0 1E06                                                                         
                 LD    BC,COLDSTART         ;3CA2 010000                                                                       
L3CA5:           IN    A,(PTRSTATUS)        ;3CA5 DBFE                                                                         
                 AND   13                   ;3CA7 E60D                                                                         
                 CP    D                    ;3CA9 BA                                                                           
                 JP    NZ,L3CB0             ;3CAA C2B03C                                                                       
                 POP   DE                   ;3CAD D1                                                                           
                 POP   BC                   ;3CAE C1                                                                           
                 RET                        ;3CAF C9                                                                           

L3CB0:           DEC   BC                   ;3CB0 0B                                                                           
                 LD    A,B                  ;3CB1 78                                                                           
                 OR    C                    ;3CB2 B1                                                                           
                 JP    NZ,L3CA5             ;3CB3 C2A53C                                                                       
                 DEC   E                    ;3CB6 1D                                                                           
                 JP    NZ,L3CA5             ;3CB7 C2A53C                                                                       
                 CALL  CRLF                 ;3CBA CD0900                                                                       
                 LD    DE,L3CF0             ;3CBD 11F03C                                                                       
                 CALL  MESSAGE              ;3CC0 CD1500                                                                       
                 JP    L124B                ;3CC3 C34B12                                                                       

L3CC6:           LD    A,7                  ;3CC6 3E07                                                                         
                 CALL  L3C78                ;3CC8 CD783C                                                                       
                 JP    NC,L3CDA             ;3CCB D2DA3C                                                                       
                 LD    A,8                  ;3CCE 3E08                                                                         
                 CALL  L3C78                ;3CD0 CD783C                                                                       
                 RET   C                    ;3CD3 D8                                                                           
                 LD    DE,L3D14             ;3CD4 11143D                                                                       
                 JP    L3CDD                ;3CD7 C3DD3C                                                                       

L3CDA:           LD    DE,L3D1A             ;3CDA 111A3D                                                                       
L3CDD:           CALL  CRLF                 ;3CDD CD0900                                                                       
                 CALL  MESSAGE              ;3CE0 CD1500                                                                       
                 LD    DE,L3D09             ;3CE3 11093D                                                                       
                 CALL  MESSAGE              ;3CE6 CD1500                                                                       
                 XOR   A                    ;3CE9 AF                                                                           
                 LD    (L3D26),A            ;3CEA 32263D                                                                       
                 JP    L124B                ;3CED C34B12                                                                       

L3CF0:           DB    "NO POWER OR "       ;3CF0 4E4F20504F574552204F5220                                                     
                 DB    "NO CONNECTIO"       ;3CFC 4E4F20434F4E4E454354494F                                                     
                 DB    "N"                  ;3D08 4E                                                                           
L3D09:           DB    " (PRINTER)"         ;3D09 20285052494E54455229                                                         
                 DB    0DH                  ;3D13 0D                                                                           
L3D14:           DB    "ALARM"              ;3D14 414C41524D                                                                   
                 DB    0DH                  ;3D19 0D                                                                           
L3D1A:           DB    "PAPER EM"           ;3D1A 504150455220454D                                                             
                 DB    50H,54H,59H,0DH      ;3D22 5054590D                                                                     
L3D26:           DB    0FFH,0F5H,0C5H,0D5H  ;3D26 FFF5C5D5                                                                     
                 DB    0E5H,01H,00H,00H     ;3D2A E5010000                                                                     
                 DB    2AH,71H,11H,3EH      ;3D2E 2A71113E                                                                     
                 DB    28H,95H,47H,21H      ;3D32 28954721                                                                     
                 DB    0C4H,3DH,1AH,0FEH    ;3D36 C43D1AFE                                                                     
                 DB    0DH,0C2H,46H,3DH     ;3D3A 0DC2463D                                                                     
                 DB    0CDH,69H,3DH,0E1H    ;3D3E CD693DE1                                                                     
                 DB    0D1H,0C1H,0F1H,0C9H  ;3D42 D1C1F1C9                                                                     
                 DB    0FEH,20H,0D2H,57H    ;3D46 FE20D257                                                                     
                 DB    3DH,0CDH,69H,3DH     ;3D4A 3DCD693D                                                                     
                 DB    1AH,13H,4FH,0CDH     ;3D4E 1A134FCD                                                                     
                 DB    46H,09H,0C3H,2BH     ;3D52 4609C32B                                                                     
                 DB    3DH,1AH,13H,0CDH     ;3D56 3D1A13CD                                                                     
                 DB    0B9H,0BH,77H,23H     ;3D5A B90B7723                                                                     
                 DB    0CH,05H,0C2H,38H     ;3D5E 0C05C238                                                                     
                 DB    3DH,0CDH,69H,3DH     ;3D62 3DCD693D                                                                     
                 DB    0C3H,2BH,3DH,79H     ;3D66 C32B3D79                                                                     
                 DB    0B7H,0C8H,0D5H,06H   ;3D6A B7C8D506                                                                     
                 DB    00H,3AH,94H,11H      ;3D6E 003A9411                                                                     
                 DB    81H,0FEH,50H,0DAH    ;3D72 81FE50DA                                                                     
                 DB    7AH,3DH,0D6H,50H     ;3D76 7A3DD650                                                                     
                 DB    32H,94H,11H,0CDH     ;3D7A 329411CD                                                                     
                 DB    0B1H,0FH,3AH,71H     ;3D7E B10F3A71                                                                     
                 DB    11H,81H,32H,71H      ;3D82 11813271                                                                     
                 DB    11H,0EBH,21H,0C4H    ;3D86 11EB21C4                                                                     
                 DB    3DH,0CDH,0A6H,0DH    ;3D8A 3DCDA60D                                                                     
                 DB    0EDH,0B0H,0D1H,2AH   ;3D8E EDB0D12A                                                                     
                 DB    71H,11H,7DH,0FEH     ;3D92 71117DFE                                                                     
                 DB    28H,0C0H,0D5H,5CH    ;3D96 28C0D55C                                                                     
                 DB    16H,00H,21H,73H      ;3D9A 16002173                                                                     
                 DB    11H,19H,7EH,0B7H     ;3D9E 11197EB7                                                                     
                 DB    0C2H,0ABH,3DH,23H    ;3DA2 C2AB3D23                                                                     
                 DB    36H,01H,23H,36H      ;3DA6 36012336                                                                     
                 DB    00H,2AH,71H,11H      ;3DAA 002A7111                                                                     
                 DB    2EH,00H,24H,22H      ;3DAE 2E002422                                                                     
                 DB    71H,11H,0D1H,7CH     ;3DB2 7111D17C                                                                     
                 DB    0FEH,19H,0C0H,26H    ;3DB6 FE19C026                                                                     
                 DB    18H,22H,71H,11H      ;3DBA 18227111                                                                     
                 DB    3EH,0C0H,0CDH,0DCH   ;3DBE 3EC0CDDC                                                                     
                 DB    0DH,0C9H,13H,0CH     ;3DC2 0DC9130C                                                                     
                 DB    0FEH,0DH,0C2H,93H    ;3DC6 FE0DC293                                                                     
                 DB    3DH,0DH,0D1H,22H     ;3DCA 3D0DD122                                                                     
                 DB    7BH,61H,0E1H,23H     ;3DCE 7B61E123                                                                     
                 DB    23H,23H,0E5H,0C9H    ;3DD2 2323E5C9                                                                     
                 DB    3AH,7DH,61H,0B7H     ;3DD6 3A7D61B7                                                                     
                 DB    3AH,7AH,61H,0C9H     ;3DDA 3A7A61C9                                                                     
                 DB    0CDH,0C7H,29H,0D5H   ;3DDE CDC729D5                                                                     
                 DB    0CDH,0B2H,26H,2CH    ;3DE2 CDB2262C                                                                     
                 DB    0CDH,0BH,37H,0CDH    ;3DE6 CD0B37CD                                                                     
                 DB    97H,34H,78H,0B7H     ;3DEA 973478B7                                                                     
                 DB    0C2H,9DH,23H,22H     ;3DEE C29D2322                                                                     
                 DB    03H,64H,0CDH,94H     ;3DF2 0364CD94                                                                     
                 DB    29H,0D1H,7BH,0FEH    ;3DF6 29D17BFE                                                                     
                 DB    0F0H,0D2H,98H,23H    ;3DFA F0D29823                                                                     
                 DB    32H,02H,3EH,0DBH     ;3DFE 32023EDB                                                                     
                 DB    0FFH,0B7H,47H,0CAH   ;3E02 FFB747CA                                                                     
                 DB    15H,3EH,3EH,0C8H     ;3E06 153E3EC8                                                                     
                 DB    0CBH,78H,0C2H,17H    ;3E0A CB78C217                                                                     
                 DB    3EH,0CBH,20H,3DH     ;3E0E 3ECB203D                                                                     
                 DB    0C3H,0AH,3EH,3EH     ;3E12 C30A3E3E                                                                     
                 DB    80H,2AH,46H,62H      ;3E16 802A4662                                                                     
                 DB    77H,23H,0AFH,77H     ;3E1A 7723AF77                                                                     
                 DB    23H,77H,23H,77H      ;3E1E 23772377                                                                     
                 DB    23H,70H,57H,5FH      ;3E22 2370575F                                                                     
                 DB    47H,0EH,05H,0CDH     ;3E26 470E05CD                                                                     
                 DB    8FH,29H,0CDH,8EH     ;3E2A 8F29CD8E                                                                     
                 DB    2BH,9DH,23H,0C3H     ;3E2E 2B9D23C3                                                                     
                 DB    0D0H,29H,0CDH,0C7H   ;3E32 D029CDC7                                                                     
                 DB    29H,7BH,0FEH,0F0H    ;3E36 297BFEF0                                                                     
                 DB    0D2H,98H,23H,32H     ;3E3A D2982332                                                                     
                 DB    49H,3EH,0CDH,0B2H    ;3E3E 493ECDB2                                                                     
                 DB    26H,2CH,0CDH,0C7H    ;3E42 262CCDC7                                                                     
                 DB    29H,7BH,0D3H,0FFH    ;3E46 297BD3FF                                                                     
                 DB    0C3H,0D3H,29H,0CDH   ;3E4A C3D329CD                                                                     
                 DB    0C7H,29H,7BH,0FEH    ;3E4E C7297BFE                                                                     
                 DB    0FFH,0CAH,98H,23H    ;3E52 FFCA9823                                                                     
                 DB    0D5H,0CDH,0B2H,26H   ;3E56 D5CDB226                                                                     
                 DB    2CH,0CDH,0BH,37H     ;3E5A 2CCD0B37                                                                     
                 DB    0CDH,97H,34H,22H     ;3E5E CD973422                                                                     
                 DB    03H,64H,78H,0B7H     ;3E62 036478B7                                                                     
                 DB    0CAH,8EH,23H,21H     ;3E66 CA8E2321                                                                     
                 DB    3FH,3FH,0C1H,06H     ;3E6A 3F3FC106                                                                     
                 DB    0AH,7EH,0FEH,0FFH    ;3E6E 0A7EFEFF                                                                     
                 DB    28H,0EH,79H,0BEH     ;3E72 280E79BE                                                                     
                 DB    28H,0AH,23H,23H      ;3E76 280A2323                                                                     
                 DB    23H,23H,23H,10H      ;3E7A 23232310                                                                     
                 DB    0F0H,0C3H,98H,23H    ;3E7E F0C39823                                                                     
                 DB    23H,23H,23H,73H      ;3E82 23232373                                                                     
                 DB    23H,72H,2AH,03H      ;3E86 23722A03                                                                     
                 DB    64H,0CDH,52H,26H     ;3E8A 64CD5226                                                                     
                 DB    0C3H,0D3H,29H,0CDH   ;3E8E C3D329CD                                                                     
                 DB    0C7H,29H,7BH,0FEH    ;3E92 C7297BFE                                                                     
                 DB    0FFH,0CAH,98H,23H    ;3E96 FFCA9823                                                                     
                 DB    0D5H,0CDH,0B2H,26H   ;3E9A D5CDB226                                                                     
                 DB    2CH,0CDH,03H,27H     ;3E9E 2CCD0327                                                                     
                 DB    22H,03H,64H,21H      ;3EA2 22036421                                                                     
                 DB    3FH,3FH,0C1H,06H     ;3EA6 3F3FC106                                                                     
                 DB    0AH,7EH,0FEH,0FFH    ;3EAA 0A7EFEFF                                                                     
                 DB    28H,14H,79H,0BEH     ;3EAE 281479BE                                                                     
                 DB    28H,0AH,23H,23H      ;3EB2 280A2323                                                                     
                 DB    23H,23H,23H,10H      ;3EB6 23232310                                                                     
                 DB    0F0H,0C3H,98H,23H    ;3EBA F0C39823                                                                     
                 DB    06H,02H,3EH,0FFH     ;3EBE 06023EFF                                                                     
                 DB    18H,03H,06H,03H      ;3EC2 18030603                                                                     
                 DB    71H,23H,73H,23H      ;3EC6 71237323                                                                     
                 DB    72H,23H,77H,10H      ;3ECA 72237710                                                                     
                 DB    0FCH,0C3H,88H,3EH    ;3ECE FCC3883E                                                                     
                 DB    22H,03H,64H,21H      ;3ED2 22036421                                                                     
                 DB    3EH,3FH,23H,7EH      ;3ED6 3E3F237E                                                                     
                 DB    0FEH,0FFH,0CAH,88H   ;3EDA FEFFCA88                                                                     
                 DB    3EH,23H,23H,23H      ;3EDE 3E232323                                                                     
                 DB    23H,7EH,0FEH,0F0H    ;3EE2 237EFEF0                                                                     
                 DB    28H,0F0H,7EH,0FEH    ;3EE6 28F07EFE                                                                     
                 DB    0FFH,28H,0DH,23H     ;3EEA FF280D23                                                                     
                 DB    7EH,0FEH,0FFH,0CAH   ;3EEE 7EFEFFCA                                                                     
                 DB    1BH,4FH,23H,23H      ;3EF2 1B4F2323                                                                     
                 DB    23H,23H,18H,0EEH     ;3EF6 232318EE                                                                     
                 DB    2BH,2BH,56H,2BH      ;3EFA 2B2B562B                                                                     
                 DB    5EH,0C3H,00H,00H     ;3EFE 5EC30000                                                                     



        END

