{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.CPUID_test;

interface

uses
  SysUtils,
  ooOS.CPUID,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSCPUIDTest = class sealed(TTestCase)
  published
    procedure CPUIDIsNotEmpty;
    procedure HasCPUIDIsTrue;
  end;

implementation

procedure TOSCPUIDTest.CPUIDIsNotEmpty;
var
  CPUID: TCPURegister;
begin
  CPUID := TOSCPUID.New.ID;
  CheckFalse(0 = CPUID.AX);
  CheckFalse(0 = CPUID.BX);
  CheckFalse(0 = CPUID.CX);
  CheckFalse(0 = CPUID.DX);
end;

procedure TOSCPUIDTest.HasCPUIDIsTrue;
begin
  CheckTrue(TOSCPUID.New.HasCPUID);
end;

initialization

RegisterTest(TOSCPUIDTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
