{
  Copyright (c) 2016, Vencejo Software
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
  TOSLocalIPTest = class(TTestCase)
  published
    procedure LocalIPIs;
  end;

implementation

procedure TOSLocalIPTest.LocalIPIs;
begin
  CheckEquals(TOSLocalIP.New.Value, TOSLocalIP.New.Value);
end;

initialization

RegisterTest(TOSLocalIPTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
