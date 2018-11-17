{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit OSEnvironment.Info_test;

interface

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$ENDIF}

uses
  SysUtils,
  OSEnvironmentInfo,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TOSEnvironmentInfoTest = class sealed(TTestCase)
  published
    procedure CountIsNotZero;
    procedure ValueByKeyComputerNameReturnSomething;
  end;

implementation

procedure TOSEnvironmentInfoTest.CountIsNotZero;
var
  OSEnvironment: IOSEnvironmentInfo;
begin
  OSEnvironment := TOSEnvironmentInfo.New;
  CheckTrue(OSEnvironment.Variables.Count <> 0);
end;

procedure TOSEnvironmentInfoTest.ValueByKeyComputerNameReturnSomething;
var
  OSEnvironment: IOSEnvironmentInfo;
begin
  OSEnvironment := TOSEnvironmentInfo.New;
{$IFDEF USE_LINUX}
  CheckTrue('' <> OSEnvironment.ValueByKey('USER'));
{$ELSE}
  CheckTrue('' <> OSEnvironment.ValueByKey('COMPUTERNAME'));
{$ENDIF}
end;

initialization

RegisterTest(TOSEnvironmentInfoTest{$IFNDEF FPC}.Suite {$ENDIF});

end.
