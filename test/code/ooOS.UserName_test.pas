{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.UserName_test;

interface

uses
  SysUtils,
  ooOS.UserName,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSUserNameTest = class sealed(TTestCase)
  published
    procedure UserNameIsSomething;
  end;

implementation

procedure TOSUserNameTest.UserNameIsSomething;
begin
  CheckEquals(TOSUserName.New.Value, TOSUserName.New.Value);
end;

initialization

RegisterTest(TOSUserNameTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
