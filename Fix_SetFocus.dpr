program Fix_SetFocus;

uses
  FastMM4,
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {frmMain},
  LightVcl.Common.AppData in '..\..\Packages\CubicCommonControls\cbAppData.pas';

{$R *.res}

begin
  AppData:= TAppData.Create('Light-Fix SetFocus');
  AppData.CreateMainForm(TfrmMain, frmMain);
  AppData.Run;
end.
