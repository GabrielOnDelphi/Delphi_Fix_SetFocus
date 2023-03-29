program Fix_SetFocus;

uses
  FastMM4,
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {frmMain},
  cFindInFile in 'cFindInFile.pas',
  ccAppData in '..\..\Packages\CubicCommonControls\ccAppData.pas',
  FormLog in '..\..\Packages\CubicCommonControls\FormLog.pas',
  ccIO in '..\..\Packages\CubicCommonControls\ccIO.pas';

{$R *.res}

begin
  Application.Initialize;
  AppData:= TAppDataEx.Create('Cubic-Fix SetFocus');
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
