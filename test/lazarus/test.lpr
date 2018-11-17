{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  RunTest,
  OSComputerName_test in '..\code\OSComputerName_test.pas',
  OSLocalIP_test in '..\code\OSLocalIP_test.pas',
  OSLocalMacAddress_test in '..\code\OSLocalMacAddress_test.pas',
  OSRemoteMacAddress_test in '..\code\OSRemoteMacAddress_test.pas',
  OSUserName_test in '..\code\OSUserName_test.pas',
  OSCPUSpeed_test in '..\code\OSCPUSpeed_test.pas',
  OSCPUID_test in '..\code\OSCPUID_test.pas',
  OSCPUVendor_test in '..\code\OSCPUVendor_test.pas',
  OSDriveSerial_test in '..\code\OSDriveSerial_test.pas',
  OSComputerName in '..\..\code\OSComputerName.pas',
  OSCPUID in '..\..\code\OSCPUID.pas',
  OSCPUSpeed in '..\..\code\OSCPUSpeed.pas',
  OSCPUVendor in '..\..\code\OSCPUVendor.pas',
  OSDriveSerial in '..\..\code\OSDriveSerial.pas',
  OSEnvironmentInfo in '..\..\code\OSEnvironmentInfo.pas',
  OSInfo in '..\..\code\OSInfo.pas',
  OSLocalIP in '..\..\code\OSLocalIP.pas',
  OSLocalMacAddress in '..\..\code\OSLocalMacAddress.pas',
  OSRemoteMacAddress in '..\..\code\OSRemoteMacAddress.pas',
  OSUserName in '..\..\code\OSUserName.pas',
  OSEnvironment.Info_test in '..\code\OSEnvironment.Info_test.pas';

{R *.RES}

begin
  Run;

end.
