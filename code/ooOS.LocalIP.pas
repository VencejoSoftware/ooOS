{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.LocalIP;

interface

uses
  Windows, Winsock,
  SysUtils,
  ooOS.Info.Intf;

type
  TOSLocalIP = class sealed(TInterfacedObject, IOSInfo)
  public
    function Value: string;
    class function New: IOSInfo;
  end;

implementation

function TOSLocalIP.Value: string;
const
  MAX_LEN = 50;
var
  Buffer: array [0 .. MAX_LEN + 1] of AnsiChar;
  Host: PHostEnt;
  IP: PAnsichar;
  VersionRequested: word;
  SAData: TWSAData;
begin
  VersionRequested := MAKEWORD(1, 1);
  WSAStartup(VersionRequested, SAData);
  GetHostName(@Buffer, MAX_LEN);
  Host := GetHostByName(@Buffer);
  IP := iNet_ntoa(PInAddr(Host^.h_addr_list^)^);
  Result := string(IP);
end;

class function TOSLocalIP.New: IOSInfo;
begin
  Result := TOSLocalIP.Create;
end;

end.
