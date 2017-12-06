{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.LocalMacAddress_test;

interface

uses
  SysUtils,
  ooOS.LocalMacAddress,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSLocalMacAddressTest = class(TTestCase)
  published
    procedure MacAddressIs;
  end;

implementation

procedure TOSLocalMacAddressTest.MacAddressIs;
begin
  CheckEquals(TOSLocalMacAddress.New.Value, TOSLocalMacAddress.New.Value);
end;

initialization

RegisterTest(TOSLocalMacAddressTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
