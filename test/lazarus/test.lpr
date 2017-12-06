{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  ooRunTest,
  ooOS.ComputerName_test in '..\code\ooOS.ComputerName_test.pas',
  ooOS.LocalIP_test in '..\code\ooOS.LocalIP_test.pas',
  ooOS.LocalMacAddress_test in '..\code\ooOS.LocalMacAddress_test.pas',
  ooOS.RemoteMacAddress_test in '..\code\ooOS.RemoteMacAddress_test.pas',
  ooOS.UserName_test in '..\code\ooOS.UserName_test.pas',
  ooOS.CPUSpeed_test in '..\code\ooOS.CPUSpeed_test.pas',
  ooOS.CPUID_test in '..\code\ooOS.CPUID_test.pas',
  ooOS.CPUVendor_test in '..\code\ooOS.CPUVendor_test.pas',
  ooOS.DriveSerial_test in '..\code\ooOS.DriveSerial_test.pas';

{R *.RES}

begin
  Run;

end.
