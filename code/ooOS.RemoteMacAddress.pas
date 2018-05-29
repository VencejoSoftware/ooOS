{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Obtain Media Access Control (MAC) from IP address information
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooOS.RemoteMacAddress;

interface

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$ENDIF}

uses
{$IFDEF FPC}
{$IFDEF USE_LINUX}
  Process, RegExpr, Unix,
{$ENDIF}
{$ENDIF}
{$IFNDEF USE_LINUX}
  Windows, Sockets, Winsock,
{$ENDIF}
  SysUtils,
  ooOS.Info.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSInfo))
  Obtain remote Media Access Control (MAC) address from IP
  @member(Value @seealso(IOSInfo.Value))
  @member(
    RemoteMacAddress Call specific OS library to obtain MAC
    @param(IP IP address)
    @return(Text with mac address)
  )
  @member(
    Create Object constructor
    @param(IP IP address)
  )
  @member(
    New Create a new @classname as interface
    @param(IP IP address)
  )
}
{$ENDREGION}
  TOSRemoteMacAddress = class sealed(TInterfacedObject, IOSInfo)
  strict private
    _Value: String;
  private
    function RemoteMacAddress(const IP: String): String;
  public
    function Value: string;
    constructor Create(const IP: String);
    class function New(const IP: String): IOSInfo;
  end;

implementation

{$IFNDEF USE_LINUX}
function SendArp(DestIP, SrcIP: Longint; pMacAddr: Pointer; PhyAddrLen: Pointer): DWord; StdCall;
  external 'iphlpapi.dll' name 'SendARP';
{$ENDIF}

function TOSRemoteMacAddress.RemoteMacAddress(const IP: String): String;
{$IFDEF FPC}
{$IFDEF USE_LINUX}
var
  reponse: string;
  re: TRegExpr;
begin
  Result := EmptyStr;
  RunCommand('ping', ['-c', '1', IP], reponse);
  if pos('Unreachable', reponse) < 1 then
  begin
    RunCommand('arp', ['-a', IP], reponse);
    try
      re := TRegExpr.Create;
      re.Expression := '[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:' + '[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}';
      if re.Exec(reponse) then
        Result := StringReplace(UpperCase(re.Match[0]), ':', '', [rfReplaceAll]);
    finally
      re.Free;
    end;
  end;
{$ELSE}

type
  TMACBlock = (Block1 = 1, Block2, Block3, Block4, Block5, Block6);
var
  DestIP: Longint;
  MACLen: Longint;
  Blocks: array [TMACBlock] of Byte;
  Block: TMACBlock;
begin
  Result := EmptyStr;
  DestIP := inet_addr(PAnsiChar(AnsiString(IP)));
  if DestIP <> 0 then
  begin
    if SendArp(DestIP, 0, @Blocks, @MACLen) = NO_ERROR then
      for Block := Low(TMACBlock) to High(TMACBlock) do
        Result := Result + IntToHex(Blocks[Block], 2);
  end;
{$ENDIF}
{$ELSE}

type
  TMACBlock = (Block1 = 1, Block2, Block3, Block4, Block5, Block6);
var
  DestIP: Longint;
  MACLen: Longint;
  Blocks: array [TMACBlock] of Byte;
  Block: TMACBlock;
begin
  Result := EmptyStr;
  DestIP := Winsock.inet_addr(PAnsiChar(AnsiString(IP)));
  if DestIP <> 0 then
  begin
    if SendArp(DestIP, 0, @Blocks, @MACLen) = NO_ERROR then
      for Block := Low(TMACBlock) to High(TMACBlock) do
        Result := Result + IntToHex(Blocks[Block], 2);
  end;
{$ENDIF}
end;

function TOSRemoteMacAddress.Value: string;
begin
  Result := _Value;
end;

constructor TOSRemoteMacAddress.Create(const IP: String);
begin
  _Value := RemoteMacAddress(IP);
end;

class function TOSRemoteMacAddress.New(const IP: String): IOSInfo;
begin
  Result := TOSRemoteMacAddress.Create(IP);
end;

end.
