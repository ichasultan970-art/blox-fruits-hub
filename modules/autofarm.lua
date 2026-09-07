-- BYTECODE -- loader.lua:3-8
0001    ISNEP    0   0
0002    JMP      1 => 0005
0003    KPRI     1   1
0004    RET1     1   2
0005 => TGETS    1   0   0  ; "CommF_"
0006    ISEQP    1   2
0007    JMP      1 => 0010
0008    KPRI     1   1
0009    RET1     1   2
0010 => TGETS    1   0   1  ; "Quests"
0011    ISEQP    1   2
0012    JMP      1 => 0015
0013    KPRI     1   1
0014    RET1     1   2
0015 => KPRI     1   2
0016    RET1     1   2

-- BYTECODE -- loader.lua:9-11
0001    TDUP     2   0
0002    ISEQP    0   2
0003    JMP      3 => 0006
0004    KPRI     3   1
0005    JMP      4 => 0007
0006 => KPRI     3   2
0007 => TSETS    3   2   1  ; "CommF_"
0008    ISEQP    1   2
0009    JMP      3 => 0012
0010    KPRI     3   1
0011    JMP      4 => 0013
0012 => KPRI     3   2
0013 => TSETS    3   2   2  ; "Quests"
0014    RET1     2   2

-- BYTECODE -- loader.lua:21-28
0001    GGET     0   0      ; "game"
0002    MOV      2   0
0003    TGETS    0   0   1  ; "GetService"
0004    KSTR     3   2      ; "StarterGui"
0005    CALL     0   2   3
0006    MOV      2   0
0007    TGETS    0   0   3  ; "SetCore"
0008    KSTR     3   4      ; "ChatMakeSystemMessage"
0009    TDUP     4   6
0010    KSTR     5   5      ; "[Hub] "
0011    UGET     6   0      ; msg
0012    CAT      5   5   6
0013    TSETS    5   4   7  ; "Text"
0014    GGET     5   8      ; "Color3"
0015    TGETS    5   5   9  ; "fromRGB"
0016    KSHORT   7   0
0017    KSHORT   8 255
0018    KSHORT   9   0
0019    CALL     5   2   4
0020    TSETS    5   4  10  ; "Color"
0021    GGET     5  11      ; "Enum"
0022    TGETS    5   5  12  ; "Font"
0023    TGETS    5   5  13  ; "Code"
0024    TSETS    5   4  12  ; "Font"
0025    GGET     5  11      ; "Enum"
0026    TGETS    5   5  14  ; "FontSize"
0027    TGETS    5   5  15  ; "Size18"
0028    TSETS    5   4  14  ; "FontSize"
0029    CALL     0   1   4
0030    RET0     0   1

-- BYTECODE -- loader.lua:19-29
0001    GGET     1   0      ; "print"
0002    KSTR     3   1      ; "[Hub] "
0003    MOV      4   0
0004    CAT      3   3   4
0005    CALL     1   1   2
0006    GGET     1   2      ; "pcall"
0007    FNEW     3   3      ; loader.lua:21
0008    CALL     1   1   2
0009    UCLO     0 => 0010
0010 => RET0     0   1

-- BYTECODE -- loader.lua:43-50
0001    GGET     3   0      ; "loadstring"
0002    MOV      5   0
0003    KSTR     6   1      ; "="
0004    MOV      7   1
0005    CAT      6   6   7
0006    CALL     3   3   3
0007    ISNEP    3   0
0008    JMP      5 => 0012
0009    KPRI     5   0
0010    MOV      6   4
0011    RET      5   3
0012 => GGET     5   2      ; "setfenv"
0013    MOV      7   3
0014    GGET     8   3      ; "setmetatable"
0015    ISTC    10   2
0016    JMP     10 => 0018
0017    TNEW    10   0
0018 => TDUP    11   5
0019    GGET    12   4      ; "getgenv"
0020    CALL    12   2   1
0021    TSETS   12  11   6  ; "__index"
0022    CALL     8   0   3
0023    CALLM    5   1   1
0024    GGET     5   7      ; "pcall"
0025    MOV      7   3
0026    CALL     5   3   2
0027    ISEQP    5   2
0028    JMP      7 => 0032
0029    KPRI     7   0
0030    MOV      8   6
0031    RET      7   3
0032 => RET1     6   2

