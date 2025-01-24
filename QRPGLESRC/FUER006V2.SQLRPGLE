000200180716      // DEVELOPER: ALVARO CARREO C.
000201210623
000605210623       Dcl-Ds $FUEF003 ExtName ('FUEF003') End-Ds;
000606210623
000607210623       Dcl-S CSql  char(250);
000608210623       Dcl-S CSql2 char(250);
000609210623       Dcl-S Cmd   char(200);
000610210623
000611210623       Dcl-Pr QCMDEXC extPgm;
000612210623          *n char(200)   Options(*Varsize) Const;
000613210623          *n packed(15:5) Const;
000614210623       End-Pr;
000615210623
000616210623       Dcl-Pi *N ;
000617210623           Dcl-Parm pNomFte char(10);
000618210623           Dcl-Parm pNomUse char(10);
000619210623           Dcl-Parm pFecha  packed(8:0);
000620210623           Dcl-Parm pMaqui  char(10);
000621210706           Dcl-Parm pEstado char(02);
000622210623       End-Pi ;
000623210623
002501210623          exec sql set Option commit=*none;
003552210623          cmd = 'CLRPFM FILE(FUEW006)';
003553210623          QcmdExc(Cmd: %size(Cmd));
003554210623
003555210623          exec sql SELECT * into :$FUEF003 from FUEF003
003556210623               where USER=:pNomUse and NOMFTEO=:pNomFte and
003557210623                     FECHA=:pFecha and MAQUIN=:pMaqui;
003558210623
003559210623          Csql  = 'create alias qtemp/fuente1 for ' +
003560210623                   %trim(LIBFTEO)+'/'+%trim(MBRFTEO)+'('+%trim(NOMFTEO)+')';
003561210706
003564210623          Csql2 = 'create alias qtemp/fuente2 for ' +
003565210623                   %trim(LIBFTE)+'/'+%trim(MBRFTE)+'('+%trim(NOMFTE)+')';
003569210706
003570210706
003571210706          exec sql execute immediate :Csql;
003572210706          if sqlcod<> 0;
003573210706             pEstado = 'ER';
003574210706          Endif;
003575210706          exec sql execute immediate :Csql2;
003576210706          if sqlcod<> 0;
003577210706             pEstado = 'ER';
003578210706          Endif;
003579210706          if pEstado = 'OK';
003580210706             exec sql insert into fuew006
003581210706                select A.* from fuente2 A
003582210706                left join fuente1 B on A.srcdta =  B.srcdta
003583210706                and a.srcseq = b.srcseq
003584210706                where B.srcdta IS NULL;
003585210623
003586210706             Exec sql Drop alias qtemp/fuente1;
003587210706             Exec sql Drop alias qtemp/fuente2;
003588210623
003589210706             cmd = 'runqry *n fuew006';
003590210706             QcmdExc(Cmd: %size(Cmd));
003591210706          Endif;
003592210706
003593210623          *inlr = *on;
