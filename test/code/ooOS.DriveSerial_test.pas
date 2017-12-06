{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.DriveSerial_test;

interface

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
    procedure InvalidDriveMustBeZero;
  end;

implementation

procedure TOSDriveSerialTest.InvalidDriveMustBeZero;
begin
  CheckEquals(0, TOSDriveSerial.New('Ñ').Serial);
end;

procedure TOSDriveSerialTest.ValueIsNotEmpty;
begin
  CheckTrue(TOSDriveSerial.New('C').Serial <> 0);
end;

initialization

RegisterTest(TOSDriveSerialTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
