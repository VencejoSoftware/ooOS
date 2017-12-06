{
  Copyright (c) 2016, Vencejo Software
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
  TOSUserNameTest = class(TTestCase)
  published
    procedure UserNameIs;
  end;

implementation

procedure TOSUserNameTest.UserNameIs;
begin
  CheckEquals(TOSUserName.New.Value, TOSUserName.New.Value);
end;

initialization

RegisterTest(TOSUserNameTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
