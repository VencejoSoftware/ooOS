{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.ComputerName_test;

interface

uses
  SysUtils,
  ooOS.ComputerName,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSComputerNameTest = class(TTestCase)
  published
    procedure ComputerNameIs;
  end;

implementation

procedure TOSComputerNameTest.ComputerNameIs;
begin
  CheckEquals(TOSComputerName.New.Value, TOSComputerName.New.Value);
end;

initialization

RegisterTest(TOSComputerNameTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
