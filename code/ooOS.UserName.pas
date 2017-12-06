{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.UserName;

interface

uses
  Windows,
  SysUtils,
  ooOS.Info.Intf;

type
  TOSUserName = class sealed(TInterfacedObject, IOSInfo)
  public
    function Value: string;
    class function New: IOSInfo;
  end;

implementation

function TOSUserName.Value: string;
var
  Len: Cardinal;
begin
  Len := 256;
  Result := StringOfChar(#0, Len);
  Windows.GetUserName(PChar(Result), Len);
  SetLength(Result, Len);
  Result := Trim(Result);
end;

class function TOSUserName.New: IOSInfo;
begin
  Result := TOSUserName.Create;
end;

end.
