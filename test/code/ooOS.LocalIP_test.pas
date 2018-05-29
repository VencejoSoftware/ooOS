{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.LocalIP_test;

interface

uses
  SysUtils,
  ooOS.LocalIP,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSLocalIPTest = class sealed(TTestCase)
  published
    procedure LocalIPIsText;
  end;

implementation

procedure TOSLocalIPTest.LocalIPIsText;
begin
  CheckEquals(TOSLocalIP.New.Value, TOSLocalIP.New.Value);
end;

initialization

RegisterTest(TOSLocalIPTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
