program Fix_SetFocus;

uses
  FastMM4,
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {frmMain},
  cFindSetFocus in 'cFindSetFocus.pas',
  LightCore.AppData,
  LightVcl.Visual.AppData;

{$R *.res}

begin
  AppData:= TAppData.Create('Light-Fix SetFocus');
  AppData.CreateMainForm(TfrmMain, frmMain);
  AppData.Run;
end.
