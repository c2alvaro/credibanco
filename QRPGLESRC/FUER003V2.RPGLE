000100190326      // FUNCTION:  UTILITY TO FIND STRINGS IN LIBRARIES
000200180716      // DEVELOPER: ALVARO CARREÑO C.
000300190326      // DATE:      MARZO DEL 2019
000301210706      //            Este PGM es el llamado por XX
000400180716
000401190326       Dcl-S  i  zoned(4:0);
000402190326       Dcl-S  p  zoned(4:0);
000403190326
000700180716       Dcl-Pi *N ;
000800190326           Dcl-Parm Lib     Char(10) ;
000900190326           Dcl-Parm File    Char(10) ;
001000190326           Dcl-Parm MbR     Char(10) ;
001001190326           Dcl-Parm Type    Char(10) ;
001100190326           Dcl-Parm Txt     Char(40) ;
001200190326           Dcl-Parm Var     Char(45) ;
001400180716       End-Pi ;
001401190326
001402210531       Dcl-Pr FUEC010V2 ExtPgm;
001403190326           *N char(10);
001404190326           *N char(10);
001405190326           *N char(10);
001406190326           *N char(10);
001407190326           *N char(40);
001408190326           *N char(45);
001409190326       End-PR;
001500180716
002500180716       //Begin
002501190326            i=1;
002502190326            dow i <= %len(%trim(Txt));
002503190326                p=%Scan('''':Txt:i);
002504190326                if p > 0 ;
002505190326                   Txt = %replace ('x': Txt: p: 1);
002506190326                Endif;
002507190326                i = i+1;
002508190326            Enddo;
002509190326            i=1;
002517190326
002518210531            FUEC010V2(Lib:File:Mbr:Type:Txt:Var);
002519190326
003500180716            *inlr = *on;
