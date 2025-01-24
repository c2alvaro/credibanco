000100180716      // FUNCTION:  UTILITY TO FIND SOURCES IN LIBRARIES
000200180716      // DEVELOPER: ALVARO CARREÑO C.
000300210531      // DATE:      JUNIO DEL 2021
000400180716
000501181001       Dcl-F FUEW004 Usage(*Output);
000600180716
000601181001       Dcl-Ds Estruc1 ExtName ('FUEW003') End-Ds;
000602181001       Dcl-C Ok     Const(0);
000603181001       Dcl-S FteBus char(10);
000604181001       Dcl-S Pos    zoned(3);
000605181001
000700180716       Dcl-Pi *N ;
001000180716           Dcl-Parm MbRfte  Char(10) ;
001001181002           Dcl-Parm Fecfte  Char(6) ;
001400180716       End-Pi ;
002400180716
002500180716       //Begin
002501181001            pos = %Scan('*':MbRfte);
002502181001            if pos > 0;
002503181001               exsr Forma1;
002504181001            else;
002505181001               exsr Forma2;
002506181001            Endif;
002507181001            *inlr = *on;
002508181001
002509181001            BegSr Forma1;
002510181001                  fteBus = %replace ('': MbRfte: pos: 1);
002511181001                  exec Sql declare C1 cursor for Select * from FUEW003
002512181001                                    where MLNAME like trim(:fteBus) concat '%';
002513181001                  exec Sql open C1;
002514181001                  dow sqlcode = Ok;
002515181001                      exec Sql fetch C1 into :Estruc1;
002516181001                      if sqlcode = Ok;
002517181001                         exsr WriteReg;
002518181001                      endif;
002519181001                  enddo;
002520181001                  exec Sql close C1;
002521181001            EndSr;
002522181001
002523181001            BegSr Forma2;
002524181001                  exec Sql declare C2 cursor for Select * from FUEW003
002525181001                                    where MLNAME = trim(:MbRfte);
002526181001                  exec Sql open C2;
002527181001                  dow sqlcode = Ok;
002528181001                      exec Sql fetch C2 into :Estruc1;
002529181001                      if sqlcode = Ok;
002530181001                         exsr WriteReg;
002531181001                      endif;
002532181001                  enddo;
002533181001                  exec Sql close C2;
002534181001            EndSr;
002535181001
002536181001            BegSr WriteReg;
002600181001                  libAff  = MLLIB;
002700181001                  nomAff  = MLFILE;
002800181001                  nomFte  = MbRfte;
002900181001                  nomFte2 = MLNAME;
003400181001                  Write FUEF004R;
003500181001            Endsr;
