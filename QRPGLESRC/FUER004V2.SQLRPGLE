000101191010      // FUNCTION:  UTILITY TO FIND SOURCES IN LIBRARIES
000102191010      // DEVELOPER: ALVARO CARRE#O C.
000103210531      // DATE:      JUNIO DEL 2021
000600000000
000900210615       Dcl-F FUEP002WV2 Workstn Sfile(subfile:scont)
000901210615                                Sfile(subfile3:scont3);
001000210531       Dcl-F FUEW005    Usage(*Input);
001200000000
001202191010       Dcl-Ds Estruc1 ExtName ('UTIF001') End-Ds;
001203210615       Dcl-Ds FUEF003 ExtName ('FUEF003') End-Ds;
001204191010
001300000000       Dcl-S SCONT  zoned(10:0);
001301210615       Dcl-S SCONT3 zoned(10:0);
001302191010       Dcl-C Ok     Const(0);
001303191010       Dcl-S FteBus char(10);
001304191010       Dcl-S Pos    zoned(3);
001305210608       Dcl-S Status char(2);
001306210608       Dcl-S DateToDay   zoned(08:0);
001307210615       Dcl-S Maquina char(10);
001308210615       Dcl-S Continua Ind Inz(*OFF);
001309210615       Dcl-S Flag     zoned(2) inz(0);
001311191010
001312191010       Dcl-Ds *n;
001313191010           wDate  char(06);
001314191010              ayo char(2) pos(01);
001315191010              mes char(2) pos(03);
001316191010              dia char(2) pos(05);
003000191010       End-Ds;
003001191209       Dcl-Ds *n;
003002191209           wDate2 char(06);
003003191209              dia2 char(2) pos(01);
003004191209              mes2 char(2) pos(03);
003005191209              ayo2 char(2) pos(05);
003006191209       End-Ds;
003011191010       Dcl-Ds *n;
003012191010           wHora  char(06);
003013191010              hor char(2) pos(01);
003014191010              min char(2) pos(03);
003015191010              seg char(2) pos(05);
003016191010       End-Ds;
003017210608
003018210617       Dcl-ds  *n PSDS;
003023210608          Usr       Char(010)  Pos(254); // Usuario
003025210608          Hr        Zoned(6:0) Pos(282); // Hora
003026210608       End-ds;
003027191010
003028210608        Dcl-Pr FUEC004V2 ExtPgm;
003029210614           *N char(02) const;
003030210614           *N char(10);
003031210608           *N char(10);
003032210608           *N char(10);
003033210608           *N char(10);
003034210608           *N char(10);
003035210608           *N char(02);
003036210625           *N char(10);
003037210608       End-PR;
003038210617
003039210617       Dcl-Pr FUER006V2 ExtPgm;
003040210617           Dcl-Parm NomFte char(10);
003041210617           Dcl-Parm NomUse char(10);
003042210617           Dcl-Parm Fecha  packed(8:0);
003043210617           Dcl-Parm Maqui  char(10);
003044210706           Dcl-Parm Estado char(02);
003046210617       End-PR;
003047191010
003200000000        //Here we go...
003201210608              exec sql set Option commit=*none;
003202210608              DateToDay = %Int(%Char(%Date: *ISO0));
003400000000              exsr begin;
003500000000              *inlr=*on;
003700000000        //------------------------------------------------------------------
003800000000          begsr begin;
003802210615                flag = 0;
003803210615                setll *start fuew005;
003804191010                read fuew005;
003805191010                p_fteb = %trim(NOMAFF) +'/'+%trim(NOMFTE);
003806191010                exsr findProd;
003900210615                exsr prosfl;
003901210615                dow continua = *off;
003902210615                   flag = 0;
003903210615                   write pie;
004200210615                   exfmt control;
004203210615                   if *in01 = *on;
004204210615                      exsr viewHisto;
004205210615                   Endif;
004206210615                   if *in12 = *off;
004207210615                      exsr selsfl;
004208210615                   Endif;
004209210615                   if flag=0;
004210210615                      continua = *on;
004211210615                   Endif;
004212210615                Enddo;
005600000000          endsr;
005700000000        //------------------------------------------------------------------
005800000000          begsr prosfl;
005900000000                exsr clrsfl;
006200191010                dow not %eof(FUEW005);
006201191010                    *in69 = *off;
006300000000                    scont   =  scont + 1;
006400191010                    p_lib   =  libAff;
006500191010                    p_arf   =  nomAff;
006600191010                    p_fte   =  nomFte2;
006700191010                    p_fec1  =  fecHcr;   //creacion
006800191010                    p_fec2  =  fecHuc;   //modifica
006801191010                    p_hor   =  horHuc;   //modifica
006802210531                    p_opc   =  *blanks;
006803191010                    if fecHuc = p_fecp and horHuc = p_horp;
006804191010                       *in69 = *on;
006805191010                    Endif;
006900000000                    write subfile;
007000191010                    read FUEW005;
007100000000                enddo;
007200000000                if scont = 0;
007300000000                   scont = 1;
007400000000                   write subfile;
007500000000                endif;
007600000000          endsr;
016800000000        //------------------------------------------------------------------
016801191010          Begsr findProd;
016802191010               FteBus = NOMFTE;
016803191010               pos = %Scan('*':NOMFTE);
016804191010               if pos > 0;
016805191010                  exfmt MSGPREGU2;
016806191010                  FteBus = p_res;
016807191010               endif;
016808191010               if FteBus <> *blanks;
016809191010                  exec Sql declare C2 cursor for Select * from UTIF001
016810191010                           where ODOBNM = trim(:FteBus);
016811191010                  exec Sql open C2;
016812191010                  P_INFC='No Existe el Objeto en Producción';
016813191010                  dow sqlcode = Ok;
016814191010                      exec Sql fetch C2 into :Estruc1;
016815191010                      if sqlcode = Ok;
016816191025                         if ODLBNM<>'PGM_VERAN' and ODLBNM<>'PGM_VERANT' AND
016817191201                            ODLBNM<>'NUMODNEG' and ODLBNM<>'INARCH';
016818191010                            wDate   = ODSRCD;
016819191209                            wDate2  = ODDDAT; //fecha archivo utif001
016820191010                            p_fecp  = dia+'/'+mes+'/'+ayo;
016821191209                            p_feca  = dia2+'/'+mes2+'/'+ayo2;
016822191010                            wHora   = ODSRCT;
016823191010                            p_horp  = hor+':'+min+':'+seg;
016824191010                            p_infc = %trim(ODSRCF)+'/'+%trim(ODSRCL)+
016825191010                                  '/'+%trim(ODSRCM);
016826191010                         Endif;
016827191010                      Endif;
016828191010                  enddo;
016829191010                  exec Sql close C2;
016830191010               Endif;
016831191010          EndSr;
016834191010        //------------------------------------------------------------------
016835210604          begsr selsfl;
016836210604                readc subfile;
016837210604                dow not %eof();
016838210604                    if p_opc='3';
016839210615                       exsr cpyfFte;
016860210608                       leavesr;
016861210604                    ENDIF;
016866210604                    readc subfile;
016867210604                ENDDO;
016868210604          ENDSR;
016869210604        //------------------------------------------------------------------
016870210615          begsr CpyfFte;
016871210615               Status = 'OK';
016872210615               P_MAQ = 'D';
016873210615               p_fte2 = %trim(p_lib)+'/'+%trim(p_arf)+'/'+%trim(p_fte);
016874210615               exfmt win001;
016875210615               if *in06 = *off;
016876210615                  if P_MAQ = 'D';
016877210615                     FUEC004V2('01':P_FTE:P_ARF:P_LIB:P_ARC2:
016878210625                               P_LIB2:Status:FteBus);
016879210615                  endif;
016880210615                  if P_MAQ = 'M';
016881210615                     FUEC004V2('02':P_FTE:P_ARF:P_LIB:P_ARC2:
016882210625                              P_LIB2:Status:FteBus);
016883210615                  endif;
016884210615                  if Status <> 'OK';
016885210615                     P_ERR = 'ERROR EN LA COPIA';
016886210615                     exfmt MSGERROR;
016887210615                     flag = 1;
016888210615                  else;
016889210615                     exsr insertSQL;
016890210615                     P_MSG = 'COPIA REALIZADA CON EXITO';
016891210615                     exfmt MSGMENSA;
016892210625                     flag = 1;
016893210615                  Endif;
016894210615               else;
016895210615                  flag = 1;
016896210615               Endif;
016897210615          ENDSR;
016898210615        //------------------------------------------------------------------
016899210615          begsr viewHisto;
016900210615                exsr clrsfl3;
016901210615                exec sql Declare C1 cursor for
016902210615                   SELECT * FROM FUEF003 WHERE
016903210615                   NOMFTE=:FteBus order by fecha;
016904210615                exec sql open C1;
016905210615                dow sqlcod = 0;
016906210615                   exec sql fetch C1 into :FUEF003;
016907210615                   if sqlcod = 100;
016908210615                      leave;
016909210615                   endif;
016910210615                   scont3    = scont3 + 1;
016911210615                   P_OPC3    = *blanks;
016912210615                   P_USER3   = USER;
016913210615                   P_PRO3    = PROYEC;
016914210615                   P_FEC3    = FECHA;
016915210615                   P_MAQ3    = MAQUIN;
016916210615                   write subfile3;
016917210615                enddo;
016918210615                exec sql close C1;
016919210615                if scont3 = 0;
016920210615                   clear subfile3;
016921210615                   scont3 = 1;
016922210615                   write subfile3;
016923210615                endif;
016924210615                p_fte3 = NOMFTE;
016925210615                exfmt control3;
016926210617                readc subfile3;
016927210617                dow not %eof();
016928210617                    if p_opc3='V';
016929210617                       if P_MAQ3='MIEMBROS';
016930210617                          P_ERR = 'NO DISPONIBLE EN MIEMBROS SORRY MY FRIEND!';
016931210617                          exfmt MSGERROR;
016932210617                       else;
016933210706                          Status = 'OK';
016934210706                          FUER006V2(P_FTE3:P_USER3:P_FEC3:P_MAQ3:Status);
016935210706                          if Status <> 'OK';
016936210706                             P_ERR = 'ERROR EN LA COMPARACIÓN REVISE ' +
016937210706                                     'FTE ORIGEN Y COPIA';
016938210706                             exfmt MSGERROR;
016939210706                          Endif;
016940210706                       Endif;
016941210617                       leave;
016942210617                    ENDIF;
016943210617                    readc subfile3;
016944210617                ENDDO;
016945210615                flag = 1;
016946210615          ENDSR;
016947210615        //------------------------------------------------------------------
016948210608          begsr insertSQL;
016949210615               if p_maq = 'D';
016950210615                  maquina='DESANEW';
016951210615               else;
016952210615                  maquina='MIEMBROS';
016953210615               ENDIF;
016954210608               exec sql
016955210608                 INSERT INTO FUEF003 (user,mbrfte,libfte,nomfte,
016956210615                  fecha,hora,maquin,proyec,mbrfteo,libfteo,nomfteo)
016957210625                  VALUES(:usr,:p_arc2,:p_lib2,:FteBus,:dateToday,:hr,
016958210615                         :maquina,:p_proy,:p_arf,:p_lib,:p_fte);
016959210608          Endsr;
016960210608        //------------------------------------------------------------------
016961000000          begsr clrsfl;
017000000000                *in90 = *on;
017100000000                write control;
017200000000                scont = 0;
017300000000                *in90 = *off;
017400000000          endsr;
017401210615
017402210615          begsr clrsfl3;
017403210615                *in93 = *on;
017404210615                write control3;
017405210615                scont3 = 0;
017406210615                *in93 = *off;
017407210615          endsr;
017500000000        //------------------------------------------------------------------
