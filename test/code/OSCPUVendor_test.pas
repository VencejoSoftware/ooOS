{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit OSCPUVendor_test;

interface

uses
  SysUtils,
  OSCPUVendor,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSCPUVendorTest = class sealed(TTestCase)
  published
    procedure ValueIsNotEmpty;
    procedure SerialLenIs12;
    procedure IOsGenuineIntel;
  end;

implementation

procedure TOSCPUVendorTest.IOsGenuineIntel;
begin
  CheckEquals('GenuineIntel', TOSCPUVendor.New.Value);
end;

procedure TOSCPUVendorTest.SerialLenIs12;
var
  CPUVendor: String;
begin
  CPUVendor := TOSCPUVendor.New.Value;
  CheckEquals(12, Length(CPUVendor));
end;

procedure TOSCPUVendorTest.ValueIsNotEmpty;
begin
  CheckTrue(TOSCPUVendor.New.Value <> EmptyStr);
end;

initialization

RegisterTest(TOSCPUVendorTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
