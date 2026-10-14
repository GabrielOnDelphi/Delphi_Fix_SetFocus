program Fix_SetFocus;

uses
  FastMM4,
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {frmMain},
  cFindSetFocus in 'cFindSetFocus.pas',
  LightCore.AppData,
  {$IFDEF AUTOPILOT}Autopilot.Bridge.Vcl in 'c:\Projects\Projects AI\Autopilot for Delphi\Source\Bridge\Autopilot.Bridge.Vcl.pas',{$ENDIF}{Optional}
  LightVcl.Visual.AppData;

{$R *.res}

begin
  AppData:= TAppData.Create('Light-Fix SetFocus');
  AppData.CreateMainForm(TfrmMain, frmMain);

  { Optional: Via Autopilot, Claude can run/debug/test this program for you.
    For example, type a folder into edtPath, press "Search" & check the files listed in lbxResults.
    Don't have AUTOPILOT? Undefine $AUTOPILOT or get it from www.GabrielMoraru.com }
  {$IFDEF AUTOPILOT}
   Autopilot.Bridge.Vcl.StartBridge;
  {$ENDIF}
  AppData.Run;
end.
