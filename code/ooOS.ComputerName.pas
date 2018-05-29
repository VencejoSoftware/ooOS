{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Computer name information
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooOS.ComputerName;

interface

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$ENDIF}

uses
{$IFDEF USE_LINUX}
  unix,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils,
  ooOS.Info.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSInfo))
  Obtain computer name
  @member(Value @seealso(IOSInfo.Value))
  @member(
    ComputerName Call OS to obtain computer name
    @return(Text with computer name)
  )
  @member(
    Create Object constructor
  )
  @member(
    New Create a new @classname as interface
  )
}
{$ENDREGION}
  TOSComputerName = class sealed(TInterfacedObject, IOSInfo)
  strict private
    _Value: String;
  private
    function ComputerName: string;
  public
    function Value: string;
    constructor Create;
    class function New: IOSInfo;
  end;

implementation

function TOSComputerName.Value: string;
begin
  Result := _Value;
end;

function TOSComputerName.ComputerName: string;
{$IFDEF USE_LINUX}
begin
  Result := GetHostName;
{$ELSE}
var
  Len: Cardinal;
begin
  Len := Succ(MAX_COMPUTERNAME_LENGTH);
  Result := StringOfChar(#0, Len);
  Windows.GetComputerName(PChar(Result), Len);
  SetLength(Result, Len);
  Result := Trim(Result);
{$ENDIF}
end;

constructor TOSComputerName.Create;
begin
  _Value := ComputerName;
end;

class function TOSComputerName.New: IOSInfo;
begin
  Result := TOSComputerName.Create;
end;

end.
