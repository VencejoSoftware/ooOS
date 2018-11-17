{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit OSCPUSpeed_test;

interface

uses
  SysUtils,
  OSCPUSpeed,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSCPUSpeedTest = class sealed(TTestCase)
  published
    procedure ValueIsNotZero;
  end;

implementation

procedure TOSCPUSpeedTest.ValueIsNotZero;
var
  CPUSpeed: Double;
begin
  CPUSpeed := TOSCPUSpeed.New.Frequency;
  CheckNotEquals(0, CPUSpeed);
end;

initialization

RegisterTest(TOSCPUSpeedTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