-- BYTECODE -- loader.lua:52-55
0001    UGET     1   0      ; RAND_TOKEN
0002    ISNEV    0   1
0003    JMP      1 => 0007
0004    UGET     1   1      ; Hub
0005    TGETS    1   1   0  ; "rand"
0006    RET1     1   2
0007 => GGET     1   1      ; "require"
0008    MOV      3   0
0009    CALLT    1   2

-- BYTECODE -- loader.lua:78-78
0001    UGET     0   0      ; Remotes
0002    MOV      2   0
0003    TGETS    0   0   0  ; "WaitForChild"
0004    KSTR     3   1      ; "CommF_"
0005    KSHORT   4   5
0006    CALLT    0   4

-- BYTECODE -- loader.lua:91-97
0001    GGET     0   0      ; "game"
0002    MOV      2   0
0003    TGETS    0   0   1  ; "GetService"
0004    KSTR     3   2      ; "StarterGui"
0005    CALL     0   2   3
0006    MOV      2   0
0007    TGETS    0   0   3  ; "SetCore"
0008    KSTR     3   4      ; "SendNotification"
0009    TDUP     4   7
0010    KSTR     5   5      ; "Hub boot v"
0011    UGET     6   0      ; Loader
0012    TGETS    6   6   6  ; "VERSION"
0013    CAT      5   5   6
0014    TSETS    5   4   8  ; "Title"
0015    CALL     0   1   4
0016    RET0     0   1

-- BYTECODE -- loader.lua:98-100
0001    GGET     0   0      ; "game"
0002    MOV      2   0
0003    TGETS    0   0   1  ; "GetService"
0004    KSTR     3   2      ; "VirtualUser"
0005    CALL     0   2   3
0006    MOV      2   0
0007    TGETS    0   0   3  ; "ClickButton2"
0008    GGET     3   4      ; "Vector2"
0009    TGETS    3   3   5  ; "new"
0010    CALL     3   0   1
0011    CALLM    0   1   1
0012    RET0     0   1

