program Fix_SetFocus;

uses
  FastMM4,
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {frmMain},
  cbAppData in '..\..\Packages\CubicCommonControls\cbAppData.pas';

{$R *.res}

begin
  AppData:= TAppData.Create('Light-Fix SetFocus');
  AppData.CreateMainForm(TfrmMain, frmMain);
  Application.Run;
end.
