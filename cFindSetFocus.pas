unit cFindSetFocus;

{-------------------------------------------------------------------------------------------------------------
   Description here: https://gabrielmoraru.com/setfocus-is-broken-in-delphi/

   Issue: Does not work with some PAS files that have no BOM. The bug is in System.IOUtils.TFile.ReadAllText

   Features:
     Ignores lines that start with a comment symbol:   // { (*

   ToDo: Automatically remove the Try/Except arround the SetFocus:
     Example:
       try
         SetFocus(edtUserInput);
       except
       end;

-------------------------------------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, cmSearchResult;


function FindSetFocusInFile(CONST FileName: string; Replace: Boolean): TSearchResult;


IMPLEMENTATION

USES cmPascal, ccCore, csSystem, cbDialogs, ccIO, ccTextFile, cmIO, cmIO.Win;


CONST
   BackupFile: Boolean= FALSE; { Create backup files? }


{ Returns the line(s) where the text was found }
function FindSetFocusInFile(CONST FileName: string; Replace: Boolean): TSearchResult;
var
   TextBody: TStringList;
   Front: string;
   sLine: string;
   AddUnit: Boolean;
   iPos, i: Integer;
begin
 Front := '';
 AddUnit:= FALSE;
 Result:= TSearchResult.Create(FileName);

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

          Result.AddNewPos(i, iPos, sLine);                       // Returns the line(s) where the text was found

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
       StringToFile(FileName, TextBody.Text, woOverwrite, wpAuto);
     end;

 finally
   FreeAndNil(TextBody);
 end;
end;


end.
