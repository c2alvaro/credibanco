000001210602       Ctl-Opt DftActGrp(*No);
000002210602
000003210531       Dcl-F FUEP000V2  Workstn;
000004210112
000005210115       Dcl-S parm char(02);
000006210602       Dcl-S pass char(02) inz('NO');
000007210115
000012210531       Dcl-ds  STPGM PSDS;
000013210531          Pgm       Char(010)  Pos(001); // Nombre del Programa
000014210531          Err       Char(007)  Pos(040); // C digo Error CPF9999
000015210531          ErrMsg    Char(170)  Pos(091); // Mensaje de Error
000016210531          Disp      Char(010)  Pos(244); // Pantalla
000017210531          Usr       Char(010)  Pos(254); // Usuario
000018210531          NumJob    Char(010)  Pos(244); // N mero del Trabajo
000019210531          Hr        Zoned(6:0) Pos(282); // Hora
000020210531       End-ds;
000021210531
000022210527       Dcl-Pr FUEC001V2 ExtPgm;
000023210115           *N char(02);
000024210531           *N char(06) const;
000025210115       End-PR;
000026210115
000028210602         exsr valAcceso;
000033210114         dow *in03 = *off;
000040210602             exfmt WSFMT1;
000041210531             if pass = 'SI';
000042210531                exsr SelOpcion;
000043210531             Endif;
000044210602             if pass = 'NO';
000045210602                if SELOPC = 4 or SELOPC = 5;
000046210602                   exsr SelOpcion;
000047210602                ENDIF;
000048210602             ENDIF;
000049210114         enddo;
000050210114         *inlr = *on;
000051210114
000052210114         Begsr SelOpcion;
000053210114              select;
000054210114                   when SELOPC = 1;
000055210114                   if INPUT = 1;
000056210527                      parm='01';
000057210531                      FUEC001V2(parm:'TOKEN1');
000058210114                   endif;
000059210114                   if INPUT = 2;
000060210531                      parm='02';
000062210707                      FUEC001V2(parm:'TOKEN1');
000066210114                   endif;
000067210114                   if INPUT = 3;
000068210531                      dsply 'Not available yet...';
000069210114                   endif;
000070210114
000071210114                   when SELOPC = 2;
000072210114                   if INPUT = 1;
000073210531                      parm='03';
000074210531                      FUEC001V2(parm:'TOKEN1');
000075210114                   endif;
000076210114
000077210114                   when SELOPC = 3;
000078210114                   if INPUT = 1;
000079210531                      dsply 'Not available yet...';
000080210114                   endif;
000081210114
000082210114                   when SELOPC = 4;
000083210114                   if INPUT = 1;
000084210602                      parm='00';
000085210602                      FUEC001V2(parm:'TOKEN1');
000086210114                   endif;
000087210114
000088210114                   when SELOPC = 5;
000089210114                   if INPUT = 1;
000090210114                      *in03 = *on;
000091210114                   endif;
000092210114              endsl;
000093210114         Endsr;
000094210602
000095210602         Begsr ValAcceso;
000102210625              if usr='ACARRENO';
000103210707                if Disp='QPADEV0001' or Disp='QPADEV000Q' or
000104210707                   Disp='QPADEV000P';
000105210625                   pass = 'SI';
000106210625                else;
000107210625                   p_msg='Internal Error... ' + usr + ' F3 Exit';
000108210625                Endif;
000109210625                leavesr;
000110210625              ENDIF;
000111210604              if usr='ACARRENO' or
000112210707                 usr='AGARCIA' or
000113210707                 usr='MMENDEZ' or
000114210707                 usr='NDIAZ' or
000115210707                 usr='IREY' or
000116210708                 usr='CNINO' or
000117210712                 usr='FMONROY' or
000118210712                 usr='DPARRA';
000119210602                 pass = 'SI';
000120210602              else;
000121210602                 p_msg='Internal Error... ' + usr + ' F3 Exit';
000122210602              ENDIF;
000123210602         ENDSR;
000124210531
