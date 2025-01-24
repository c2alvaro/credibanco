000100181011      // FUNCTION:  UTILITY TO FTP OPERATIONS
000200180716      // DEVELOPER: ALVARO CARREO C.
000300210615      // DATE:      JUNIO DEL 2020
000400180716
000500210615       Dcl-F QFTPSRC  Usage(*Output) rename(QFTPSRC:reg)
000600181010                                    extmbr('FTPSRC');
000601210615       Dcl-F QFTPSRC2 Usage(*Input) rename(QFTPSRC2:reg2)
000602210615                                    extmbr('FTPSRC2');
000603181010
000604181010       Dcl-Pi *N ;
000605210615           Dcl-Parm Modo      char(02);
000606210615           Dcl-Parm NomSavf   Char(10) ;
000607210615           Dcl-Parm LibSavf   Char(10) ;
000608210615           Dcl-Parm Opc       Char(1) ;
000609210615           Dcl-Parm libRemoto char(10);
000610210615           Dcl-Parm liblocal  char(10);
000611210615           Dcl-Parm Arch1     char(10);
000612210615           Dcl-Parm Pgm1      char(10);
000613210615           Dcl-Parm Arch2     char(10);
000614210628           Dcl-Parm FteOri    char(10);
000615181010       End-Pi ;
000616181010
002500180716       //Begin
002501210615             if modo = '01';
002502210615                exsr modo1;
002503210615             ENDIF;
002504210615             if modo = '02';
002505210615                exsr modo2;
002506210615             ENDIF;
002507210615             if modo = '03';
002508210615                exsr modo3;
002509210615             ENDIF;
002510210615             *inlr = *on;
002511210615
002512210615             Begsr Modo1;
002513210615             srcdta = 'transf400 Credi400*';
002514210615             write reg;
002515210615             srcdta = 'b';
002516210615             write reg;
002517210615             if opc='0' or opc='1';
002518210615                srcdta = 'put '+%trim(libSavf)+'/'+%trim(nomSavf);
002519210615             else;
002520210615                srcdta = 'get '+%trim(nomSavf)+' '+%trim(libSavf)+
002521181010                                '/'+%trim(nomSavf) +' (replace';
002522210615             endif;
002523210615             write reg;
002524210615             srcdta = 'quit';
002525210615             write reg;
003500210615             EndSr;
003501210615        //-----------------------------------------------------------------------------------
003502210615             Begsr Modo2;
003503210615             srcdta = 'acarreno Estefany3';
003504210615             write reg;
003505210615
003506210615             srcdta = 'asc';
003507210615             write reg;
003508210615
003509210615             srcdta = 'cd ' +  %trim(libRemoto);
003510210615             write reg;
003511210615
003512210615             srcdta = 'lcd ' + %trim(liblocal);
003513210615             write reg;
003514210615
003515210615             //put qrpglesrc.car0227 qrpglesrc.car0227
003516210615             srcdta = 'put '+%trim(Arch1)+'.'+%trim(Pgm1) + ' ' +
003517210628                             %trim(Arch2)+'.'+%trim(FteOri);
003518210615             write reg;
003519210615
003520210615             srcdta = 'quit';
003521210615             write reg;
003522210615             EndSr;
003523210615        //----------------------------------------------------------------------------------
003524210615             begsr Modo3;
003525210615              modo = 'ER';
003526210615              read QFTPSRC2;
003527210615              dow not %eof(QFTPSRC2);
003528210615             if %SubSt(srcdta:1:41)='226 File transfer completed successfully.';
003529210615                 modo = 'OK';
003534210615             Endif;
003537210615              read QFTPSRC2;
003538210615              enddo;
003540210615             ENDSR;
