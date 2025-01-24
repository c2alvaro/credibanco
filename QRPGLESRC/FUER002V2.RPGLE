000100180716      // FUNCTION:  UTILITY TO FIND SOURCES IN LIBRARIES
000200180716      // DEVELOPER: ALVARO CARREÑO C.
000300210531      // DATE:      JUNIO DEL 2021
000400180716
000500181002       Dcl-F FUEW005 Usage(*Output);
000600180716
000700180716       Dcl-Pi *N ;
000800180716           Dcl-Parm BiBlio  Char(10) ;
000900180716           Dcl-Parm ArChff  Char(10) ;
001000180716           Dcl-Parm MbRfte  Char(10) ;
001001181002           Dcl-Parm MbRfte2 Char(10) ;
001100180716           Dcl-Parm FeCrea  Char(13) ;
001200180716           Dcl-Parm FeUlca  Char(13) ;
001400180716       End-Pi ;
001500180716
001600180716       Dcl-Ds *n;
001700181002           wDate  char(13);
001800181002              va1 char(1) pos(01);
001900181002              ayo char(2) pos(02);
002000181002              mes char(2) pos(04);
002100181002              dia char(2) pos(06);
002200181002              hor char(2) pos(08);
002201181002              min char(2) pos(10);
002202181002              seg char(2) pos(12);
002300180716       End-Ds;
002400180716
002500180716       //Begin
002600180910            libAff  = biblio;
002700180910            nomAff  = archff;
002800180910            nomFte  = mbrfte;
002900181002            nomFte2 = mbrfte2;
003000180910            wDate   = fecrea;
003100180910            fecHcr  = dia+'/'+mes+'/'+ayo;
003200180910            wDate   = feulca;
003300180910            fecHuc  = dia+'/'+mes+'/'+ayo;
003301181002            horHuc  = hor+':'+min+':'+seg;
003400180716            Write FUEF004R;
003500180716            *inlr = *on;
