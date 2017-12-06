{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.RemoteMacAddress;

interface

uses
  Windows, Winsock,
  SysUtils,
  ooOS.Info.Intf;

type
  TOSRemoteMacAddress = class sealed(TInterfacedObject, IOSInfo)
  strict private
    _IP: String;
  private
    function RemoteMacAddress(const IP: RawByteString): String;
  public
    function Value: string;
    constructor Create(const IP: String);
    class function New(const IP: String): IOSInfo;
  end;

implementation

function SendArp(DestIP, SrcIP: ULONG; pMacAddr: Pointer; PhyAddrLen: Pointer): DWord; StdCall;
  external 'iphlpapi.dll' name 'SendARP';

function TOSRemoteMacAddress.RemoteMacAddress(const IP: RawByteString): String;
const
  HexChars: array [0 .. 15] of AnsiChar = '0123456789ABCDEF';
var
  dwRemoteIP: DWord;
  PhyAddrLen: Longword;
  pMacAddr: array [0 .. 7] of byte;
  I: integer;
  P: PAnsiChar;
  Return: RawByteString;
begin
  Result := EmptyStr;
  Return := '';
  dwRemoteIP := inet_addr(Pointer(IP));
  if dwRemoteIP = 0 then
    Exit;
  PhyAddrLen := 8;
  if SendArp(dwRemoteIP, 0, @pMacAddr, @PhyAddrLen) = NO_ERROR then
  begin
    if PhyAddrLen = 6 then
    begin
      SetLength(Return, 12);
      P := Pointer(Return);
      for I := 0 to 5 do
      begin
        P[0] := HexChars[pMacAddr[I] shr 4];
        P[1] := HexChars[pMacAddr[I] and $F];
        inc(P, 2);
      end;
    end;
    Result := String(Return);
  end;
end;

function TOSRemoteMacAddress.Value: string;
begin
  Result := RemoteMacAddress(RawByteString(_IP));
end;

constructor TOSRemoteMacAddress.Create(const IP: String);
begin
  _IP := IP;
end;

class function TOSRemoteMacAddress.New(const IP: String): IOSInfo;
begin
  Result := TOSRemoteMacAddress.Create(IP);
end;

end.
