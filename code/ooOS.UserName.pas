{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  User name information
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooOS.UserName;

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$ENDIF}

interface

uses
{$IFNDEF USE_LINUX}
  Windows,
{$ENDIF}
  SysUtils,
  ooOS.Info.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSInfo))
  Obtain current user name
  @member(Value @seealso(IOSInfo.Value))
  @member(
    UserName Call OS to obtain user name
    @return(Text with user name)
  )
  @member(
    Create Object constructor
  )
  @member(
    New Create a new @classname as interface
  )
}
{$ENDREGION}
  TOSUserName = class sealed(TInterfacedObject, IOSInfo)
  strict private
    _Value: String;
  private
    function UserName: string;
  public
    function Value: string;
    constructor Create;
    class function New: IOSInfo;
  end;

implementation

function TOSUserName.Value: string;
begin
  Result := _Value;
end;

function TOSUserName.UserName: string;
{$IFDEF USE_LINUX}
begin
  Result := GetEnvironmentVariable('USER');
{$ELSE}
var
  Len: Cardinal;
begin
  Len := 256;
  Result := StringOfChar(#0, Len);
  Windows.GetUserName(PChar(Result), Len);
  SetLength(Result, Len);
  Result := Trim(Result);
{$ENDIF}
end;

constructor TOSUserName.Create;
begin
  _Value := UserName;
end;

class function TOSUserName.New: IOSInfo;
begin
  Result := TOSUserName.Create;
end;

end.
