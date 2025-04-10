UNIT uMainForm;

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

INTERFACE

USES
  Winapi.Windows, Winapi.messages, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, cFindSetFocus, Vcl.Menus, cmSearchResult, Vcl.Mask;

TYPE
  TfrmMain = class(TLightForm)
    btnNext       : TButton;
    btnPrev       : TButton;
    btnReset      : TButton;
    btnStart      : TButton;
    mnuCopyName   : TMenuItem;
    edtFilter     : TLabeledEdit;
    edtPath       : TLabeledEdit;
    lblCurFile    : TLabel;
    lblRewind     : TLabel;
    lbxResults    : TListBox;
    mmoView       : TMemo;
    mnuOpen       : TMenuItem;
    Panel1        : TPanel;
    Panel2        : TPanel;
    pnlFiles      : TPanel;
    pnlView       : TPanel;
    PopupMenu     : TPopupMenu;
    Splitter      : TSplitter;
    TimerRew      : TTimer;
    btnReplace    : TButton;
    Button1: TButton;
    procedure btnNextClick       (Sender: TObject);
    procedure btnPrevClick       (Sender: TObject);
    procedure btnResetClick      (Sender: TObject);
    procedure btnSearchClick     (Sender: TObject);
    procedure mnuCopyNameClick   (Sender: TObject);
    procedure FormCreate         (Sender: TObject);
    procedure FormDestroy        (Sender: TObject);
    procedure lbxResultsDblClick (Sender: TObject);
    procedure TimerRewTimer      (Sender: TObject);
  private
    function GetSelectedSearch: TSearchResult;
    procedure FreeResults;
    procedure Reset;
  end;

VAR
  frmMain: TfrmMain;

implementation {$R *.dfm}

USES
   ccIO, ccTextFile, cmIO, cmIO.Win, ccCore, csSystem, cbDialogs, ccAppData, cbAppDataVCL
, cvINIFile, cbINIFileQuick, csExecuteShell;

VAR
  CurFoundPos: Integer;
  LastLine: Integer;  { We need it for the 'Next' button }



procedure TfrmMain.FormCreate(Sender: TObject);
begin
  edtPath.Text:= cbINIFileQuick.ReadString('Path', 'C:\Projects');
  if AppData.RunningFirstTime then
   begin
     MesajInfo('SetFocus is broken in Delphi.'+ CRLF+
               'Try to set focus on a visual control that is disabled or is invisible or simply is not focusable, and the program will crash.'+ CRLF+
               'I created a safe alternative for Delphi’s SetFocus. This tool does the batch replace.');
     executeurl('https://gabrielmoraru.com/setfocus-is-broken-in-delphi/');
   end;
end;


procedure TfrmMain.FormDestroy(Sender: TObject);
begin
 WriteString('Path', edtPath.Text);  { Save GUI }
 FreeResults;                        { Release objects }
end;


procedure TfrmMain.FreeResults;
var i : Integer;
begin
 for i:= 0 to lbxResults.Items.Count -1 do
    FreeAndNil(lbxResults.Items.Objects[i]);          { Release list and owned objects }

 lbxResults.Clear;
end;


procedure ConvertToUTF(FileName: string);
begin
 VAR s:= StringFromFile(FileName, System.SysUtils.TEncoding.UTF8);
 StringToFile(FileName, s, woOverwrite, wpAuto);
end;


procedure TfrmMain.btnSearchClick(Sender: TObject);
var
   TextFile: string;
   Replaces: Integer;
   FoundFilesCount: Integer;
   FileList: TStringList;
   SearchResult: TSearchResult;
