{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Media Access Control (MAC) address information
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit OSLocalMacAddress;

interface

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$ENDIF}

uses
{$IFDEF USE_LINUX}
  OSRemoteMacAddress,
  OSLocalIP,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils,
  OSInfo;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSInfo))
  Media Access Control (MAC) address information
  @member(Value @seealso(IOSInfo.Value))
  @member(
    MacAddress Call specific OS library to obtain MAC
    @return(Text with mac address)
  )
  @member(
    Create Object constructor
  )
  @member(
    New Create a new @classname as interface
  )
}
{$ENDREGION}
  TOSLocalMacAddress = class sealed(TInterfacedObject, IOSInfo)
  strict private
    _Value: String;
  private
    function MacAddress: String;
  public
    function Value: string;
    constructor Create;
    class function New: IOSInfo;
  end;

implementation

function TOSLocalMacAddress.Value: string;
begin
  Result := _Value;
end;

function TOSLocalMacAddress.MacAddress: String;
{$IFDEF USE_LINUX}
begin
  Result := TOSRemoteMacAddress.New(TOSLocalIP.New.Value).Value;
{$ELSE}
type
  TMACBlock = (Block1 = 1, Block2, Block3, Block4, Block5, Block6);

  TMacID = record
    A, B: word;
    D, M, S: word;
    Blocks: array [TMACBlock] of Byte;
  end;
var
  RPCRTHandle: THandle;
  MacID: TMacID;
  Block: TMACBlock;
  fnLibraryMethod: function(var FuncGetMacID: TMacID): HResult; stdcall;

  function LibraryMethodName: {$IFDEF FPC}LPCSTR{$ELSE}LPCWSTR{$ENDIF};
  var
    OSVersionInfo: TOSVersionInfo;
  begin
    OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
    GetVersionEx(OSVersionInfo);
    if (OSVersionInfo.dwMajorVersion >= 5) then
      Result := 'UuidCreateSequential'
    else
      Result := 'UuidCreate';
  end;

begin
  Result := EmptyStr;
  RPCRTHandle := LoadLibrary('RPCRT4.DLL');
  @fnLibraryMethod := GetProcAddress(RPCRTHandle, LibraryMethodName);
  fnLibraryMethod(MacID);
  for Block := Low(TMACBlock) to High(TMACBlock) do
    Result := Result + IntToHex(MacID.Blocks[Block], 2);
{$ENDIF}
end;

constructor TOSLocalMacAddress.Create;
begin
  _Value := MacAddress;
end;

class function TOSLocalMacAddress.New: IOSInfo;
begin
  Result := TOSLocalMacAddress.Create;
end;

end.
