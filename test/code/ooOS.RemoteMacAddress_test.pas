{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.RemoteMacAddress_test;

interface

uses
  SysUtils,
  ooOS.LocalIP,
  ooOS.LocalMacAddress, ooOS.RemoteMacAddress,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSRemoteMacAddressTest = class sealed(TTestCase)
  published
    procedure MacAddressIsText;
  end;

implementation

procedure TOSRemoteMacAddressTest.MacAddressIsText;
begin
  CheckEquals(TOSLocalMacAddress.New.Value, TOSRemoteMacAddress.New(TOSLocalIP.New.Value).Value);
end;

initialization

RegisterTest(TOSRemoteMacAddressTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
