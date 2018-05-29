{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.DriveSerial_test;

interface

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$ENDIF}

uses
  SysUtils,
  ooOS.DriveSerial,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSDriveSerialTest = class sealed(TTestCase)
  published
    procedure ValueIsNotEmpty;
    procedure InvalidDriveMustBeEmpty;
  end;

implementation

procedure TOSDriveSerialTest.InvalidDriveMustBeEmpty;
begin
  CheckEquals('', TOSDriveSerial.New('Ñ').Value);
end;

procedure TOSDriveSerialTest.ValueIsNotEmpty;
begin
{$IFDEF USE_LINUX}
  CheckTrue(TOSDriveSerial.New('/dev/sda').Value <> '');
{$ELSE}
  CheckTrue(TOSDriveSerial.New('C').Value <> '');
{$ENDIF}
end;

initialization

RegisterTest(TOSDriveSerialTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
