{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Local IP address information
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit OSLocalIP;

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$ENDIF}

interface

uses
{$IFDEF USE_LINUX}
  sockets, baseunix, unix,
{$ELSE}
  Windows, Winsock,
{$ENDIF}
  SysUtils,
  OSInfo;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSInfo))
  Obtain local IP address
  @member(Value @seealso(IOSInfo.Value))
  @member(
    IP Call OS to obtain local IP
    @return(Text with local IP)
  )
  @member(
    Create Object constructor
  )
  @member(
    New Create a new @classname as interface
  )
}
{$ENDREGION}
  TOSLocalIP = class sealed(TInterfacedObject, IOSInfo)
  strict private
    _Value: String;
  private
    function IP: string;
  public
    function Value: string;
    constructor Create;
    class function New: IOSInfo;
  end;

implementation

function TOSLocalIP.Value: string;
begin
  Result := _Value;
end;

function TOSLocalIP.IP: string;
{$IFDEF USE_LINUX}
const
  CN_GDNS_ADDR = '127.0.0.1';
  CN_GDNS_PORT = 53;
var
  sock: longint;
  HostAddr: TSockAddr;
  l: integer;
  UnixAddr: TInetSockAddr;
begin
  Result := EmptyStr;
  sock := fpsocket(AF_INET, SOCK_DGRAM, 0);
  UnixAddr.sin_family := AF_INET;
  UnixAddr.sin_port := htons(CN_GDNS_PORT);
  UnixAddr.sin_addr := StrToHostAddr(CN_GDNS_ADDR);
  if (fpconnect(sock, @UnixAddr, SizeOf(UnixAddr)) = 0) then
  begin
    try
      l := SizeOf(HostAddr);
      if (fpgetsockname(sock, @HostAddr, @l) = 0) then
        Result := NetAddrToStr(HostAddr.sin_addr);
    finally
      FpClose(sock);
    end;
  end;
{$ELSE}

const
  MAX_LEN = 50;
var
  Buffer: array [0 .. MAX_LEN + 1] of AnsiChar;
  Host: PHostEnt;
  IP: PAnsichar;
  VersionRequested: Word;
  SAData: TWSAData;
begin
  VersionRequested := MAKEWORD(1, 1);
  WSAStartup(VersionRequested, SAData);
  GetHostName(@Buffer, MAX_LEN);
  Host := GetHostByName(@Buffer);
  IP := Winsock.inet_ntoa(PInAddr(Host^.h_addr_list^)^);
  Result := string(IP);
{$ENDIF}
end;

constructor TOSLocalIP.Create;
begin
  _Value := IP;
end;

class function TOSLocalIP.New: IOSInfo;
begin
  Result := TOSLocalIP.Create;
end;

end.
