unit cFindInFile;

interface

uses
  System.SysUtils, System.Classes, cSearchResult;


function FindStringInFile(CONST FileName: string; Replace: Boolean): TSearchResult;


IMPLEMENTATION

USES cmPascal, ccCore, ccIO;


CONST
   BackupFile: Boolean= FALSE; { Create backup files? }


{ Returns the line(s) where the text was found }
function FindStringInFile(CONST FileName: string; Replace: Boolean): TSearchResult;
var
   TextBody: TStringList;
   Front: string;
   sLine: string;
   AddUnit: Boolean;
   iPos, i: Integer;
begin
 Front := '';
 AddUnit:= FALSE;
 Result:= TSearchResult.Create;
 Result.FileName:= FileName;

 TextBody:= StringFromFileTSL(FileName{, System.SysUtils.TEncoding.UTF8});
 try
   for i:= 0 to TextBody.Count-1 do
     begin
       sLine:= TextBody[i];
       iPos:= PosInsensitive('.SetFocus;', sLine);   // We search for something like: Edit2.SetFocus;
       if iPos > 0 then
        begin
          // Ignore lines that start with a comment symbol:   // { (*
          if LineIsAComment(sLine) then Continue;

          Result.AddNewPos(i);                       // Returns the line(s) where the text was found

          if Replace then
           begin
             sLine:= ReplaceString(sLine, '//ToDo: use the "good" setfocus', '{New SetFocus}');

             { Restore spaces }
             VAR First:= FirstNonSpace(sLine);
             if First > -1
             then Front:= System.StringOfChar(' ', First-1);

             // SetFocus() can be found in cmVclUtils.pas
             TextBody[i]:= Front+ 'uUtilsFocus.SetFocus('+ ExtractObjectName(sLine)+ ');';  // We write something like SetFocus(Edit2);
             AddUnit:= TRUE;
           end;
        end;
     end;

   if AddUnit then
     begin
       AddUnitToUses(TextBody, 'uUtilsFocus, ');
       if BackupFile
       then BackupFileIncrement(FileName);
       StringToFile(FileName, TextBody.Text, woOverwrite, TRUE);
     end;

 finally
   FreeAndNil(TextBody);
 end;
end;


end.