begin
  FreeResults;
  Reset;
  mmoView.Clear;
  Replaces:= 0;
  FoundFilesCount:= 0;
  pnlView.Visible:= True;
  btnNext.Visible:= True;
  btnPrev.Visible:= True;
  lblRewind.Visible:= false;
  btnReset.Visible:= TRUE;

  FileList:= ListFilesOf(edtPath.Text, edtFilter.Text, True, True);
  try
    for TextFile in FileList do
     begin
       SearchResult:= FindSetFocusInFile(TextFile, (Sender as TButton).Tag = 1);
       Replaces:= Replaces + SearchResult.Count;

       if SearchResult.Found
       then
        begin
         lbxResults.AddItem(SearchResult.FileName + '  Found at: '+ SearchResult.PositionsAsString, SearchResult);
         Inc(FoundFilesCount);
        end
       else
        begin
          lbxResults.Items.Add(TextFile);
          //FreeAndNil(SearchResult);
        end;
     end;

    Caption:= 'Searched '+ IntToStr(FileList.Count)+ ' files. Found: '+ IntToStr(Replaces)+ ' times in '+ IntToStr(FoundFilesCount)+ ' files.';
  finally
    FreeAndNil(FileList);
  end;

 { Load first result }
 if lbxResults.Items.Count > 0 then
  begin
   lbxresults.ItemIndex:= 0;
   lbxResultsDblClick(Sender);
  end;
end;


{ Returns the object selected by the user }
function TfrmMain.GetSelectedSearch: TSearchResult;
begin
 Result:= lbxResults.Items.Objects[lbxResults.ItemIndex] as TSearchResult;
end;


procedure TfrmMain.lbxResultsDblClick(Sender: TObject);
begin
 if GetSelectedSearch <> NIL then
  begin
   lblCurFile.Caption:= GetSelectedSearch.FileName;
   mmoView.Lines.LoadFromFile(GetSelectedSearch.FileName);
   Reset;
   lblRewind.Visible:= false;

   //Scroll to first found pos
   var CurLine:= GetSelectedSearch.Positions[0];
   SendMessage(mmoView.Handle, EM_LINESCROLL, 0, CurLine.LinePos);

   LastLine:= CurLine.LinePos;
  end;
end;


procedure TfrmMain.btnResetClick(Sender: TObject);
begin
 Reset;
end;


procedure TfrmMain.btnNextClick(Sender: TObject);
var Delta, CurLine: Integer;
begin
 TimerRew.Enabled:= True;

 Inc(CurFoundPos);
 if CurFoundPos > High(GetSelectedSearch.Positions) then
  begin
   Reset;
   lblRewind.Left:= 10000;
   lblRewind.Visible:= true;
  end;

 CurLine:= GetSelectedSearch.Positions[CurFoundPos].LinePos;
 Delta:= CurLine - LastLine;
 LastLine:= CurLine;

 SendMessage(mmoView.Handle, EM_LINESCROLL, 0, Delta);
 Caption:= IntToStr(CurLine);
end;



procedure TfrmMain.btnPrevClick(Sender: TObject);
var Delta, CurLine: Integer;
begin
 TimerRew.Enabled:= True;

 Dec(CurFoundPos);
 if CurFoundPos < 0 then
  begin
   Reset;
   lblRewind.Left:= 10000;
   lblRewind.Visible:= true;
  end;

 CurLine:= GetSelectedSearch.Positions[CurFoundPos].LinePos;
 Delta:= CurLine - LastLine;
 LastLine:= CurLine;

 SendMessage(mmoView.Handle, EM_LINESCROLL, 0, Delta);
end;


procedure TfrmMain.TimerRewTimer(Sender: TObject);
begin
 lblRewind.Visible:= False;
 TimerRew.Enabled:= false;
end;


procedure TfrmMain.Reset;
begin
 LastLine:= 0;
 CurFoundPos:= 0;
 mmoView.SelStart  := 0;     { Scroll at the top }
 mmoView.SelLength := 0;
 mmoView.Perform(EM_SCROLLCARET, 0, 0);
end;


procedure TfrmMain.mnuCopyNameClick(Sender: TObject);
begin
 StringToClipboard(GetSelectedSearch.FileName);
end;



end.
