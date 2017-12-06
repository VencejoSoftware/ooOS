{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.LocalMacAddress;

interface

uses
  Windows, Winsock,
  SysUtils,
  ooOS.Info.Intf;

type
  TOSLocalMacAddress = class sealed(TInterfacedObject, IOSInfo)
  public
    function Value: string;
    class function New: IOSInfo;
  end;

implementation

function SendArp(DestIP, SrcIP: ULONG; pMacAddr: Pointer; PhyAddrLen: Pointer): DWord; StdCall;
  external 'iphlpapi.dll' name 'SendARP';

function TOSLocalMacAddress.Value: string;
type
  TMacID = record
    A, B: word;
    D, M, S: word;
    MAC: array [1 .. 6] of byte;
  end;
var
  RPCRTHandle: THandle;
  MacID: TMacID;
  I: ShortInt;
  fnCreateUuid: function(var FuncGetMacID: TMacID): HResult; stdcall;

  function GetProcName: {$IFDEF FPC}LPCSTR{$ELSE}LPCWSTR{$ENDIF};
  var
    OSVersionInfo: TOSVersionInfo;
  begin
    OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
    GetVersionEx(OSVersionInfo);
    result := 'UuidCreate';
    if (OSVersionInfo.dwMajorVersion >= 5) then
      result := 'UuidCreateSequential';
  end;

begin
  result := EmptyStr;
  RPCRTHandle := LoadLibrary('RPCRT4.DLL');
  @fnCreateUuid := GetProcAddress(RPCRTHandle, GetProcName);
  fnCreateUuid(MacID);
  for I := 1 to 6 do
    result := result + IntToHex(MacID.MAC[I], 2);
end;

class function TOSLocalMacAddress.New: IOSInfo;
begin
  result := TOSLocalMacAddress.Create;
end;

end.
