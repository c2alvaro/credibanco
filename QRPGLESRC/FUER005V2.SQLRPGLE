000101191010      // FUNCTION:  UTILITY TO FIND SOURCES IN LIBRARIES
000102191010      // DEVELOPER: ALVARO CARRE#O C.
000103191010      // DATE:      JULIO DEL 2018
000600000000
000800000000
000900210531       Dcl-F FUEP002WV2 Workstn Sfile(subfile:scont);
001201191010       Dcl-Ds Estruc1 ExtName ('UTIF001') End-Ds;
001202191010
001203191114       Dcl-s Scont  zoned(10:0);
001301191010       Dcl-C Ok     Const(0);
001302191010       Dcl-S FteBus char(10);
001304191010
001305191114       Dcl-PI *N;
001306191114          Dcl-Parm PARM1 char(10);
001308191114       End-PI;
001309191114
001310191010       Dcl-Ds *n;
001311191010           wDate  char(06);
001312191010              ayo char(2) pos(01);
001313191010              mes char(2) pos(03);
001314191010              dia char(2) pos(05);
003000191010       End-Ds;
003001191209       Dcl-Ds *n;
003002191209           wDate2 char(06);
003003191209              dia2 char(2) pos(01);
003004191209              mes2 char(2) pos(03);
003005191209              ayo2 char(2) pos(05);
003006191209       End-Ds;
003008191010       Dcl-Ds *n;
003009191010           wHora  char(06);
003010191010              hor char(2) pos(01);
003011191010              min char(2) pos(03);
003012191010              seg char(2) pos(05);
003013191010       End-Ds;
003014191010
003015191010
003200000000        //Here we go...
003400000000              exsr begin;
003500000000              *inlr=*on;
003501191010              Return;
003700000000        //------------------------------------------------------------------
003800000000          begsr begin;
003802191114                p_fteb = parm1;
003804191010                exsr findProd;
003900000000                exsr prosfl;
003901210531                write pie;
004200191010                exfmt control;
005600000000          endsr;
005700000000        //------------------------------------------------------------------
005800000000          begsr prosfl;
005900000000                exsr clrsfl;
007300191114                scont = 1;
007400191114                write subfile;
007600000000          endsr;
016800000000        //------------------------------------------------------------------
016801191010          Begsr findProd;
016802191114               FteBus = parm1;
016809191114               exec Sql declare C2 cursor for Select * from UTIF001
016810191114                    where ODOBNM = trim(:FteBus);
016811191114               exec Sql open C2;
016812191114               P_INFC='No Existe el Objeto en Producción';
016813191114               dow sqlcode = Ok;
016814191114                   exec Sql fetch C2 into :Estruc1;
016815191114                   if sqlcode = Ok;
016816191114                      if ODLBNM<>'PGM_VERAN' and ODLBNM<>'PGM_VERANT' AND
016817191114                         ODLBNM<>'NUMODNEG';
016818191114                         wDate   = ODSRCD;
016819191209                         wDate2  = ODDDAT; //fecha archivo utif001
016820191114                         p_fecp  = dia+'/'+mes+'/'+ayo;
016821191209                         p_feca  = dia2+'/'+mes2+'/'+ayo2;
016822191114                         wHora   = ODSRCT;
016823191114                         p_horp  = hor+':'+min+':'+seg;
016824191114                         p_infc = %trim(ODSRCF)+'/'+%trim(ODSRCL)+
016825191114                               '/'+%trim(ODSRCM);
016826191114                      Endif;
016827191114                   Endif;
016828191114               Enddo;
016829191114               exec Sql close C2;
016830191010          EndSr;
016834191010        //------------------------------------------------------------------
016900000000          begsr clrsfl;
017000000000                *in90 = *on;
017100000000                write control;
017200000000                scont = 0;
017300000000                *in90 = *off;
017400000000          endsr;
017500000000        //------------------------------------------------------------------
