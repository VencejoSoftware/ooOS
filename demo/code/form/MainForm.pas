{
  Copyright (c) 2016, Vencejo Software
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

{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
var
  CPUID: IOSCPUID;
  CPUSpeed: IOSCPUSpeed;
  CPUVendor: IOSInfo;
  DriveSerial: IOSDriveSerial;
begin
  CPUID := TOSCPUID.New;
  Memo1.Lines.Append(Format('CPUID: %s.%s.%s.%s', [IntToStr(CPUID.ID.EAX), IntToStr(CPUID.ID.EBX),
    IntToStr(CPUID.ID.ECX), IntToStr(CPUID.ID.EDX)]));
  CPUVendor := TOSCPUVendor.New;
  Memo1.Lines.Append(Format('CPUVendor: %s', [CPUVendor.Value]));
  CPUSpeed := TOSCPUSpeed.New;
  Memo1.Lines.Append(Format('CPUSPEED: %f', [CPUSpeed.Frequency]));
  DriveSerial := TOSDriveSerial.New('C');
  Memo1.Lines.Append(Format('C-SERIAL: %s', [IntToStr(DriveSerial.Serial)]));
end;

end.
