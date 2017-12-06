{
  Copyright (c) 2016, Vencejo Software
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
  TOSCPUIDTest = class(TTestCase)
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
  CheckNotEquals(0, CPUID.EAX);
  CheckNotEquals(0, CPUID.EBX);
  CheckNotEquals(0, CPUID.ECX);
  CheckNotEquals(0, CPUID.EDX);
end;

procedure TOSCPUIDTest.HasCPUIDIsTrue;
begin
  CheckTrue(TOSCPUID.New.HasCPUID);
end;

initialization

RegisterTest(TOSCPUIDTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