-- BYTECODE -- loader.lua:0-105
0001    TNEW     0   0
0002    KSTR     1   1      ; "1.5.0"
0003    TSETS    1   0   0  ; "VERSION"
0004    FNEW     1   3      ; loader.lua:3
0005    TSETS    1   0   2  ; "DepsOk"
0006    FNEW     1   5      ; loader.lua:9
0007    TSETS    1   0   4  ; "BuildDeps"
0008    GGET     1   6      ; "game"
0009    ISEQP    1   0
0010    JMP      1 => 0017
0011    GGET     1   7      ; "type"
0012    GGET     3   6      ; "game"
0013    TGETS    3   3   8  ; "GetService"
0014    CALL     1   2   2
0015    ISEQS    1   9      ; "function"
0016    JMP      1 => 0019
0017 => KPRI     1   1
0018    JMP      2 => 0020
0019 => KPRI     1   2
0020 => ISEQP    1   2
0021    JMP      2 => 0024
0022    UCLO     0 => 0023
0023 => RET1     0   2
0024 => GGET     2  10      ; "tostring"
0025    GGET     4  11      ; "getexecutorname"
0026    ISF          4
0027    JMP      5 => 0032
0028    GGET     4  11      ; "getexecutorname"
0029    CALL     4   2   1
0030    IST          4
0031    JMP      5 => 0033
0032 => KSTR     4  12      ; "unknown"
0033 => CALL     2   2   2
0034    FNEW     3  13      ; loader.lua:19
0035    MOV      4   3
0036    KSTR     6  14      ; "boot v"
0037    TGETS    7   0   0  ; "VERSION"
0038    KSTR     8  15      ; " executor: "
0039    MOV      9   2
0040    CAT      6   6   9
0041    CALL     4   1   2
0042    KSTR     4  16      ; "https://raw.githubusercontent.com/ichasu"~
0043    TDUP     5  17
0044    TNEW     6   0
0045    TNEW     7   0
0046    GGET     8  18      ; "ipairs"
0047    MOV     10   5
0048    CALL     8   4   2
0049    JMP     11 => 0069
0050 => GGET    13  19      ; "pcall"
0051    GGET    15   6      ; "game"
0052    TGETS   15  15  20  ; "HttpGet"
0053    GGET    16   6      ; "game"
0054    MOV     17   4
0055    KSTR    18  21      ; "modules/"
0056    MOV     19  12
0057    KSTR    20  22      ; ".lua"
0058    CAT     17  17  20
0059    CALL    13   3   4
0060    ISEQP   13   2
0061    JMP     15 => 0068
0062    GGET    15  23      ; "table"
0063    TGETS   15  15  24  ; "insert"
0064    MOV     17   7
0065    MOV     18  12
0066    CALL    15   1   3
0067    JMP     15 => 0069
0068 => TSETV   14   6  12
0069 => ITERC   11   3   3
0070    ITERL   11 => 0050
0071    TNEW     8   0
0072    TNEW     9   0
0073    FNEW    10  25      ; loader.lua:43
0074    TDUP    11  28
0075    TDUP    12  26
0076    TSETS    9  12  27  ; "rand"
0077    TSETS   12  11  29  ; "Parent"
0078    FNEW    12  30      ; loader.lua:52
0079    GGET    13  18      ; "ipairs"
0080    MOV     15   5
0081    CALL    13   4   2
0082    JMP     16 => 0133
0083 => TGETV   18   6  17
0084    ISNEP   18   0
0085    JMP     19 => 0094
0086    GGET    19  23      ; "table"
0087    TGETS   19  19  24  ; "insert"
0088    MOV     21   7
0089    MOV     22  17
0090    KSTR    23  31      ; "(unduh)"
0091    CAT     22  22  23
0092    CALL    19   1   3
0093    JMP     19 => 0133
0094 => KPRI    19   0
0095    ISEQS   17  32      ; "combat"
0096    JMP     20 => 0099
0097    ISNES   17  33      ; "teleport"
0098    JMP     20 => 0103
0099 => TDUP    20  34
0100    TSETS   11  20  35  ; "script"
0101    TSETS   12  20  36  ; "require"
0102    MOV     19  20
0103 => MOV     20  10
0104    MOV     22  18
0105    MOV     23  17
0106    MOV     24  19
0107    CALL    20   3   4
0108    ISNEP   20   0
0109    JMP     22 => 0132
0110    GGET    22  23      ; "table"
0111    TGETS   22  22  24  ; "insert"
0112    MOV     24   7
0113    MOV     25  17
0114    KSTR    26  37      ; "(load)"
0115    CAT     25  25  26
0116    CALL    22   1   3
0117    MOV     22   3
0118    KSTR    24  38      ; "gagal muat "
0119    MOV     25  17
0120    KSTR    26  39      ; ": "
0121    GGET    27  10      ; "tostring"
0122    MOV     29  21
0123    CALL    27   2   2
0124    MOV     29  27
0125    TGETS   27  27  40  ; "sub"
0126    KSHORT  30   1
0127    KSHORT  31 120
0128    CALL    27   2   4
0129    CAT     24  24  27
0130    CALL    22   1   2
0131    JMP     22 => 0133
0132 => TSETV   20   8  17
0133 => ITERC   16   3   3
0134    ITERL   16 => 0083
0135    GGET    13  41      ; "getgenv"
0136    CALL    13   2   1
0137    TSETS    8  13  42  ; "HubFarm_Mods"
0138    GGET    13   6      ; "game"
0139    MOV     15  13
0140    TGETS   13  13   8  ; "GetService"
0141    KSTR    16  43      ; "ReplicatedStorage"
0142    CALL    13   2   3
0143    MOV     15  13
0144    TGETS   13  13  44  ; "FindFirstChild"
0145    KSTR    16  45      ; "Remotes"
0146    CALL    13   2   3
0147    KPRI    14   1
0148    ISEQP   13   0
0149    JMP     15 => 0160
0150    GGET    15  19      ; "pcall"
0151    FNEW    17  46      ; loader.lua:78
0152    CALL    15   3   2
0153    ISNEP   15   2
0154    JMP     17 => 0157
0155    ISNEP   16   0
0156    JMP     17 => 0159
0157 => KPRI    14   1
0158    JMP     17 => 0160
0159 => KPRI    14   2
0160 => GGET    15   6      ; "game"
0161    MOV     17  15
0162    TGETS   15  15   8  ; "GetService"
0163    KSTR    18  47      ; "Workspace"
0164    CALL    15   2   3
0165    MOV     18  15
0166    TGETS   16  15  44  ; "FindFirstChild"
0167    KSTR    19  48      ; "NPCs"
0168    CALL    16   2   3
0169    IST         16
0170    JMP     17 => 0175
0171    MOV     18  15
0172    TGETS   16  15  44  ; "FindFirstChild"
0173    KSTR    19  49      ; "Quests"
0174    CALL    16   2   3
0175 => TGETS   17   0   4  ; "BuildDeps"
0176    MOV     19  14
0177    ISNEP   16   0
0178    JMP     20 => 0181
0179    KPRI    20   1
0180    JMP     21 => 0182
0181 => KPRI    20   2
0182 => CALL    17   2   3
0183    MOV     18   3
0184    KSTR    20  50      ; "modul gagal: "
0185    LEN     21   7
0186    ISNEN   21   0      ; 0
0187    JMP     21 => 0190
0188    KSTR    21  51      ; "-"
0189    JMP     22 => 0195
0190 => GGET    21  23      ; "table"
0191    TGETS   21  21  52  ; "concat"
0192    MOV     23   7
0193    KSTR    24  53      ; ","
0194    CALL    21   2   3
0195 => CAT     20  20  21
0196    CALL    18   1   2
0197    MOV     18   3
0198    KSTR    20  54      ; "CommF_="
0199    GGET    21  10      ; "tostring"
0200    TGETS   23  17  55  ; "CommF_"
0201    CALL    21   2   2
0202    KSTR    22  56      ; " Quests="
0203    GGET    23  10      ; "tostring"
0204    TGETS   25  17  49  ; "Quests"
0205    CALL    23   2   2
0206    CAT     20  20  23
0207    CALL    18   1   2
0208    TGETS   18   0   2  ; "DepsOk"
0209    MOV     20  17
0210    CALL    18   2   2
0211    ISEQP   18   2
0212    JMP     18 => 0217
0213    MOV     18   3
0214    KSTR    20  57      ; "status: SAFE (farm mati, ESP saja)"
0215    CALL    18   1   2
0216    JMP     18 => 0220
0217 => MOV     18   3
0218    KSTR    20  58      ; "status: READY (semua dep hijau)"
0219    CALL    18   1   2
0220 => GGET    18  19      ; "pcall"
0221    FNEW    20  59      ; loader.lua:91
0222    CALL    18   1   2
0223    GGET    18   6      ; "game"
0224    MOV     20  18
0225    TGETS   18  18   8  ; "GetService"
0226    KSTR    21  60      ; "Players"
0227    CALL    18   2   3
0228    TGETS   18  18  61  ; "LocalPlayer"
0229    TGETS   18  18  62  ; "Idled"
0230    MOV     20  18
0231    TGETS   18  18  63  ; "Connect"
0232    FNEW    21  64      ; loader.lua:98
0233    CALL    18   1   3
0234    MOV     18   3
0235    KSTR    20  65      ; "anti-AFK aktif. ESP label musuh/peti/NPC"~
0236    CALL    18   1   2
0237    MOV     18   3
0238    KSTR    20  66      ; "Boot selesai."
0239    CALL    18   1   2
0240    UCLO     1 => 0241
0241 => UCLO     0 => 0242
0242 => RET1     0   2

