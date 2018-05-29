{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  ooOS.ComputerName,
  ooOS.CPUID,
  ooOS.CPUSpeed,
  ooOS.CPUVendor,
  ooOS.DriveSerial,
  ooOS.Info.Intf,
  ooOS.LocalIP,
  ooOS.LocalMacAddress,
  ooOS.RemoteMacAddress,
  ooOS.UserName;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  end;

var
  NewMainForm: TMainForm;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

procedure TMainForm.Button1Click(Sender: TObject);
var
  CPUID: IOSCPUID;
  CPUSpeed: IOSCPUSpeed;
  CPUVendor: IOSInfo;
  DriveSerial: IOSInfo;
begin
  CPUID := TOSCPUID.New;
  Memo1.Lines.Append(Format('CPUID: %d.%d.%d.%d', [CPUID.ID.AX, CPUID.ID.BX, CPUID.ID.CX, CPUID.ID.DX]));
  CPUVendor := TOSCPUVendor.New;
  Memo1.Lines.Append(Format('CPUVendor: %s', [CPUVendor.Value]));
  CPUSpeed := TOSCPUSpeed.New;
  Memo1.Lines.Append(Format('CPUSPEED: %f', [CPUSpeed.Frequency]));
  DriveSerial := TOSDriveSerial.New('C');
  Memo1.Lines.Append(Format('C-SERIAL: %s', [DriveSerial.Value]));
end;

end.
