000100000000    ? * ------------------------------------------------------------------------------------------ *
000200000000    ? *          ?                     (©) Sofina Foods Inc. - 2010                     ?
000300000000    ? * ------------------------------------------------------------------------------------------ *
000400000000    ? *                                                                                            *
000500000000    ? *          ?Maintain the BOM Detail File  -  Costing System - Bill of Material               *
000600000000    ? *                                                                                            *
000700000000    ? * ------------------------------------------------------------------------------------------ *
000800000000    ? *?                Modification Log                                                    ?      *
000900000000    ? *?                ~~~~~~~~~~~~~~~~                                                    ?      *
001000000000    ? *?  Date  ??Vers??Purpose                                                                   ?*
001100000000    ? *                                                                                            *
001200000000    ? * 10-08-16  RS    Original                                                                   *
001300111103    ? *                                                                                            *
001400111103    ? * 11-11-03  RS    Added option "8" which acts as if the program was called from the Header   *
001500111103    ? *                 Maintenance program.  Thus, components can be viewed recursively, i.e.     *
001600111103    ? *                 this program can display the sub-components of sub-components.             *
001700111103    ? *                 The recursion is implemented via stack Opt8Stk.                            *
001800000000    ? *                                                                                            *
001900150624    ? * 15-06-24  RS    Introduction of BOM-active flag.  Better window restoring after prompt.    *
001901170321    ? * 17-03-21  RS    Better handling of Component input for non Materials: Shift left no tail.  *
001902230524    ? * 20230524  LX    Add new option for explosion info                                          *
002000230919    ? * 20230829  DJ    Testing the edit from Github   - Ohooooooooo                               *
002100000000    ? * ------------------------------------------------------------------------------------------ *
002200000000    ?
002300000000    ?FCSBOMD#   CF   E             WORKSTN INFDS(@$DSPI)                        Bill of Material Hea
002400000000    ?F                                     USROPN
002500000000    ?F                                     SFILE(###S1:RRN1)
002600000000    ?F                                     MAXDEV(*FILE)
002700000000    ?F                                     INFSR(*PSSR)
002800000000    ?FCSBOMD    UF A E           K DISK    INFDS(@$DBFI)                        Bill of Material Det
002900000000    ?F                                     USROPN
003000000000    ?F                                     INFSR(*PSSR)
003100000000    ?FCSBOMH    IF   E           K DISK    USROPN                               Bill of Material Hea
003200000000    ?F                                     INFSR(*PSSR)
003300000000    ?FCSLABR    UF   E           K DISK    USROPN                               Labour Master
003400000000    ?F                                     INFSR(*PSSR)
003500000000    ?FCSOVHT    UF   E           K DISK    USROPN                               Overhead/Transfer Pr
003600000000    ?F                                     INFSR(*PSSR)
003700000000    ?FCOMAST    IF   E           K DISK    USROPN                               Company Master File
003800000000    ?F                                     INFSR(*PSSR)
003900000000    ?FOPPROD    UF   E           K DISK    USROPN                               Product Master File
004000000000    ?F                                     INFSR(*PSSR)
004100000000    ?
004200000000    ? /COPY @DSPINFO
004300000000    ? /COPY @DBFINFO
004400000000    ? /COPY @PGMINFO
004500000000    ? /COPY @APIPARMS
004600000000    ? /COPY @LDA
004700000000    ?
004800000000    ? * ------------------------------------------------------------------------------------------ *
004900000000    ? *                P R O T O T Y P E S   (MAIN FIRST)                                          *
005000000000    ? * ------------------------------------------------------------------------------------------ *
005100000000    ?
005200000000    ?D MainProcedure   PR                  extpgm('CSBOMD@')                    This Program:
005300000000    ?D  P$KEY                              like(F$KEY) options(*OMIT)            Primary File Key
005400000000    ?
005500000000    ? /COPY @PROTOSUB
005600000000    ?
005700000000    ? * -------------- U T I L I T I E S --------------------------------------------------------- *
005800000000    ?
005900000000    ?
006000000000    ?D GetStack        PR                  extpgm('$GETSTK')                    Get Program Stack
006100000000    ?D  StackBuff                          like(TheStack)
006200000000    ?
006300000000    ?D CSCOST          PR                  extpgm('CSCOST')                     Cost Rollup
006400000000    ?D  WorkCenter                         like(BDWRKC) options(*NOPASS)
006500000000    ?D  Product                            like(BDPROD) options(*NOPASS)
006600000000    ?
006700000000    ?D CSCOSTRM        PR                  extpgm('CSCOSTRM')                   Where-used Cost
006800000000    ?D  Component                          options(*OMIT) like(BDITEM)
006900000000    ?
007000000000    ?D CS0CHK          PR                  extpgm('CS0CHK')                     Continuity Check
007100000000    ?D  Parent                             options(*NOPASS) like(BDITEM)
007200000000    ?D  Component                          options(*NOPASS) like(BDITEM)
007300000000    ?D  MessageID                          options(*NOPASS) like(@@SMID)
007400000000    ?
007500000000    ?D WhereUsed       PR                  extpgm('CST100')
007600000000    ?D  WorkCenter                         like(BDWRKC)
007700000000    ?D  Product                            like(BDPROD)
007701230524    ?
007702230524    ?D Explosion       PR                  extpgm('CST901@')
007703230524    ?D  WorkCenter                         like(BDWRKC)
007704230524    ?D  Product                            like(BDPROD)
007705230524    ?D  CCoNumb                            like(ICoNumb)
007800000000    ?
007801170629    ?D Implosion       PR                  extpgm('CSBOMI')                     Product Implosion Rp
007802170629    ?D  WorkCenter                         like(BDWRKC)
007803170629    ?D  Product                            like(BDPROD)
007804170629    ?D  Required                           like(BHQTY ) const
007805170629    ?
007900000000    ? * -------------  P R O M P T E D   P R O G R A M S  ---------------------------------------- *
008000000000    ?
008100000000    ?D SELITEM         PR                  extpgm('SELITEM')                    Product Selection
008200000000    ?D  P$PRD                              like(D$PRD)
008300000000    ?
008400000000    ?D SELLBR          PR                  extpgm('SELLBR')
008500000000    ?D  P$PRD                              options(*NOPASS) like(D$PRD)
008600000000    ?
008700000000    ?D SELOVR          PR                  extpgm('SELOVR')
008800000000    ?D  P$PRD                              options(*NOPASS) like(D$PRD)
008900000000    ?
009000000000    ?D ProdMaint       PR                  extpgm('PRD$CS')                     OPPROD@ Wrapper call
009100000000    ?
009200000000    ?
009300000000    ? * ------------------------------------------------------------------------------------------ *
009400000000    ? *                W o r k i n g   S t o r a g e                                               *
009500000000    ? * ------------------------------------------------------------------------------------------ *
009600000000    ?
009700000000    ?D D$SDTA          DS            80                                         Map Message Data Fld
009800000000    ?D  D$AHOC                 1     80
009900000000    ?
010000000000    ?DIndicators       S               *   inz(%ADDR(*IN))                      The Indicators
010100000000    ?D                 DS                  based(Indicators)                     as a Data Structure
010200000000    ?D ##ERR                  31     48                                          The ERROR Inds
010300150624    ?D Pagers                 27     28                                          Roll/Page Inds
010400150624    ?D  PgUp                  27     27N                                          Page Up / Roll Dwn
010500150624    ?D  PgDn                  28     28N                                          Page Dwn / Roll Up
010600000000    ?D in2930                 29     30                                          Errors: SFL/General
010700000000    ?D GenError               30     30N                                         General Error/Alarm
010800000000    ?D OptError               31     31N                                         Option  Error
010900000000    ?D in5155                 51     55                                          Show new proposed
011000000000    ?D in5657                 56     57                                          Show new proposed
011100000000    ?D in7678                 76     78                                          Toggle Sequences
011200000000    ?D SelectMode             81     81N                                         Select: #Parm = 1
011300000000    ?D UpdateMode             82     82N                                         Update: #Parm = 0/1
011400000000    ?D in8283                 82     83                                          Update on Opt5 Save
011500000000    ?D BOMmaint               85     85N                                         BOM maintenance
011600000000    ?D in9094                 90     94                                          EOF & Display Inds
011700150624    ?D DspFns                 90     94                                         Display Functions:
011800150624    ?D  DspSFL                90     90N                                         Display Subfile
011900150624    ?D  DspCTL                91     91N                                         Display Subfile Ctl
012000150624    ?D  InzSFL                92     92N                                         Initialize SFL
012100150624    ?D  DltSFL                93     93N                                         Delete SFL
012200150624    ?D  ClrSFL                94     94N                                         Clear  SFL
012300150624    ?D SflEnd                 95     95N                                         no More...
012400000000    ?D in9699                 96     99                                          General Purpose
012500000000    ?
012600000000    ?D TheStack        DS
012700000000    ?D  Stack                        10A   DIM(50) OVERLAY(TheStack)            Program Stack
012800000000    ?
012900111103    ?D Opt8Stk         DS                  DIM(20) qualified                    Stack of Parent Keys
013000111103    ?D  C1KEY                              like(C1$KEY)
013100111103    ?D  C1KEYalt                           like(C1$KEYalt)
013200111103    ?D  Factor                             like(L@XFAC)
013300111103    ?D  Cursor                             like(CSR1)
013400111103    ?
013500000000    ?
013600000000    ?DWorkingStorage   DS                                                       Mapped Storage
013700000000    ? *                                                                         ~~~~~~~~~~~~~~
013800000000    ? *     Cursor Row and Column Fields
013900000000    ?D  ##ROW                  5      6B 0 inz(0)                               --> Output
014000000000    ?D  @#ROW                  6      6                                         Input (current)
014100000000    ?
014200000000    ?D  ##COL                  7      8B 0 inz(0)                               --> Output
014300000000    ?D  @#COL                  8      8                                         Input (current)
014400000000    ?
014500000000    ? *     WINDOW SCREEN PANEL: COUNTER / MAX
014600000000    ?D  ###WD@                11     13                                         Top right Display
014700000000    ?D   ###WD#                       1  0 inz(0)    overlay(###WD@)             Current Panel
014800000000    ?D   ###WD$                       1    inz('/')  overlay(###WD@:*NEXT)       "of"
014900000000    ?D   ###WDS                       1  0 inz(1)    overlay(###WD@:*NEXT)       total Nbr panels.
015000000000    ? * = = = = = = = = = = = = = = = = = = = -¦-
015100000000    ?D  ###WD0                14     14  0 inz(1)                               Starting Panel Nbr
015200000000    ?
015300000000    ? *     TABLES
015400000000    ?
015500000000    ?D TABC            S              2    dim(4)  CTDATA PERRCD(1) ASCEND
015600000000    ?D TABCT           S             15    dim(4)  ALT(TABC)
015700000000    ?
015800000000    ? *     Stand alone fields and constants
015900000000    ?
016000000000    ?D Command         S            160A   inz                                  QCMDEXC Parms
016100000000    ?D CmdLen          S             15p 5 inz(%LEN(Command))
016200000000    ?
016300000000    ?D C$ZERR          S                   like(##ERR)  inz(*ALL'0')            Errors Reset Value
016400000000    ?D QRYfile         S             10A   inz                                  Opened via OPNQRY
016500000000    ?D QRYopen         S               N   inz                                   when *ON.
016600000000    ?D FileOpen        S               N   inz                                  Files open when *ON.
016700000000    ?
016800000000    ?D  I              S              2B 0 inz(0)                               Counters/Pointers
016900000000    ?D  J              S              2B 0 inz(0)
017000000000    ?D  WORK8          S              8S 0 inz                                  8 Digit Date Worker
017100000000    ?D  P$STRG         S            256A                                        String for centering
017200000000    ?
017300000000    ?D  D$DSTS         S              5  0 inz                                  DSPINF Status Code
017400000000    ?D  D$AID          S              1    inz                                  AID Saver
017401230524     D ICoNumb         s              2a   inz
017500000000    ?
017600000000    ? *     DEFINE MESSAGE CONSTANTS FOR IMPROMPTU (CPF9898) MESSAGES
017700000000    ?
017800000000    ?D D$HB            C                   const(X'2A')                         HI and Blink
017900000000    ?D #MSG01          C                   const('Invalid option, sele-
018000000000    ?D                                     ct choice from above')
018100000000    ?D #MSG02          C                   const('Invalid function key-
018200000000    ?D                                     , choose from list ab-
018300000000    ?D                                     ove')
018400000000    ?D C$MSGF          C                   const('CSMESSAGE')                   The Message File
018500000000    ?D C$1331          C                   const(1331)                          Time-out Status
018600000000    ?
018700000000    ? * - - - - - - - - - - - - - - - - - - - - -\
018800000000    ?D #SFLPG          S              4B 0 inz(00)                              SubFile Size-dynamic
018900000000    ? * - - - - - - - - - - - - - - - - - - - - -/                                           via API
019000000000    ?
019100000000    ? * =============  A U X I L L A R Y   F I L E   K E Y S / P A R M S  ======================== *
019200000000    ?
019300000000    ? *     Composite Keys passed as Parms to Selector Programs
019400000000    ? *     and used as Key Fields (%KDS) for File Access.
019500000000    ?
019600000000    ?D D$PRD           DS                  inz                                  Product Parm/Key
019700000000    ?D  PCOMP                                                                   Company Number
019800000000    ?D  Component                          like(BDITEM)                         Map it various ways:
019900000000    ?
020000000000    ?D   PMANID                            overlay(Component)                   Manfacture Id
020100000000    ?D   PNUMB                             overlay(Component:*NEXT)             Product Code
020200000000    ?
020300000000    ?D   LALABC                            overlay(Component)                   Labour Code
020400000000    ?
020500000000    ?D   OTOVHT                            overlay(Component)                   Overhead/TP Code
020600000000    ?
020700000000    ?
020800000000    ? * =============  P R I M A R Y  /  A L T E R N A T E   K E Y S  ============================ *
020900000000    ?
021000000000    ? *     The following defines the Primary and Alternate Keys Fields.
021100000000    ? *     All fields, hidden and visible, should be defined in the Display File.
021200000000    ? *?    ~~~~~~~~~~                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
021300000000    ? *     These Data Structures are used for easy Save/Restore Moves and Clears.
021400000000    ?
021500000000    ? *     SFLCTL KEY FIELDS FOR REPOSITIONING
021600000000    ?D C1$KEY          DS                  inz                                  Primary SFLCTL
021700000000    ?D  C1KEY1                                                                  Company Number
021800000000    ?D  C1KEY2                                                                  Work Center
021900000000    ?D  C1KEY3                                                                  Product Code
022000000000    ?D  C1KEY4                                                                  Component
022100000000    ?D  C1KEY5                                                                  Cost Type
022200000000    ?
022300000000    ?D C1$KEYalt       DS                  inz                                  Alternate SFLCTL
022400000000    ?
022500000000    ? *     COMPOSITE FILE KEY IS HIDDEN IN SFL
022600000000    ?D H$KEY           DS                  inz                                  Primary SFL - hidden
022700000000    ?D  H$1KY1                                                                  Company Number
022800000000    ?D  H$1KY2                                                                  Work Center
022900000000    ?D  H$1KY3                                                                  Product Code
023000000000    ?D  H$1KY4                                                                  Component
023100000000    ?D  H$1KY5                                                                  Cost Type
023200000000    ?
023300000000    ?D H$KEYalt        DS                  inz                                  Alternate SFL hidden
023400000000    ?
023500000000    ? *     COMPOSITE FILE KEY IS ALSO PASSED AS {PARAMETER} - PLIST
023600000000    ?D F$KEY           DS                  inz                                  Primary SFL -visible
023700000000    ?D  BDCOMP                                                                  Company Number
023800000000    ?D  BDWRKC                                                                  Work Center
023900000000    ?D  BDPROD                                                                  Product Code
024000000000    ?D  BDITEM                                                                  Component
024100000000    ?D  BDTYPE                                                                  Cost Type
024200000000    ?
024300000000    ?D F$KEYalt        DS                  inz                                  Alternate SFL - v/h
024400000000    ?
024500000000    ? * ------------------------------------------------------------------------------------------ *
024600000000    ? *                M A I N   P R O C E D U R E   I N T E R F A C E   ( PLIST )                 *
024700000000    ? * ------------------------------------------------------------------------------------------ *
024800000000    ?
024900000000    ?D MainProcedure   PI                                                       Parm List:
025000000000    ?D  P$KEY                              like(F$KEY) options(*OMIT)
025100000000    ?
025200000000    ? *     Primary and Alternate File Key are defined here and used for Consistency
025300000000    ? *     because the Alternate Keys can not be used as Data Structure Keys (%KDS)
025400000000    ? *     Nevertheless, all Key Fields used here are also listed in the above DSs.
025500000000    ?
025600000000    ?C     FLEKEY        KLIST                                                  FILE KEY:
025700000000    ?C                   KFLD                    BDCOMP                         Company Number
025800000000    ?C                   KFLD                    BDWRKC                         Work Center
025900000000    ?C                   KFLD                    BDPROD                         Product Code
026000000000    ?C                   KFLD                    BDITEM                         Component
026100000000    ?C                   KFLD                    BDTYPE                         Cost Type
026200000000    ?
026300000000    ?C     SFLKEY        KLIST                                                  SUBFILE KEY:
026400000000    ?C                   KFLD                    H$1KY1                         Company Number
026500000000    ?C                   KFLD                    H$1KY2                         Work Center
026600000000    ?C                   KFLD                    H$1KY3                         Product Code
026700000000    ?C                   KFLD                    H$1KY4                         Component
026800000000    ?C                   KFLD                    H$1KY5                         Component
026900000000    ?
027000000000    ?C     LVLKEY        KLIST                                                  PARENT LVL KEY:
027100000000    ?C                   KFLD                    BDCOMP                         Company Number
027200000000    ?C                   KFLD                    BDWRKC                         Work Center
027300000000    ?C                   KFLD                    BDPROD                         Product Code
027400000000    ?
027500000000    ? /free
027600000000    ?
027700000000    ?  // *                                                                                        *
027800000000    ?  // * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  *
027900000000    ?  // * * *        M  A  I  N  L  I  N  E                                                  * * *
028000000000    ?  // * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  *
028100000000    ?  // *                                                                                        *
028200000000    ?
028300000000b1  ?  dou *IN03 ;                                         //?UNTIL EXIT
028400000000    ?     EXSR    $CSET ;                                  //?CONTROL SETTING
028500000000    ?     WRITE    ###D1;                                  //?F-KEYS LINEs
028600000000    ?     WRITE    ###MC;                                  //?MESSAGES
028700000000    ?     WRITE    ###C1;                                  //?HEADINGS/LIST
028800000000    ?     READ(e)  CSBOMD#;                                //?GET RESPONSE
028900000000b2  ?     if *IN03 or %ERROR ;                             //?EXIT
029000000000    ?        EXSR  $F03 ;                                  //?F3 = EXIT
029100000000e2  ?     endif ;
029200000000    ?
029300000000    ?     EXSR  $CLEAR ;                                   //?RESET I/O, ERRS
029400000000    ?     EXSR  $MODSFL ;                                  //?SFL MODIFIED?
029500000000    ?
029600000000b2  ?     select ;                                         //?Process by functional Response:
029700000000x2  ?     when @@AID =  C@F02 ;
029800000000    ?        EXSR $F02 ;                                   //?F2 = ATTRIB HELP
029900000000x2  ?     when @@AID =  C@F03 ;
030000000000    ?        EXSR $F03 ;                                   //?F3 = EXIT
030100000000x2  ?     when @@AID =  C@F04 ;
030200000000    ?        EXSR $F04 ;                                   //?F4 = PROMPT KEY
030300000000x2  ?     when @@AID =  C@F05 ;
030400000000    ?        EXSR $F05 ;                                   //?F5 = REFRESH
030500000000x2  ?     when @@AID =  C@F06 and *IN82 ;
030600000000    ?        EXSR $F06 ;                                   //?F6 = CREATE
030700000000x2  ?     when @@AID =  C@F06 and not *IN82 ;
030800000000    ?        EXSR $F00 ;                                   //?F0 = NOT DEFINED
030900000000x2  ?     when @@AID =  C@F10 ;
031000000000    ?        EXSR $F00 ;                                   //?F10 = SEQUENCE - not defined
031100000000x2  ?     when @@AID =  C@F11 ;
031200000000    ?        EXSR $F00 ;                                   //?F11 = SELECTION - not defined
031300000000x2  ?     when @@AID =  C@F12 ;
031400000000    ?        EXSR $F12 ;                                   //?F12 = CANCEL
031500000000x2  ?     when @@AID =  C@F16 and *IN82 ;
031600000000    ?        EXSR $F16 ;                                   //?F16 = Product Cost Mainntenance
031700000000x2  ?     when @@AID =  C@F17 and *IN82 ;
031800000000    ?        EXSR $F17 ;                                   //?F17 = Labout Maintenance
031900000000x2  ?     when @@AID =  C@F18 and *IN82 ;
032000000000    ?        EXSR $F18 ;                                   //?F18 = Overhead Maintenance
032100000000x2  ?     when @@AID =  C@FUP ;
032200000000    ?        EXSR $PAGEUP;                                 //?BACK FOR MORE
032300000000x2  ?     when @@AID =  C@FDN ;
032400000000    ?        EXSR $PAGEDN;                                 //?NEXT FOR MORE
032500000000x2  ?     when @@AID <> C@FENT;
032600000000    ?        EXSR $F00 ;                                   //?F0 = NOT DEFINED
032700000000x2  ?     when *IN60 = *ON   ;                             //?Reposition
032800000000    ?        EXSR $ENTRY;                                  //?REPOSITION LIST
032900000000e2  ?     endsl ;
033000000000e1  ?  enddo ;
033100000000    ?
033200000000    ?
033300000000    ?  // * -------------------------------------------------------------------------------------- *
033400000000    ?  BEGSR             *INZSR    ;                       //?First Time Intialization Subroutine. *
033500000000    ?  // * -------------------------------------------------------------------------------------- *
033600000000    ?
033700000000    ?    @@SFLE = C$MSGF ;                                 //?Message File
033800000000    ?
033900000000b1  ?    select ;                                          //?ANALYSE PARMS:
034000000000x1  ?    when @#PRM = 0 ;                                  //?NO PARM(s)
034100000000    ?       CLEAR C1$KEY;                                  //?"ENTER" @ START OF FILE
034200000000    ?       *IN82 = *ON ;                                  //?Update allowed
034300000000    ?
034400000000x1  ?    when @#PRM = 1 ;                                  //?STANDARD PARM (Key)
034500000000    ?       C1$KEY = P$KEY ;                               //?"ENTER" @ PARM supplied
034501170321    ?       CLEAR   C1KEY4 ;                               //?Component
034600000000    ?       *IN82 = *ON ;                                  //?Always with parm for update from BOMH
034700000000    ?       EXSR $INZSR ;                                  //?Caller dependent set-up
034800000000    ?
034900000000x1  ?    other ;
035000000000    ?       EXSR  $@SNDM ;                                 //?BAD PARM ESCAPE
035100000000e1  ?    endsl ;
035200000000    ?
035300000000    ?    C1KEY1 = CONUMB ;                                 //?Company Number
035400000000    ?    BDCOMP = CONUMB ;                                 //?Company Number
035500000000    ?    PCOMP  = CONUMB ;                                 //?Company Number
035600000000    ?    LACOMP = CONUMB ;                                 //?Company Number
035700000000    ?    OTCOMP = CONUMB ;                                 //?Company Number
035800000000    ?
035900000000    ?    @@ODOB = @@PGM  ;                                 //?GET MY
036000000000    ?    EXSR    $@RTVD  ;                                 //? DESCRIPTION
036100000000    ?    P$STRG = @@OTXT ;
036200000000    ?    CenterString (%LEN(@@PGMN) : P$STRG) ;            //? Centre it
036300000000    ?    @@PGMN = P$STRG ;                                 //?
036400000000    ?
036500000000    ?    OPEN   COMAST ;                                   //?Company Profile Record
036600000000    ?    CHAIN(e) CONUMB  COMAST ;                         //?GET COMPANY NAME
036700000000    ?    P$STRG = CONAME ;
036800000000    ?    CenterString (%LEN(@@COHD) : P$STRG) ;            //? Centre it
036900000000    ?    @@COHD = P$STRG ;                                 //?
037000000000    ?    CLOSE  COMAST ;                                   //?Company Profile Record
037100000000    ?
037200000000    ?    OPEN   CSBOMD# ;                                  //?The Display:
037300000000    ?    CALLP(e) RtvSflPage ('CSBOMD#': #SFLPG) ;         //? get its subfile page size
037400000000    ?
037500000000b1  ?    if @#COLS = 80 ;                                  //? 80 COLUMN SCREEN
037600000000    ?       WL01 = 3 ;                                     //?    WINDOW      22
037700000000    ?       WC01 = 14 ;                                    //?    LOCATION    76
037800000000x1  ?    else ;
037900000000    ?       *IN87 = *ON ;                                  //?132 Column Mode
038000170427    ?       WL01 = 6 ;                                     //?                25
038100170427    ?       WC01 = 66;                                     //?               128
038200000000e1  ?    endif ;
038300000000    ?
038400000000    ?    *IN96 = *ON ;                                     //?Don't overlay
038500000000    ?    EXSR  $F10  ;                                     //?F10 = TOGGLE
038600000000    ?
038700000000b1  ?    if @#RECN = *ZERO ;                               //?EMPTY FILE:
038800000000    ?       EXSR   $F06 ;                                  //?F6 = CREATE (AutoAdd)
038900000000e1  ?    endif ;
039000000000    ?
039100000000    ?  ENDSR ;
039200000000    ?
039300000000    ?
039400000000    ?  // * -------------------------------------------------------------------------------------- *
039500000000    ?  BEGSR             $INZSR    ;                       //?Caller Dependent Invokation          *
039600000000    ?  // * -------------------------------------------------------------------------------------- *
039700000000    ?
039800000000    ?    GetStack(TheStack) ;                              //?determine functions specific to caller
039900000000    ?
040000000000b1  ?    select ;
040100000000x1  ?    when %LOOKUP('CSSCHD@   ': Stack) > 0 ;           //?from Schedule Maker: NO UPDATE NO COST
040200000000    ?       C1KEY4 = *LOVAL ;                              //?Component
040300000000    ?       *IN81  = *ON  ;                                //?Selection allowed
040400000000    ?       *IN82  = *OFF ;                                //?Update allowed
040500000000    ?       BOMmaint = *OFF ;                              //?Show Cost
040600000000x1  ?    other ;
040700000000    ?       BOMmaint = *ON  ;                              //?Show Cost
040800000000e1  ?    endsl ;
040900000000    ?
041000000000    ?  ENDSR ;
041100000000    ?
041200000000    ?
041300000000    ?  // * -------------------------------------------------------------------------------------- *
041400000000    ?  BEGSR             $CLEAR    ;                       //?Reset I/O Indicators & Errors        *
041500000000    ?  // * -------------------------------------------------------------------------------------- *
041600000000    ?
041700000000    ?    in2930 = '00'   ;                                 //?ERRORS
041800000000    ?    ##ERR = C$ZERR  ;                                 //?Field Errors
041900000000    ?    *IN49 = *OFF    ;                                 //?SflNxtChg
042000000000    ?    *IN84 = *OFF    ;                                 //?Reset Window
042100000000    ?    in9094 = '00000';                                 //?DISPLAY FUNCS 88 89
042200000000    ?    in9699 = '0000' ;                                 //?OVERLAY OK
042300000000    ?    EXSR   $@RMVM ;                                   //?MESSAGE QUEUE
042400000000    ?    EXSR   $CRSET ;                                   //?CURSOR RESET
042500000000    ?  ENDSR ;
042600000000    ?
042700000000    ?
042800000000    ?  // * -------------------------------------------------------------------------------------- *
042900000000    ?  BEGSR             $CLOSE    ;                       //?CLOSE FILEs                          *
043000000000    ?  // * -------------------------------------------------------------------------------------- *
043100000000    ?
043200000000b1  ?    select ;                                          //?Sequence
043300000000x1  ?    when *IN76 ;                                      //?Work Centre sequence
043400000000    ?       CLOSE  CSBOMD ;                                //?DONE WITH IT
043500000000x1  ?    when *IN77 ;                                      //?Product sequence
043600000000e1  ?    endsl ;
043700000000    ?
043800000000b1  ?    if QRYfile <> *BLANK ;
043900000000    ?       Command = 'DLTOVR ' + QRYfile ;
044000000000    ?       RUN (Command : CmdLen) ;                       //?Delete Override
044100000000e1  ?    endif ;
044200000000    ?
044300000000b1  ?    if QRYopen ;                                      //?Currently opened Query
044400000000    ?       Command = 'CLOF ' + QRYfile ;
044500000000    ?       RUN (Command : CmdLen) ;                       //?Close Query File
044600000000    ?       QRYopen = *OFF ;                               //? and indicate nothing open.
044700000000e1  ?    endif ;
044800000000    ?
044900000000    ?    CLOSE CSBOMH ;                                    //?BOM Header Record
045000000000    ?    CLOSE CSLABR ;                                    //?Labour Record
045100000000    ?    CLOSE CSOVHT ;                                    //?Overhead/TP Record
045200000000    ?    CLOSE OPPROD ;                                    //?Product Master Record
045300000000    ?    FileOpen = *OFF ;                                 //?nothing OPEN
045400000000    ?  ENDSR ;
045500000000    ?
045600000000    ?
045700000000    ?  // * -------------------------------------------------------------------------------------- *
045800000000    ?  BEGSR             $CRSET    ;                       //?CURSOR RESET                         *
045900000000    ?  // * -------------------------------------------------------------------------------------- *
046000000000    ?
046100000000    ?    CSRROW = *ZERO ;                                  //?NO SPECIFIC
046200000000    ?    CSRCOL = *ZERO ;                                  //?CURSOR LOCUS
046300000000    ?  ENDSR ;
046400000000    ?
046500000000    ?
046600000000    ?  // * -------------------------------------------------------------------------------------- *
046700000000    ?  BEGSR             $CSET     ;                       //?CONTROL SETTING                      *
046800000000    ?  // * -------------------------------------------------------------------------------------- *
046900000000    ?
047000000000    ?    @@SMID = 'CPF9898' ;                              //?FOR IMPROMPTU
047100000000    ?    *IN91 = *ON ;                                     //?DspCtl
047200000000    ?
047300150624    ?    PgUp = not GenError ;                             //?Page Up OK
047400150624    ?    PgDn = not GenError and not SflEnd ;              //?Page Dn OK if not EOF
047500000000    ?
047600000000    ?    StripFnCheck() ;                                  //?STRIP CPF9999
047700000000    ?    UserTime(@YYTOD) ;                                //?GET USER TOD
047800000000    ?    LongDate(@$DATE: @YDATE) ;                        //?to LONG DATE and
047900000000    ?    $YTIME = %CHAR(%TIME(@YTIME): *JOBRUN) ;          //?user time format
048000000000    ?  ENDSR ;
048100000000    ?
048200000000    ?
048300000000    ?  // * -------------------------------------------------------------------------------------- *
048400000000    ?  BEGSR             $DEFAULT  ;                       //?Assign Default Values                *
048500000000    ?  // * -------------------------------------------------------------------------------------- *
048600000000    ?
048700000000    ?    BDTYPE = %TRIM(BDTYPE) ;                          //?Cost Type
048800000000    ?
048900000000    ?  ENDSR ;
049000000000    ?
049100000000    ?
049200000000    ?  // * -------------------------------------------------------------------------------------- *
049300000000    ?  BEGSR             $DETAIL   ;                       //?DETAIL DRILL                         *
049400000000    ?  //   Convert/Expand File data to User friendly Screen Data (V$....)                         *
049500000000    ?  // * -------------------------------------------------------------------------------------- *
049600000000    ?
049700000000    ?    CHAIN(e) (BDCOMP: BDWRKC: BDPROD) CSBOMH ;        //?get header info
049800000000b1  ?    if not BOMmaint ;
049900000000    ?       BHQTY = BHQTY * L@XFAC + .00005 ;              //?Run Quantity
050000000000    ?       BDQTY = BDQTY * L@XFAC + .00005 ;              //?Required Quantity
050100000000e1  ?    endif ;
050101170804    ?
050102170804    ?    CHAIN(eN) (BDCOMP: BDWRKC: BDPROD) OPPROD ;       //?Product Master Record
050103170804    ?    BHDESC = PEDES1 ;                                 //?Parent Description
050200000000    ?
050300000000    ?    Component = BDITEM ;                              //?map ==> Mfg / Prod : Labour : OverHead
050301170427    ?    V$ITEM = BDITEM ;                                 //?Component
050400000000    ?    *IN58 = *OFF ;                                    //?allow new Cost entry
050500000000    ?
050600000000b1  ?    select ;
050700000000x1  ?    when BDTYPE = 'M ' ;                              //?Cost Type
050800000000b2  ?       if %CHECK('0123456789': BDITEM) = 0 ;          //?all Numeric:
050900000000    ?          CHAIN(eN) (PCOMP: PMANID: PNUMB) OPPROD ;   //?Product Master Record
051000000000b3  ?          if %FOUND ;
051001170427    ?             V$ITEM = %EDITC(PMANID: '3') + '-' +     //?Component
051002170427    ?                      %EDITC(PNUMB : 'X')     ;
051003170427    ?             V$ITEM = %TRIML(V$ITEM) ;                //?Component
051100000000    ?             V$DESC = PEDES1 ;                        //?English Description1
051200000000    ?             V$PCST = SUPCST ;                        //?Supply Cost
051300000000    ?             V$COST = PPCOST ;                        //?Supply Cost proposed
051400000000    ?             V$UNIT = PCUNIT ;                        //?Unit of Measure
051500150624    ?             *IN58 = PWIP = 'R' and *IN82 ;           //?Product Group FG/WIP/RM => allow entry
051600000000e3  ?          endif ;
051700000000e2  ?       endif ;
051800000000 ?  ?
051900000000x1  ?    when BDTYPE = 'L ' ;                              //?Cost Type
052000000000    ?       CHAIN(eN) (LACOMP: LALABC) CSLABR ;            //?Labour Record
052100000000b2  ?       if %FOUND ;
052200000000    ?          V$DESC = LADESC ;                           //?English Description1
052300000000    ?          V$PCST = LARATE ;                           //?Supply Cost
052400000000    ?          V$COST = *ZERO  ;                           //?Supply Cost proposed
052500000000    ?          V$UNIT = LAUNIT ;                           //?Unit of Measure
052600000000e2  ?       endif ;
052700000000 ?  ?
052800000000x1  ?    when BDTYPE = 'O ' ;                              //?Cost Type
052900000000    ?       CHAIN(eN) (OTCOMP: OTOVHT) CSOVHT ;            //?Overhead/TP Record
053000000000b2  ?       if %FOUND ;
053100000000    ?          V$DESC = OTDESC ;                           //?English Description1
053200000000    ?          V$PCST = OTRATE ;                           //?Supply Cost
053300000000    ?          V$COST = *ZERO  ;                           //?Supply Cost proposed
053400000000    ?          V$UNIT = *BLANK ;                           //?Unit of Measure
053500000000e2  ?       endif ;
053600000000 ?  ?
053700000000x1  ?    when BDTYPE = 'TP' ;                              //?Cost Type
053800000000    ?       CHAIN(eN) (OTCOMP: OTOVHT) CSOVHT ;            //?Overhead/TP Record
053900000000b2  ?       if %FOUND ;
054000000000    ?          V$DESC = OTDESC ;                           //?English Description1
054100000000    ?          V$PCST = OTRATE ;                           //?Supply Cost
054200000000    ?          V$COST = *ZERO  ;                           //?Supply Cost proposed
054300000000    ?          V$UNIT = *BLANK ;                           //?Unit of Measure
054400000000e2  ?       endif ;
054500000000e1  ?    endsl ;
054600000000    ?
054700000000    ?
054800000000b1  ?    select ;                                          //?PANELs
054900000000x1  ?    when ###WD# = 0 ;                                 //?---------------- SFL
055000000000    ?       BHCOST = BHMATC + BHLABC ;                     //?Material Cost
055100000000    ?       BHCOSP = BHMATP + BHLABP ;                     //?Material Cost proposed
055200150624    ?       *IN57 = BHCOSP <> BHCOST ;                     //?flag: new Cost CTL
055300150624    ?       *IN56 = BDCOSP <> BDCOST ;                     //?flag: new Cost SFL
055400000000    ?
055500000000x1  ?    when ###WD# = 1 ;                                 //?----------------
055600000000b2  ?       if %TLOOKUP (BDTYPE: TABC: TABCT) ;
055700000000    ?          V$TDES = TABCT ;                            //?
055800000000e2  ?       endif ;
055900000000b2  ?       if BDTYPE = 'M ' ;                             //?Cost Type
056000000000    ?          V$TDES = %TRIMR(V$TDES) + ' (' + PWIP +')' ;//?
056100000000e2  ?       endif ;
056200000000    ?
056300000000    ?       in5155 = '00000';                              //?Reset NEW proposed Costs display:
056400150624    ?       *IN51 = BDCOSP <> BDCOST ;                     //?Cost proposed new OR Material Update
056500150624    ?       *IN52 = V$COST <> V$PCST and V$COST <> *ZERO ; //?Supply Cost proposed
056600000000    ?       *IN50 = %BITOR(*IN(51): *IN(52)) ;             //?show "proposed" heading
056700000000    ?
056800000000x1  ?    when ###WD# = 2 ;                                 //?----------------
056900000000e1  ?    endsl ;
057000000000    ?
057100000000    ?  ENDSR ;
057200000000    ?
057300000000    ?
057400000000    ?  // * -------------------------------------------------------------------------------------- *
057500000000    ?  BEGSR             $DETAIL2FL;                       //?DETAIL DATA TO FILE                  *
057600000000    ?  // * -------------------------------------------------------------------------------------- *
057700000000    ?
057800000000    ?    EXSR  $DEFAULT ;                                  //?Assign Default Values
057900000000    ?
058000000000b1  ?    select ;                                          //?PANELs
058100000000x1  ?    when ###WD# = 1 ;                                 //?----------------
058101170321b2  ?       if BDTYPE <> 'M ' ;                            //?Not material, shift chars to left
058102170321    ?          BDITEM = %SUBST(%TRIML(BDITEM): 1: %LEN(LALABC));
058103170321e2  ?       endif ;
058104170321    ?
058200000000b2  ?       select ;
058300000000x2  ?       when BDTYPE = 'M ' ;                           //?Cost Type
058400130910    ?          BDITEM = %XLATE(' ': '0': BDITEM) ;         //?Blanks to zeros
058500000000    ?          CHAIN(e) (PCOMP: PMANID: PNUMB) OPPROD ;    //?Product Master Record
058600000000    ?          BDUNIT = PCUNIT ;                           //?Unit of Measure
058700000000b3  ?          if *IN62 ;                                  //?Pp. Std. Cost MDT
058800000000    ?             PPCOST = V$COST ;                        //?Supply Cost proposed
058900000000e3  ?          endif ;
059000000000    ?          UPDATE OPPRODR ;                            //?Product Master Record
059100000000    ?
059200000000x2  ?       when BDTYPE = 'L ' ;                           //?Cost Type
059300000000    ?          CHAIN(eN) (LACOMP: LALABC) CSLABR ;         //?Labour Record
059400000000    ?          BDUNIT = LAUNIT ;                           //?Unit of Measure
059500000000e2  ?       endsl ;
059600000000    ?
059700000000x1  ?    when ###WD# = 2 ;                                 //?----------------
059800000000e1  ?    endsl ;
059900000000    ?
060000000000    ?  ENDSR ;
060100000000    ?
060200000000    ?
060300000000    ?  // * -------------------------------------------------------------------------------------- *
060400000000    ?  BEGSR             $ENTRY    ;                       //?REPOSITION                           *
060500000000    ?  //   Position & Load Page according to Entry Field                                          *
060600000000    ?  // * -------------------------------------------------------------------------------------- *
060700000000    ?
060800000000b1  ?    if *IN60 ;                                        //?Reposition
060900000000b2  ?       select;
061000000000x2  ?       when *IN76 ;                                   //?Work Centre sequence
061100000000x2  ?       when *IN77 ;                                   //?Product sequence
061200000000e2  ?       endsl ;
061300000000e1  ?    endif ;
061400000000    ?
061500000000    ?    F$KEY = C1$KEY ;                                  //?SET FILE KEYs
061600000000    ?    F$KEYalt = C1$KEYalt ;
061700000000    ?
061800000000    ?    EXSR  $POSDBF ;                                   //?Position file
061900000000    ?    EXSR  $LOADPG ;                                   //?LOAD SFL PAGE
062000000000    ?  ENDSR ;
062100000000    ?
062200000000    ?
062300000000    ?  // * -------------------------------------------------------------------------------------- *
062400000000    ?  BEGSR             $F00      ;                       //?F0 = NOT DEFINED                     *
062500000000    ?  // * -------------------------------------------------------------------------------------- *
062600000000    ?
062700000000    ?    GenError = *ON ;                                  //?Error on Display
062800000000    ?    @@SMID = 'CPF9898' ;                              //?for IMPROMPTU
062900000000    ?    @@SDTA = #MSG02 ;
063000000000    ?    EXSR     $@SNDP ;
063100000000    ?  ENDSR ;
063200000000    ?
063300000000    ?
063400000000    ?  // * -------------------------------------------------------------------------------------- *
063500000000    ?  BEGSR             $F02      ;                       //?F2 = ATTRIBUTE HELP                  *
063600000000    ?  // * -------------------------------------------------------------------------------------- *
063700000000    ?
063800000000    ?    WRITE   ###A1 ;                                   //?Attribute Help
063900000000    ?    READ(e) CSBOMD#;                                  //?0303 WAIT RESPONSE
064000000000    ?
064100150624    ?    *IN90 = SFL1 > *ZERO ;                            //?HAVE SUBFILE: DspSfl
064200000000    ?  ENDSR ;
064300000000    ?
064400000000    ?
064500000000    ?  // * -------------------------------------------------------------------------------------- *
064600000000    ?  BEGSR             $F03      ;                       //?F3 = EXIT                            *
064700000000    ?  // * -------------------------------------------------------------------------------------- *
064800000000    ?
064900000000    ?    CALLP(e) CSCOST () ;                              //?Unload
065000000000    ?    EXSR  $CLOSE ;                                    //?CLOSE FILEs
065100000000    ?    CLOSE CSBOMD# ;                                   //?enter/update window
065200000000    ?    EXSR  $@RMVM ;                                    //?MESSAGE QUEUE
065300000000    ?    *INLR = *ON  ;
065400000000    ?    RETURN;
065500000000    ?  ENDSR;
065600000000    ?
065700000000    ?
065800000000    ?  // * -------------------------------------------------------------------------------------- *
065900000000    ?  BEGSR             $F04      ;                       //?F4 = PROMPT KEY                      *
066000000000    ?  //   Check for Cursor location by fields within record formats.                             *
066100000000    ?  //   Issue message and set cursor to current position. i.e. leave it where it is.           *
066200000000    ?  // * -------------------------------------------------------------------------------------- *
066300000000    ?
066400000000b1  ?    select ;                                          //?CURSOR in Format
066500000000x1  ?    when CSRREC = '###WD1' or                         //? W I N D O W's
066600000000    ?         CSRREC = '###WD2' ;                          //?
066700000000    ?       @#ROW = @@ROWW ;                               //?PLACE CURSOR
066800000000    ?       @#COL = @@COLW ;
066900000000x1  ?    other ;
067000000000    ?       @#ROW = @@ROW ;                                //?PLACE CURSOR
067100000000    ?       @#COL = @@COL ;
067200000000e1  ?    endsl ;
067300000000    ?
067400000000    ?    CSRROW = ##ROW ;                                  //?AT CURRENT
067500000000    ?    CSRCOL = ##COL ;                                  //?LOCATION
067600000000    ?
067700000000b1  ?    select ;                                          //?RECORD FORMAT:
067800000000x1  ?    when CSRREC = '###WD1' or                         //? W I N D O W's
067900000000    ?         CSRREC = '###WD2' ;                          //?
068000000000    ?       EXSR $F04W1 ;                                  //?WINDOW FIELDS
068100000000x1  ?    other ;                                           //?BAD FORMAT
068200000000    ?       GenError = *ON ;                               //?Error on Display
068300000000    ?       @@SMID = 'USR2211' ;                           //?WITH MESSAGE
068400000000    ?       EXSR $@SNDP ;
068500000000e1  ?    endsl ;
068600000000    ?
068700000000    ?  ENDSR ;
068800000000    ?
068900000000    ?
069000000000    ?  // * -------------------------------------------------------------------------------------- *
069100000000    ?  BEGSR             $F04S1    ;                       //?SFL FIELDS                           *
069200000000    ?  // * -------------------------------------------------------------------------------------- *
069300000000    ?
069400000000    ?  ENDSR ;
069500000000    ?
069600000000    ?
069700000000    ?  // * -------------------------------------------------------------------------------------- *
069800000000    ?  BEGSR             $F04W1    ;                       //?WINDOW FIELDS                        *
069900000000    ?  // * -------------------------------------------------------------------------------------- *
070000000000    ?
070100000000b1  ?    select ;                                          //?FIELDS:
070200000000x1  ?    when CSRFLD = 'BDWRKC' or                         //?
070300000000    ?         CSRFLD = 'BDPROD' ;                          //?
070400000000    ?       PMANID = BDWRKC ;                              //?Manufacture ID
070500000000    ?       PNUMB  = BDPROD ;                              //?Product Code
070600000000    ?       CALLP(e) SELITEM (D$PRD) ;
070700000000    ?       BDWRKC = PMANID ;                              //?Work Center
070800000000    ?       BDPROD = PNUMB  ;                              //?Product Code
070900000000    ?
071000000000x1  ?    when CSRFLD = 'BDITEM' and BDTYPE = 'L ' ;        //?LABOUR
071100000000    ?       Component = BDITEM ;
071200000000    ?       CALLP(e) SELLBR (D$PRD) ;
071300000000    ?       BDITEM = Component ;                           //?Component
071301170321    ?       BDITEM = %SUBST(%TRIML(BDITEM): 1: %LEN(LALABC));
071400000000    ?
071500000000x1  ?    when CSRFLD = 'BDITEM' and BDTYPE = 'M ' ;        //?
071600130910    ?       BDITEM = %XLATE(' ': '0': BDITEM) ;            //?Blanks to zeros
071700130910b2  ?       if %CHECK('0123456789': BDITEM) > 0 ;          //?Bad Stuff in field?
071800130910    ?          BDITEM = *ZEROS ;                           //? yes, assume zero
071900130910e2  ?       endif ;
072000000000    ?       Component = BDITEM ;
072100000000    ?       CALLP(e) SELITEM (D$PRD) ;
072200000000    ?       BDITEM = Component ;                           //?Component
072300000000    ?
072400000000x1  ?    when CSRFLD = 'BDITEM' and BDTYPE = 'O ' ;        //?
072500000000    ?       Component = BDITEM ;
072600000000    ?       CALLP(e) SELOVR (D$PRD) ;
072700000000    ?       BDITEM = Component ;                           //?Component
072701170321    ?       BDITEM = %SUBST(%TRIML(BDITEM): 1: %LEN(OTOVHT));
072800000000    ?
072900000000x1  ?    when CSRFLD = 'BDITEM' and BDTYPE = 'TP' ;        //?
073000000000    ?       Component = BDITEM ;
073100000000    ?       CALLP(e) SELOVR (D$PRD) ;
073200000000    ?       BDITEM = Component ;                           //?Component
073201170321    ?       BDITEM = %SUBST(%TRIML(BDITEM): 1: %LEN(OTOVHT));
073300000000    ?
073400000000x1  ?    other ;                                           //?BAD LOCATION
073500000000    ?       GenError = *ON ;                               //?Error on Display
073600000000    ?       @@SMID = 'USR2211' ;
073700000000    ?       EXSR   $@SNDP ;
073800000000e1  ?    endsl ;
073900150624    ?
074000150624    ?    *IN84 = not GenError ;                            //?Reset Window
074100000000    ?
074200000000    ?  ENDSR ;
074300000000    ?
074400000000    ?
074500000000    ?  // * -------------------------------------------------------------------------------------- *
074600000000    ?  BEGSR             $F05      ;                       //?F5 = REFRESH                         *
074700000000    ?  // * -------------------------------------------------------------------------------------- *
074800000000    ?
074900000000b1  ?    if GenError ;                                     //?Error with Cancel
075000000000    ?       EXSR   $@RMVM ;                                //?MESSAGE QUEUE
075100000000e1  ?    endif ;
075200000000    ?
075300000000    ?    EXSR $ENTRY ;                                     //?REPOSITION & LOAD
075400000000    ?  ENDSR ;
075500000000    ?
075600000000    ?
075700000000    ?  // * -------------------------------------------------------------------------------------- *
075800000000    ?  BEGSR             $F06      ;                       //?F6 = CREATE                          *
075900000000    ?  // * -------------------------------------------------------------------------------------- *
076000000000    ?
076100000000b1  ?    dou not *IN06 ;                                   //?Create
076200000000    ?       *IN06 = *OFF ;                                 //?Create
076300000000    ?       H$KEY = F$KEY ;                                //?Save current Keys
076400000000    ?       H$KEYalt = F$KEYalt ;
076500000000    ?       CLEAR   CSBOMDR ;                              //?WIPE FLE FIELDS
076600000000    ?       F$KEY = H$KEY ;                                //?Restore last
076700000000    ?       F$KEYalt = H$KEYalt ;
076800000000    ?       CLEAR   H$KEY ;                                //? and clear
076900000000    ?       CLEAR   H$KEYalt ;
076901170321    ?       CLEAR   BDITEM   ;                             //?don't prefill with last, confuses USER
077000000000    ?
077100000000    ?       *IN86 = *ON ;                                  //?ADD MODE IN
077200000000    ?       EXSR  $OPT2 ;                                  //? EDIT WINDOW
077300000000    ?       *IN86 = *OFF;                                  //?Create Mode
077400000000e1  ?    enddo ;
077500000000    ?
077600000000    ?    EXSR  $ENTRY ;                                    //?REPOSITION & LOAD
077700000000    ?  ENDSR ;
077800000000    ?
077900000000    ?
078000000000    ?  // * -------------------------------------------------------------------------------------- *
078100000000    ?  BEGSR             $F10      ;                       //?F10 = TOGGLE Sequences               *
078200000000    ?  //   This routine is a STUB (just closes & opens) when there                                *
078300000000    ?  //   is no actual F10=Toggle-Alt-Seq. function implemented.                                 *
078400000000    ?  // * -------------------------------------------------------------------------------------- *
078500000000    ?
078600000000    ?    EXSR $CLOSE ;                                     //?CLOSE FILEs
078700000000    ?
078800000000b1  ?    select ;
078900000000x1  ?    when *IN76 ;                                      //?76 => 77
079000000000    ?       in7678 = '010' ;
079100000000    ?       QRYfile = 'CSBOMD' ;                           //?This is the new file (Trail blank)
079200000000x1  ?    when *IN77 ;                                      //?77 => 76
079300000000    ?       in7678 = '100' ;
079400000000x1  ?    when *IN78 ;                                      //?
079500000000x1  ?    other ;                                           //?OPEN DEFAULT:
079600000000    ?       in7678 = '100' ;                               //?Condition by 81/82 if needed
079700000000    ?       QRYfile = 'CSBOMD' ;                           //?This is the file (Trail blank)
079800000000e1  ?    endsl ;
079900000000    ?
080000000000b1  ?    if *IN70 ;                                        //?When in alternate/subselect mode
080100000000    ?       *IN70 = *OFF ;                                 //?Back out Toggle to previous setting
080200000000    ?       EXSR $F11 ;
080300000000x1  ?    else ;                                            //?Or, without the above, reset to *ALL
080400000000    ?       EXSR $OPEN ;                                   //?FILE OPEN/LOAD
080500000000    ?       EXSR $@RMVM;                                   //?Clear Message Queue
080600000000    ?       EXSR $ENTRY;                                   //?REPOSITION
080700000000e1  ?    endif ;
080800000000    ?  ENDSR ;
080900000000    ?
081000000000    ?
081100000000    ?  // * -------------------------------------------------------------------------------------- *
081200000000    ?  BEGSR             $F11      ;                       //?F11 = TOGGLE Selection               *
081300000000    ?  //   This routine is a STUB (closes & opens & selects *ALL) when                            *
081400000000    ?  //   there is no actual F11=Toggle-Alt-Sel. function implemented.                           *
081500000000    ?  // * -------------------------------------------------------------------------------------- *
081600000000    ?
081700000000b1  ?    if FileOpen ;                                     //?Files Open ?
081800000000    ?       EXSR $CLOSE ;                                  //?CLOSE FILEs
081900000000e1  ?    endif ;
082000000000    ?
082100000000b1  ?    select ;
082200000000x1  ?    when *IN76 or *IN77 ;                             //?This sequence(s) has filter:
082300000000b2  ?       if not *IN70 ;                                 //?Toggle, Default *OFF = *ALL
082400000000    ?          *IN70 = *ON ;                               //?
082500000000    ?          Command = 'OPNQRYF ' + QRYfile + ' *ALL QRYSLT(''' +
082600000000    ?          'bdedat > ' + %CHAR(%DATE:*ISO0) +          //?selection is Date > Today
082700000000    ?          ''') KEYFLD(*FILE) SEQONLY(*NO)' ;
082800000000x2  ?       else ;
082900000000    ?          *IN70 = *OFF ;                              //?
083000000000    ?          Command = 'OPNQRYF ' + QRYfile + ' *ALL QRYSLT(''' +
083100000000    ?          '*ALL' +                                    //?selection is all
083200000000    ?          ''') KEYFLD(*FILE) SEQONLY(*NO)' ;
083300000000e2  ?       endif ;
083400000000x1  ?    other ;                                           //?code for different Sequence/Filter
083500000000e1  ?    endsl ;
083600000000    ?
083700000000b1  ?    if Command > ' ' ;
083800000000    ?       RUN (Command : CmdLen) ;                       //?Open Query
083900000000    ?       QRYopen = *ON ;                                //?Indicate
084000000000e1  ?    endif ;
084100000000    ?
084200000000    ?    EXSR $OPEN ;                                      //?FILE OPEN/LOAD
084300000000    ?    EXSR $@RMVM;                                      //?Clear Message Queue
084400000000    ?
084500000000    ?    CLEAR C1KEY2 ;                                    //?At Beginning when Subset of File(s)
084600000000    ?    CLEAR C1KEY3 ;                                    //?Key Field 3
084700000000    ?    CLEAR C1KEY4 ;                                    //?The Data Field
084800000000    ?    EXSR  $ENTRY;                                     //?REPOSITION
084900000000    ?  ENDSR ;
085000000000    ?
085100000000    ?
085200000000    ?  // * -------------------------------------------------------------------------------------- *
085300000000    ?  BEGSR             $F12      ;                       //?F12 = CANCEL                         *
085400000000    ?  // * -------------------------------------------------------------------------------------- *
085500000000    ?
085600111103b1  ?    if j = 0 ;                                        //?Stack empty:
085700111103    ?       EXSR $F03 ;                                    //?F3 = EXIT
085800111103e1  ?    endif ;
085900111103    ?
086000111103    ?    C1$KEY = Opt8Stk(j).C1KEY ;                       //?set previous key
086100111103    ?    C1$KEYalt = Opt8Stk(j).C1KEYalt ;
086200111103    ?    L@XFAC = Opt8Stk(j).Factor ;
086300111103    ?    EXSR  $ENTRY ;                                    //?load page
086400111103    ?
086500111103    ?    CSR1   = Opt8Stk(j).Cursor ;                      //?place cursor where "8" was on previous
086600111103    ?    j = j - 1 ;                                       //?pop Stack
086700111103    ?  ENDSR ;
086800111103    ?
086900111103    ?
087000111103    ?  // * -------------------------------------------------------------------------------------- *
087100000000    ?  BEGSR             $F16      ;                       //?F16 = Product Maint R/M COST         *
087200000000    ?  // * -------------------------------------------------------------------------------------- *
087300000000    ?
087400000000    ?    CALLP(e) ProdMaint ();
087401160405    ?    EXSR $ENTRY ;                                     //?REPOSITION & LOAD
087500000000    ?  ENDSR ;
087600000000    ?
087700000000    ?
087800000000    ?  // * -------------------------------------------------------------------------------------- *
087900000000    ?  BEGSR             $F17      ;                       //?F17 = Labour Maint                   *
088000000000    ?  // * -------------------------------------------------------------------------------------- *
088100000000    ?
088200000000    ?    CALLP(e) SELLBR () ;
088201160405    ?    EXSR $ENTRY ;                                     //?REPOSITION & LOAD
088300000000    ?  ENDSR ;
088400000000    ?
088500000000    ?
088600000000    ?  // * -------------------------------------------------------------------------------------- *
088700000000    ?  BEGSR             $F18      ;                       //?F18 = Overhead Maint                 *
088800000000    ?  // * -------------------------------------------------------------------------------------- *
088900000000    ?
089000000000    ?    CALLP(e) SELOVR () ;
089001160405    ?    EXSR $ENTRY ;                                     //?REPOSITION & LOAD
089100000000    ?  ENDSR ;
089200000000    ?
089300000000    ?
089400000000    ?  // * -------------------------------------------------------------------------------------- *
089500000000    ?  BEGSR             $LOADPG   ;                       //?LOAD Page from where File positioned *
089600000000    ?  // * -------------------------------------------------------------------------------------- *
089700000000    ?
089800000000    ?    in9094 = '00001' ;                                //?SFLCLR
089900000000    ?    WRITE     ###C1  ;                                //?Screen Header & SFL Control
090000000000    ?    in9094 = '00000' ;                                //?Reset Screen I/O
090100000000    ?    CLEAR  V1SEL ;                                    //?Option
090200000000    ?    ###WD# = *ZERO ;
090300000000    ?    RRN1 = *ZERO ;                                    //?SFL Records
090400000000    ?    CSR1 = 1 ;                                        //?Cursor at first
090500000000    ?
090600000000b1  ?    for i = 1 to #SFLPG ;                             //?one Page
090700000000b2  ?       select ;
090800000000x2  ?       when *IN76 ;                                   //?Work Centre sequence
090900000000    ?          READE(eN) LVLKEY CSBOMD ;                   //?PARTIAL KEY
091000000000x2  ?       when *IN77 ;                                   //?Product sequence
091100000000e2  ?       endsl ;
091200000000    ?
091300000000    ?       ##ERR = C$ZERR ;                               //?Reset Errors
091400000000    ?
091500000000b2  ?       if not %EOF ;
091600000000    ?          H$KEY = F$KEY ;                             //?Hide org. Key
091700000000    ?          H$KEYalt = F$KEYalt ;                       //?     alt. Keys
091800000000    ?          EXSR  $DETAIL ;                             //?DETAIL DRILL
091900000000    ?          RRN1 = RRN1 + 1 ;                           //?--> CURRENT LNE
092000000000    ?          WRITE  ###S1 ;                              //?=> SFL
092100000000e2  ?       endif ;
092200000000e1  ?    endfor ;
092300000000    ?
092400000000b1  ?    select ;
092500000000x1  ?    when *IN76 ;                                      //?Work Centre sequence
092600000000    ?       READE(eN) LVLKEY CSBOMD ;                      //?Check if any MORE...+
092700000000x1  ?    when *IN77 ;                                      //?Data    sequence
092800000000e1  ?    endsl ;
092900000000    ?
093000150624    ?    *IN95 = %EOF ;                                    //?SflEnd
093100000000    ?    GenError = *OFF ;                                 //?Error on Display
093200000000    ?    SFL1  = RRN1 ;                                    //?Subfile Size
093300000000    ?
093400000000b1  ?    if SFL1 > *ZERO ;                                 //?HAVE SUBFILE:
093500000000    ?       CHAIN 1 ###S1 ;                                //?TOP 'O SCREEN
093600000000    ?       C1$KEY = H$KEY ;                               //?SFL ==> SFLCTL
093700000000    ?       C1$KEYalt = H$KEYalt ;
093800000000    ?       *IN90 = *ON ;                                  //?DspSfl
093900000000e1  ?    endif ;
094000000000    ?
094100000000    ?  ENDSR ;
094200000000    ?
094300000000    ?
094400000000    ?  // * -------------------------------------------------------------------------------------- *
094500000000    ?  BEGSR             $MODSFL   ;                       //?SFL MODIFIED?                        *
094600000000    ?  // * -------------------------------------------------------------------------------------- *
094700000000    ?
094800000000b1  ?    if SFL1 > *ZERO ;                                 //?HAVE SUBFILE &
094900000000    ?       D$AID = @@AID;                                 //?Save F-key
095000000000    ?       D$DSTS = *ZERO;                                //?no WDW Status
095100000000    ?       *IN69 = *OFF;
095200000000    ?
095300000000b2  ?       dou  *IN69 or D$DSTS = C$1331 ;                //?Until no SFL Change or Panel Time-out
095400000000    ?
095500000000    ?          READC(e) ###S1 ;                            //?Subfile List
095600150624    ?          *IN69 = %EOF or %ERROR ;
095700000000    ?
095800000000    ?          ##ERR = C$ZERR ;                            //?Reset Errors
095900000000    ?          *IN49 = *OFF ;                              //?SflNxtChg
096000000000    ?
096100000000b3  ?          if not *IN69 ;                              //?OPTION ENTERED:
096200000000b4  ?             select ;
096300000000x4  ?             when V1SEL = '1'  and  *IN81 ;           //?SELECT
096400000000    ?                EXSR $OPT1 ;
096500000000x4  ?             when V1SEL = '2'  and  *IN82 ;           //?EDIT WINDOWs
096600000000    ?                EXSR $OPT2 ;
096700150624    ?                *IN84 = *ON ;                         //?Reset Window
096800000000x4  ?             when V1SEL = '3'  and  *IN82 ;           //?COPY   RECORD
096900000000    ?                EXSR $OPT3 ;
097000150624    ?                *IN84 = *ON ;                         //?Reset Window
097100000000x4  ?             when V1SEL = '4'  and  *IN82 ;           //?DELETE RECORD
097200000000    ?                EXSR $OPT4 ;
097300000000x4  ?             when V1SEL = '5'  ;                      //?DETAIL DISPLAYs
097400000000    ?                EXSR $OPT5 ;
097500150624    ?                *IN84 = *ON ;                         //?Reset Window
097600111103x4  ?             when V1SEL = '8'  ;                      //?Sub-components
097700111103    ?                EXSR $OPT8 ;
097701170629x4  ?             when V1SEL = 'I'  ;                      //?Option: Explosion
097702170629    ?                EXSR $OPTI ;
097800000000x4  ?             when V1SEL = 'W'  ;                      //?Option: Where used
097900000000    ?                EXSR $OPTW ;
097901230524x4  ?             when V1SEL = 'E'  ;                      //?Option: Explosion
097902230524    ?                EXSR $OPTE ;
098000000000x4  ?             when V1SEL > ' '  ;                      //?OPTION ERROR
098100000000    ?                EXSR $OPTERROR;
098200000000e4  ?             endsl ;
098300000000    ?
098400000000    ?             EXSR $MODSFLUPD ;                        //?UPDATE MOD SFL
098500000000e3  ?          endif;
098600000000e2  ?       enddo ;
098700000000    ?
098800000000b2  ?       if D$DSTS = C$1331 ;                           //?WDW had TIMEOUT
098900000000    ?          @@AID  = C@FENT ;                           //? like ENTER Key
099000000000x2  ?       else ;                                         //?OKAY,
099100000000    ?          @@AID  = D$AID  ;                           //? Restore ORG F-KEY
099200000000e2  ?       endif ;
099300000000e1  ?    endif ;
099400000000    ?
099500000000    ?  ENDSR ;
099600000000    ?
099700000000    ?
099800000000    ?  // * -------------------------------------------------------------------------------------- *
099900000000    ?  BEGSR             $MODSFLUPD;                       //?MODIFIED SFL UPDATE                  *
100000000000    ?  // * -------------------------------------------------------------------------------------- *
100100000000    ?
100200000000    ?    *IN(30) = %BITOR(*IN(30) : *IN(31)) ;             //?Error on Display
100300000000    ?    *IN(49) = %BITOR(*IN(49) : *IN(30)) ;             //?SflNxtChg
100400000000    ?
100500000000b1  ?    if not OptError;                                  //?Option Error
100600000000    ?       CLEAR V1SEL ;                                  //?Option
100700000000e1  ?    endif ;
100800000000    ?
100900000000b1  ?    if not *IN33 ;                                    //?Deleted!
101000000000    ?       ###WD# = *ZERO ;
101100000000    ?       EXSR  $RTVCUR ;                                //?Get current record from file
101200000000    ?       EXSR  $DETAIL ;                                //?DETAIL DRILL
101300000000e1  ?    endif ;
101400000000    ?
101500000000    ?    UPDATE ###S1 ;                                    //?Subfile List
101600000000    ?    EXSR  $CRSET ;                                    //?CURSOR RESET
101700000000    ?    CSR1 = RRN1  ;                                    //?CURSOR @ MODSFL
101800000000    ?    *IN90 = *ON  ;                                    //?DspSfl
101900000000    ?  ENDSR ;
102000000000    ?
102100000000    ?
102200000000    ?  // * -------------------------------------------------------------------------------------- *
102300000000    ?  BEGSR             $OPEN     ;                       //?FILE OPEN/LOAD                       *
102400000000    ?  // * -------------------------------------------------------------------------------------- *
102500000000    ?
102600000000    ?    Command = 'OVRDBF ' + QRYfile + 'SHARE(*YES)';    //?This is the file to open
102700000000    ?    RUN (Command : CmdLen) ;                          //?Override file for SHARE
102800000000    ?
102900000000b1  ?    select ;                                          //?appropriate file
103000000000x1  ?    when *IN76 ;                                      //?Work Centre sequence
103100000000    ?       OPEN CSBOMD ;                                  //?OPEN TABLE
103200000000x1  ?    when *IN77 ;                                      //?Product sequence
103300000000e1  ?    endsl ;
103400000000    ?
103500000000    ?    OPEN CSBOMH ;                                     //?BOM Header Record
103600000000    ?    OPEN CSLABR ;                                     //?Labour Record
103700000000    ?    OPEN CSOVHT ;                                     //?Overhead/TP Record
103800000000    ?    OPEN OPPROD ;                                     //?Product Master Record
103900000000    ?    FileOpen = *ON ;                                  //?Files open
104000000000    ?  ENDSR ;
104100000000    ?
104200000000    ?
104300000000    ?  // * -------------------------------------------------------------------------------------- *
104400000000    ?  BEGSR             $OPTERROR ;                       //?OPTION ERROR                         *
104500000000    ?  // * -------------------------------------------------------------------------------------- *
104600000000    ?
104700000000    ?    OptError = *ON ;                                  //?Option Error
104800000000    ?    @@SMID = 'CPF9898' ;                              //?FOR IMPROMPTU
104900000000    ?    @@SDTA = #MSG01 ;
105000000000    ?    EXSR $@SNDP ;
105100000000    ?  ENDSR ;
105200000000    ?
105300000000    ?
105400000000    ?  // * -------------------------------------------------------------------------------------- *
105500000000    ?  BEGSR             $OPT1     ;                       //?SELECT                               *
105600000000    ?  // * -------------------------------------------------------------------------------------- *
105700000000    ?
105800000000    ?    P$KEY = F$KEY ;                                   //?FileKey => Parm
105900000000    ?    EXSR  $F03 ;                                      //?F3 = EXIT
106000000000    ?  ENDSR ;
106100000000    ?
106200000000    ?
106300000000    ?  // * -------------------------------------------------------------------------------------- *
106400000000    ?  BEGSR             $OPT2     ;                       //?EDIT WINDOWs                         *
106500000000    ?  // * -------------------------------------------------------------------------------------- *
106600000000    ?
106700000000b1  ?    if not *IN86 ;                                    //?not ADD
106800000000    ?       EXSR  $RTVCUR ;                                //?Get current record from file
106900000000e1  ?    endif ;
107000000000    ?
107100000000b1  ?    for ###WD# = ###WD0 to ###WDS ;                   //?ALL PANELS:
107200000000    ?       EXSR $CRSET ;                                  //?CURSOR RESET
107300000000    ?
107400000000b2  ?       dou not (GenError or *IN04) ;                  //?Until no error or Prompt
107500000000    ?          EXSR $DETAIL ;                              //?DETAIL DRILL to Screen
107600000000    ?          EXSR $SCRWDWIO ;                            //?SCREEN WDW I/O
107700000000    ?
107800000000b3  ?          if  not (*IN03 or *IN04) ;                  //?Neither EXIT or PROMPT Key:
107900000000    ?             EXSR $VALIDATE ;                         //?VALIDATE ENTRY
108000000000    ?
108100000000b4  ?             if *IN61 and not GenError ;              //?Window MDT and no Error(s)
108200000000    ?                EXSR  $UPDATE ;                       //?UPDATE THE FILE
108300000000e4  ?             endif ;
108400000000e3  ?          endif ;
108500000000    ?
108600000000b3  ?          select ;                                    //?RESPONSE:
108700000000x3  ?          when *IN03 ;                                //?EXIT
108800000000    ?             *IN03 = *OFF ;                           //?EXIT
108900000000    ?             *IN12 = *ON  ;                           //?Return
109000000000    ?             LEAVE ;                                  //?End Panel I/O
109100000000    ?
109200000000x3  ?          when *IN04 ;                                //?PROMPT
109300000000    ?             EXSR $F04 ;                              //?F4 = PROMPT KEY
109400000000    ?
109500000000x3  ?          when *IN30 ;                                //?Error on Display
109600000000    ?
109700000000x3  ?          when *IN27 ;                                //?Page Up
109800000000    ?             ###WD# = ###WD# - 2 ;
109900000000    ?
110000000000x3  ?          when *IN28 ;                                //?Page Dn
110100000000    ?             ###WD# = ###WD# + 0 ;
110200000000    ?
110300000000x3  ?          when @@AID <> C@FENT ;                      //?NOT "ENTER" ==
110400000000    ?             EXSR $F00 ;                              //?F0 =NOT DEFINED
110500000000e3  ?          endsl ;
110600000000e2  ?       enddo ;                                        //?:: END OF PANEL
110700000000    ?
110800000000b2  ?       if *IN86 and not *IN61 or *IN12 ;              //?1st "ADD" and no Change or Cancel
110900000000    ?          LEAVE ;                                     //?END PANEL LOOP
111000000000e2  ?       endif ;
111100000000e1  ?    endfor ;
111200000000    ?
111300000000    ?  ENDSR ;
111400000000    ?
111500000000    ?
111600000000    ?  // * -------------------------------------------------------------------------------------- *
111700000000    ?  BEGSR             $OPT3     ;                       //?COPY ENTRY                           *
111800000000    ?  // * -------------------------------------------------------------------------------------- *
111900000000    ?
112000000000    ?    EXSR  $RTVCUR ;                                   //?Get current record from file
112100000000    ?
112200000000    ?    CLEAR BDCDAT ;                                    //?Date Record changed
112300000000    ?    CLEAR BDCTIM ;                                    //?Time Record changed
112400000000    ?    CLEAR BDUSID ;                                    //?Record changed by User
112500000000    ?    *IN86 = *ON  ;                                    //?NOW "ADDING"
112600000000    ?    EXSR  $OPT2  ;                                    //?EDIT WINDOW
112700000000    ?    *IN86 = *OFF ;                                    //?RESET "ADDER"
112800000000    ?    *IN(60) = %BITOR(*IN(60) : *IN(61)) ;             //?Reposition
112900000000    ?   ENDSR ;
113000000000    ?
113100000000    ?
113200000000    ?  // * -------------------------------------------------------------------------------------- *
113300000000    ?  BEGSR             $OPT4     ;                       //?DELETE RECORD                        *
113400000000    ?  // * -------------------------------------------------------------------------------------- *
113500000000    ?
113600000000    ?    *IN13 = *ON ;                                     //?Confirmation
113700000000    ?    EXSR  $OPT5 ;                                     //?Show Panel for confirmation
113800000000    ?
113900000000b1  ?    if *IN13 ;                                        //?Confirmation
114000000000b2  ?       select ;
114100000000x2  ?       when *IN76 ;                                   //?Work Centre sequence
114200000000    ?          DELETE(e) SFLKEY  CSBOMDR  ;                //?BOM Detail Record
114300000000x2  ?       when *IN77 ;                                   //?Product sequence
114400000000e2  ?       endsl ;
114500000000    ?
114600150624    ?       *IN33 = not %ERROR ;                           //?Deleted!
114700000000e1  ?    endif ;
114800000000    ?
114900000000    ?  ENDSR ;
115000000000    ?
115100000000    ?
115200000000    ?  // * -------------------------------------------------------------------------------------- *
115300000000    ?  BEGSR             $OPT5     ;                       //?DETAIL WINDOW                        *
115400000000    ?  // * -------------------------------------------------------------------------------------- *
115500000000    ?
115600000000b1  ?    if *IN82 ;                                        //?Update allowed
115700000000    ?       in8283 = '01' ;                                //?Update Mode BUT Inquiry
115800000000e1  ?    endif ;
115900000000    ?
116000000000    ?    EXSR  $RTVCUR ;                                   //?Get current record from file
116100000000    ?
116200000000b1  ?    for ###WD# = ###WD0 to ###WDS ;
116300000000    ?       EXSR  $DETAIL ;                                //?DETAIL DRILL to Screen
116400000000    ?       EXSR  $SCRWDWIO ;                              //?SCREEN WDW I/O
116500000000    ?
116600000000b2  ?       select ;                                       //?RESPONSE:
116700000000x2  ?       when *IN03  ;                                  //?EXIT
116800000000    ?          *IN03 = *OFF ;                              //?EXIT
116900000000    ?          LEAVE    ;
117000000000    ?
117100000000x2  ?       when *IN12  ;                                  //?Return
117200000000    ?          LEAVE    ;
117300000000    ?
117400000000x2  ?       when *IN13  ;                                  //?Confirmation
117500000000    ?          LEAVE    ;
117600000000    ?
117700000000x2  ?       when *IN27  ;                                  //?Page Up
117800000000    ?          ###WD# = ###WD# - 2 ;
117900000000    ?
118000000000x2  ?       when *IN28  ;                                  //?Page Dn
118100000000    ?          ###WD# = ###WD# + 0 ;
118200000000    ?
118300000000x2  ?       when @@AID <> C@FENT   ;                       //?NOT "ENTER" ==
118400000000    ?          EXSR  $F00 ;                                //?F0 =NOT DEFINED
118500000000    ?          ###WD# = ###WD# - 1 ;                       //?Stay on Panel
118600000000    ?
118700000000x2  ?       other ;                                        //?ENTER=NOOP
118800000000e2  ?       endsl ;
118900000000e1  ?    endfor ;
119000000000    ?
119100000000    ?    *IN(82) = %BITOR(*IN(82) : *IN(83)) ;             //?Reset Update allowed
119200000000    ?  ENDSR ;
119300000000    ?
119400000000    ?
119500111103    ?  // * -------------------------------------------------------------------------------------- *
119600111103    ?  BEGSR             $OPT8     ;                       //?Components: re-invoke this one       *
119700111103    ?  // * -------------------------------------------------------------------------------------- *
119800111103    ?
119900111103b1  ?    if BDTYPE <> 'M ' ;                               //?Cost Type
120000111103    ?       OptError = *ON ;                               //?Option Error
120100111103x1  ?    else ;
120200111103    ?       Component = BDITEM ;                           //?Map Component to Product Key
120300111103    ?       SETLL(e) (BDCOMP: PMANID: PNUMB) CSBOMD ;      //?BOM Detail Record
120400150624    ?       OptError = not %EQUAL ;
120500111103e1  ?    endif ;
120600111103    ?
120700111103b1  ?    if OptError ;
120800111103    ?       @@SMID = 'CST0013' ;
120900111103    ?       EXSR   $@SNDP ;
121000111103    ?       LEAVESR ;
121100111103e1  ?    endif ;
121200111103    ?
121300111103    ?    j = j + 1 ;                                       //?push current CTL (repo) key on stack:
121400111103    ?    Opt8Stk(j).C1KEY  = C1$KEY ;
121500111103    ?    Opt8Stk(j).C1KEYalt  = C1$KEYalt ;
121600111103    ?    Opt8Stk(j).Factor = L@XFAC ;
121700111103    ?    Opt8Stk(j).Cursor = RRN1 ;
121800111103    ?
121900111103    ?    *IN60 = *ON ;                                     //?Reposition to:
122000111103    ?    C1KEY2 = PMANID ;                                 //?Work Center
122100111103    ?    C1KEY3 = PNUMB  ;                                 //?Product Code
122200111103    ?    C1KEY4 = *LOVAL ;                                 //?Component
122300111103    ?  ENDSR ;
122400111103    ?
122500111103    ?
122501170629    ?  // * -------------------------------------------------------------------------------------- *
122502170629    ?  BEGSR             $OPTI     ;                       //?Implosion List                       *
122503170629    ?  // * -------------------------------------------------------------------------------------- *
122504170629    ?
122505170629    ?    Component = BDITEM ;                              //?map ==> Mfg / Prod : Labour : OverHead
122506170629    ?    CALLP(e) Implosion (PMANID: PNUMB : 1.00000) ;    //?Product Code
122507170629    ?    OptError = %ERROR ;                               //?Option Error
122508170629    ?  ENDSR ;
122509170629    ?
122510170629    ?
122600000000    ?  // * -------------------------------------------------------------------------------------- *
122700000000    ?  BEGSR             $OPTW     ;                       //?Where Used Spreadsheet               *
122800000000    ?  // * -------------------------------------------------------------------------------------- *
122900000000    ?
123000000000    ?    Component = BDITEM ;
123100000000    ?    CALLP(e) WhereUsed (PMANID: PNUMB) ;              //?Product Code
123200000000    ?  ENDSR ;
123300000000    ?
123301230524    ?
123302230524    ?  // * -------------------------------------------------------------------------------------- *
123303230524    ?  BEGSR             $OPTE     ;                       //?Explosion                            *
123304230524    ?  // * -------------------------------------------------------------------------------------- *
123305230524    ?
123306230524         ICoNumb = %editc(conumb:'X') ;
123307230524    ?    Component = BDITEM ;
123308230524    ?    CALLP(e) Explosion (PMANID: PNUMB: ICoNumb) ;     //?Product Code
123309230524    ?  ENDSR ;
123310230524    ?
123400000000    ?
123500000000    ?  // * -------------------------------------------------------------------------------------- *
123600000000    ?  BEGSR             $PAGEDN   ;                       //?NEXT FOR MORE                        *
123700000000    ?  // * -------------------------------------------------------------------------------------- *
123800000000    ?
123900000000b1  ?    if SFL1 > *ZERO  ;                                //?HAVE SUBFILE
124000000000    ?       CHAIN(e) #SFLPG  ###S1 ;                       //?LAST 'O SCREEN
124100000000e1  ?    endif ;
124200000000    ?
124300000000b1  ?    select ;
124400000000x1  ?    when *IN76 ;                                      //?Work Centre sequence
124500000000    ?       SETGT SFLKEY  CSBOMD  ;                        //?SET AT PRE-READ
124600000000x1  ?    when *IN77 ;                                      //?Product sequence
124700000000e1  ?    endsl ;
124800000000    ?
124900000000    ?    EXSR  $LOADPG ;                                   //?LOAD SFL PAGE
125000000000    ?  ENDSR ;
125100000000    ?
125200000000    ?
125300000000    ?  // * -------------------------------------------------------------------------------------- *
125400000000    ?  BEGSR             $PAGEUP   ;                       //?BACK FOR MORE                        *
125500000000    ?  // * -------------------------------------------------------------------------------------- *
125600000000    ?
125700000000b1  ?    if SFL1 > *ZERO ;                                 //?HAVE SUBFILE:
125800000000    ?       *IN95 = *OFF ;                                 //?SflEnd
125900000000    ?       CHAIN(e) 1  ###S1 ;                            //?TOP 'O SCREEN
126000000000b2  ?       select ;
126100000000x2  ?       when *IN76 ;                                   //?Work Centre sequence
126200000000    ?          SETLL SFLKEY  CSBOMD  ;                     //?--> PAST PAGE
126300000000x2  ?       when *IN77 ;                                   //?Data    sequence
126400000000e2  ?       endsl ;
126500000000x1  ?    else ;                                            //?NO SFL OR PAST
126600000000b2  ?       select ;
126700000000x2  ?       when *IN76 ;                                   //?Work Centre sequence
126800000000    ?          SETGT LVLKEY CSBOMD ;                       //?E.O.F.
126900000000x2  ?       when *IN77 ;                                   //?Product sequence
127000000000e2  ?       endsl ;
127100000000e1  ?    endif ;
127200000000    ?
127300000000b1  ?    for i = 1 to #SFLPG ;                             //?BACKUP A PAGE
127400000000b2  ?       select ;
127500000000x2  ?       when *IN76 ;                                   //?Work Centre sequence
127600000000    ?          READPE(eN) LVLKEY CSBOMD ;                  //? & READ PRIOR
127700000000x2  ?       when *IN77 ;                                   //?Product sequence
127800000000e2  ?       endsl ;
127900000000    ?
128000000000b2  ?       if %EOF ;
128100000000    ?          LEAVE ;                                     //? EXIT ON B.O.F.
128200000000e2  ?       endif ;
128300000000e1  ?    endfor ;
128400000000    ?
128500000000    ?    EXSR  $POSDBF ;                                   //?Position file
128600000000    ?    EXSR  $LOADPG ;                                   //?LOAD SFL PAGE
128700000000    ?  ENDSR ;
128800000000    ?
128900000000    ?
129000000000    ?  // * -------------------------------------------------------------------------------------- *
129100000000    ?  BEGSR             $POSDBF   ;                       //?Position the Data Base File          *
129200000000    ?  // * -------------------------------------------------------------------------------------- *
129300000000    ?
129400000000b1  ?    select ;
129500000000x1  ?    when *IN76 ;                                      //?Work Centre sequence
129600000000    ?       SETLL FLEKEY  CSBOMD  ;                        //?--> PREVIOUS
129700000000x1  ?    when *IN77 ;                                      //?Product sequence
129800000000e1  ?    endsl ;
129900000000    ?  ENDSR ;
130000000000    ?
130100000000    ?
130200000000    ?  // * -------------------------------------------------------------------------------------- *
130300000000    ?  BEGSR             $RTVCUR   ;                       //?Retrieve current record via SFL Key  *
130400000000    ?  // * -------------------------------------------------------------------------------------- *
130500000000    ?
130600000000b1  ?    select ;
130700000000x1  ?    when *IN76 ;                                      //?Work Centre sequence
130800000000    ?       CHAIN(eN) SFLKEY  CSBOMD  ;                    //?DATA AS OF NOW
130900000000x1  ?    when *IN77 ;                                      //?Product sequence
131000000000e1  ?    endsl ;
131100000000    ?
131200000000    ?  ENDSR ;
131300000000    ?
131400000000    ?
131500000000    ?  // * -------------------------------------------------------------------------------------- *
131600000000    ?  BEGSR             $SCRWDWR  ;                       //?SCREEN WDW READ                      *
131700000000    ?  // * -------------------------------------------------------------------------------------- *
131800000000    ?
131900000000b1  ?    select ;
132000000000x1  ?    when  ###WD# = 1 ;
132100000000    ?       READ(e)  ###WD1 ;                              //?WINDOW / KEYS
132200000000x1  ?    when  ###WD# = 2 ;
132300000000    ?       READ(e)  ###WD2 ;                              //?data window
132400000000e1  ?    endsl ;
132500000000    ?
132600000000    ?  ENDSR ;
132700000000    ?
132800000000    ?
132900000000    ?  // * -------------------------------------------------------------------------------------- *
133000000000    ?  BEGSR             $SCRWDWIO ;                       //?SCREEN WDW I/O                       *
133100000000    ?  // * -------------------------------------------------------------------------------------- *
133200000000    ?
133300000000    ?    EXSR      $CSET ;                                 //?CONTROL SETTING
133400000000    ?
133500000000    ?    WRITE     ###W1 ;                                 //?WINDOW / KEYS
133600000000    ?    WRITE     ###C2 ;                                 //?MESSAGES
133700000000    ?
133800000000b1  ?    if ###WD# < ###WD0  ;                             //?CLAMP SCREEN
133900000000    ?       ###WD# = ###WD0  ;                             //?COUNTER
134000000000e1  ?    endif ;                                           //?ACCORDING TO
134100000000b1  ?    if ###WD# > ###WDS  ;                             //?DEFINED RANGE.
134200000000    ?       ###WD# = ###WDS  ;
134300000000e1  ?    endif ;
134400000000    ?
134500000000b1  ?    select ;
134600000000x1  ?    when   ###WD# = 1 ;
134700000000    ?       WRITE   ###WD1 ;                               //?WINDOW / KEYS
134800000000x1  ?    when   ###WD# = 2 ;
134900000000    ?       WRITE   ###WD2 ;                               //?data window
135000000000e1  ?    endsl ;
135100000000    ?
135200000000    ?    READ(e) CSBOMD# ;                                 //?GET RESPONSE
135300150624    ?    *IN03 = %ERROR ;                                  //?EXIT
135400000000    ?
135500000000    ?    D$DSTS = @#DSTS ;                                 //?TIME-OUT STATUS
135600000000    ?
135700000000b1  ?    if *IN03 or *IN12 ;                               //?EXIT
135800000000    ?       *IN03 = *ON    ;                               //?EXIT
135900000000    ?       *IN04 = *OFF   ;                               //?PROMPT
136000000000    ?       *IN13 = *OFF   ;                               //?Return
136100000000    ?       *IN61 = *OFF   ;                               //?Window MDT
136200000000e1  ?    endif ;
136300000000    ?
136400000000    ?    EXSR      $CLEAR  ;                               //?  RESET I/O, ERRS
136500000000    ?
136600000000    ?  ENDSR ;
136700000000    ?
136800000000    ?
136900000000    ?  // * -------------------------------------------------------------------------------------- *
137000000000    ?  BEGSR             $UPDATE   ;                       //?UPDATE THE FILE                      *
137100000000    ?  // * -------------------------------------------------------------------------------------- *
137200000000    ?
137300000000b1  ?    if *IN86 ;                                        //?:: CREATE
137400000000    ?       EXSR     $DETAIL2FL ;                          //?DETAIL TO FILE
137500000000    ?       EXSR     $USRZULU ;                            //?RECORD TIME
137600000000 ?  ?
137700000000b2  ?       select ;
137800000000x2  ?       when *IN76 ;                                   //?Work Centre sequence
137900000000    ?          WRITE(e) CSBOMDR ;                          //?BOM Detail Record
138000000000x2  ?       when *IN77 ;                                   //?Product sequence
138100000000e2  ?       endsl ;
138200000000 ?  ?
138300000000b2  ?       if %ERROR  ;
138400000000    ?          *IN32 = *ON ;                               //?I/O error
138500000000x2  ?       else ;
138600000000    ?          *IN06 = *ON  ;                              //?Create
138700000000    ?          *IN86 = *OFF ;                              //?Create Mode
138800000000e2  ?       endif ;
138900000000 ?  ?
139000000000x1  ?    else ;                                            //?:: UPDATE
139100000000b2  ?       select ;
139200000000x2  ?       when *IN76 ;                                   //?Work Centre sequence
139300000000    ?          CHAIN(e) SFLKEY  CSBOMDR  ;                 //?BOM Detail Record
139400000000x2  ?       when *IN77 ;                                   //?Product sequence
139500000000e2  ?       endsl ;
139600000000 ?  ?
139700000000b2  ?       if CSRREC = '###S1' ;                          //?   S U B F I L E
139800000000    ?          CHAIN(e) RRN1 ###S1 ;                       //?Subfile List
139900000000x2  ?       else ;
140000000000    ?          EXSR $SCRWDWR ;
140100000000e2  ?       endif ;
140200000000 ?  ?
140300000000    ?       EXSR     $DETAIL2FL ;                          //?DETAIL TO FILE
140400000000    ?       EXSR     $USRZULU ;                            //?RECORD TIME
140500000000 ?  ?
140600000000b2  ?       select ;
140700000000x2  ?       when *IN76 ;                                   //?Work Centre sequence
140800170524    ?          UPDATE(e) CSBOMDR ;                         //?BOM Detail Record
140900000000x2  ?       when *IN77 ;                                   //?Product sequence
141000000000e2  ?       endsl ;
141100000000 ?  ?
141200150624    ?      *IN32 = %ERROR ;                                //?I/O error/Bad WiP
141300000000e1  ?    endif ;
141400000000 ?  ?
141500000000    ?    *IN(30) = %BITOR(*IN(30) : *IN(32)) ;             //?biton General Error
141600000000 ?  ?
141700000000b1  ?    if not GenError ;                                 //?Error on Display
141800000000    ?       H$KEY = F$KEY ;                                //?new Key to hidden
141900000000    ?       H$KEYalt = F$KEYalt ;
142000000000    ?
142100000000b2  ?       if *IN62 ;                                     //?Pp. Std. Cost MDT ==> New RM Cost
142200000000    ?          CALLP(e) CSCOSTRM (BDITEM) ;                //?Recost all Parents where-used & Rollup
142300000000x2  ?       else ;
142400000000    ?          CALLP(e) CSCOST (BDWRKC: BDPROD) ;          //?Recost just this WiP and roll 'em up
142500000000e2  ?       endif ;
142501170321    ?  //      @@SMID = 'CPF9898' ;                        //?wipe "Rolling cost" status
142502170321    ?  //      @@SDTA = *BLANK ;
142503170321    ?  //      EXSR  $@SNDP ;
142600000000e1  ?    endif ;
142700000000    ?
142800000000    ?  ENDSR ;
142900000000    ?
143000000000    ?
143100000000    ?  // * -------------------------------------------------------------------------------------- *
143200000000    ?  BEGSR             $USRZULU  ;                       //?Record Time of Action                *
143300000000    ?  // * -------------------------------------------------------------------------------------- *
143400000000    ?
143500000000    ?    EXSR  $@TODY ;                                    //?TIMESTAMP
143600000000    ?
143700000000b1  ?    if *IN86 ;                                        //?:: CREATE
143800000000    ?       BDEDAT = @YDATE  ;                             //?Date Record created
143900000000    ?       BDETIM = @YTIME  ;                             //?Time Record created
144000000000    ?       BDEUSR = @@USR   ;                             //?Record created by User
144100000000x1  ?    else ;                                            //?:: UPDATE and NOT 2nd Panel
144200000000b2  ?       if not *IN06 ;                                 //?Create
144300000000    ?          BDCDAT = @YDATE  ;                          //?Date Record changed
144400000000    ?          BDCTIM = @YTIME  ;                          //?Time Record changed
144500000000    ?          BDUSID = @@USR   ;                          //?Record changed by User
144600000000e2  ?       endif ;
144700000000e1  ?    endif ;
144800000000    ?
144900000000    ?  ENDSR ;
145000000000    ?
145100000000    ?
145200000000    ?  // * -------------------------------------------------------------------------------------- *
145300000000    ?  BEGSR             $VALIDATE ;                       //?Validate Input by Panel              *
145400000000    ?  // * -------------------------------------------------------------------------------------- *
145500000000    ?
145600000000    ?    EXSR  $DEFAULT ;                                  //?Assign Default Values for show
145700000000    ?
145800000000b1  ?    select ;
145900000000    ?
146000000000x1  ?    when ###WD# = 1 ;                                 //?       > P-A-N-E-L-1 <
146100000000    ?       CHAIN(e) (BDCOMP: BDWRKC: BDPROD) CSBOMH ;     //?BOM Header Record
146200000000    ?
146300000000b2  ?       if not %FOUND ;
146400000000    ?          *IN32 = *ON ;                               //?I/O error/Bad WiP
146500000000    ?          @@SMID = 'CST0004' ;
146600000000    ?          EXSR  $@SNDP ;
146700000000    ?          CLEAR BHDESC ;                              //?Product Description
146800000000e2  ?       endif ;
146900000000    ?
146901170321b2  ?       if BDTYPE <> 'M ' ;                            //?Not material, shift chars to left
146902170322    ?          BDITEM = %TRIML(BDITEM) ;                   //?Component
146903170322    ?          BDITEM = %SUBST(BDITEM: 1: %LEN(LALABC));   //?Component
146904170321e2  ?       endif ;
146905170321    ?
147000000000b2  ?       select ;                                       //?Check Component by type:
147100000000x2  ?       when BDTYPE = 'L ' ;                           //?Cost Type
147200000000    ?          Component = BDITEM ;                        //?Map Component to Key Fields
147300000000    ?          CHAIN(eN) (LACOMP: LALABC) CSLABR ;         //?Labour Record
147400150624    ?          *IN35 = not %FOUND ;                        //?Bad Component
147500000000    ?
147600000000x2  ?       when BDTYPE = 'M ' ;                           //?Cost Type: Material
147700000000    ?          BDITEM = %XLATE(' ': '0': BDITEM) ;         //?Blanks to zeros
147800000000b3  ?          if %CHECK('0123456789': BDITEM) = 0 ;       //?all Numeric:
147900000000    ?             Component = BDITEM ;                     //?Map Component to Key Fields
148000000000    ?             CHAIN(eN) (PCOMP: PMANID: PNUMB) OPPROD ;//?Product Master Record
148100150624    ?             *IN35 = not %FOUND ;                     //?Bad Component
148200000000x3  ?          else ;
148300000000    ?             *IN35 = *ON ;                            //?Bad Component
148400000000e3  ?          endif ;
148500000000    ?
148600000000x2  ?       when BDTYPE = 'O ' ;                           //?Cost Type
148700000000    ?          Component = BDITEM ;                        //?Map Component to Key Fields
148800000000    ?          CHAIN(eN) (OTCOMP: OTOVHT) CSOVHT ;         //?Overhead/TP Record
148900000000b3  ?          if not %FOUND or OTTYPE <> BDTYPE;          //?Overhead/TP Type
149000000000    ?             *IN34 = *ON ;                            //?Bad Cost Type
149100000000    ?             *IN35 = *ON ;                            //?Bad Component
149200000000e3  ?          endif ;
149300000000    ?
149400000000x2  ?       when BDTYPE = 'TP' ;                           //?Cost Type
149500000000    ?          Component = BDITEM ;                        //?Map Component to Key Fields
149600000000    ?          CHAIN(eN) (OTCOMP: OTOVHT) CSOVHT ;         //?Overhead/TP Record
149700000000b3  ?          if not %FOUND or OTTYPE <> BDTYPE;          //?Overhead/TP Type
149800000000    ?             *IN34 = *ON ;                            //?Bad Cost Type
149900000000    ?             *IN35 = *ON ;                            //?Bad Component
150000000000e3  ?          endif ;
150100000000    ?
150200000000x2  ?       other ;
150300000000    ?          *IN34  = *ON ;                              //?Bad Cost Type
150400000000    ?          @@SMID = 'CST0005' ;
150500000000    ?          EXSR  $@SNDP ;
150600000000    ?          CLEAR V$TDES ;                              //?
150700000000e2  ?       endsl ;
150800000000    ?
150900000000b2  ?       if *IN35 ;                                     //?Bad Component
151000000000    ?          @@SMID = 'CST0006' ;
151100000000    ?          EXSR   $@SNDP ;
151200000000    ?          CLEAR  V$DESC ;                             //?English Description1
151300000000e2  ?       endif ;
151400000000    ?
151500000000x1  ?    when ###WD# = 2 ;                                 //?       > P-A-N-E-L-2 <
151600000000    ?
151700000000e1  ?    endsl ;
151800000000    ?
151900150624    ?    GenError = ##ERR <> *ZEROS ;                      //?any errors ?
152000000000    ?  ENDSR ;
152100000000    ?
152200000000    ? /end-free
152300000000    ?
152400000000    ? /COPY @RTVD
152500000000    ? /COPY @TODY
152600000000    ? /COPY @RMVM
152700000000    ? /COPY @SNDM
152800000000    ? /COPY @SNDP
152900000000    ? /COPY @SNDS
153000120323    ? /COPY @PSSR4
153100120323    ?
153200120323    ? * ------------------------------------------------------------------------------------------ *
153300120323    ? *                  S U B   -   P R O C E D U R E S   (Standard Utilities First)              *
153400120323    ? * ------------------------------------------------------------------------------------------ *
153500120323    ?
153600120323    ? /COPY @@SNDPGM                       send pgm message:  *INxx = SndPgmMsg(id : stkcnt)
153700120323    ?
153800000000    ? /EJECT
153900000000**   Cost Types Table
154000000000L Labour
154100000000M Material
154200000000O Overhead
154300000000TPTransfer Price
